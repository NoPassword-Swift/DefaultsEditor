//
//  DefaultsEditorController.swift
//  DefaultsEditor
//

#if os(iOS)

import CoreCombine
import NPCombine
import NPKit
import StaticTable
import UIKit

public class DefaultsEditorController: TableController {
	private let defaults: [CBUserDefaults]
	private var activeDefault: CBUserDefaults

	private let filters: [DefaultsFilter]
	private var activeFilter: DefaultsFilter

	private var data = [String]()

	public init(defaults: [CBUserDefaults] = [.standard], filters: [DefaultsFilter] = [.none, .appleBuiltin]) {
		precondition(!defaults.isEmpty, "Must supply at least one CBUserDefaults")
		precondition(!filters.isEmpty, "Must supply at least one Filter")
		self.defaults = defaults
		self.activeDefault = self.defaults[0]
		self.filters = filters
		self.activeFilter = self.filters[0]
		super.init(style: .insetGrouped)
		self.title = "UserDefaults"
	}

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		self.data = self.activeDefault.alphabeticallySortedKeys.filter { self.activeFilter.shouldFilter($0) }

		let defaultMenu = UIMenu(options: .singleSelection, children: self.defaults.map { `default` -> UIAction in
			UIAction(title: `default`.name, state: self.activeDefault == `default` ? .on : .off) { [weak self] _ in
				guard let self = self else { return }
				self.setDefault(`default`)
			}
		})
		let filterMenu = UIMenu(options: .singleSelection, children: self.filters.map { filter -> UIAction in
			UIAction(title: filter.name, state: self.activeFilter == filter ? .on : .off) { [weak self] _ in
				guard let self = self else { return }
				self.setFilter(filter)
			}
		})
		self.navigationItem.rightBarButtonItems = [
			UIBarButtonItem(image: UIImage(systemName: "tablecells")!, menu: defaultMenu),
			UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle")!, menu: filterMenu),
		]
	}

	public override func tableView(_ tableView: TableView, cellForRowAt indexPath: IndexPath) -> TableCell {
			let key = self.data[indexPath.section]
			guard let value = self.activeDefault.defaults.value(forKey: key) else {
				let cell = tableView.dequeueText(for: indexPath)
				cell.title = "INVALID"
				return cell
			}

			switch value {
				case is Bool:
					let cell = tableView.dequeueToggle(for: indexPath)
					cell.title = " "
					cell.trackToggle(to: self.activeDefault.boolSubject(forKey: key))
					return cell
				case is String:
					let cell = tableView.dequeueText(for: indexPath)
					cell.bindTitle(to: self.activeDefault.stringSubject(forKey: key))
					cell.accessoryType = .disclosureIndicator
					return cell
				case is Double:
					let cell = tableView.dequeueText(for: indexPath)
					cell.bindTitle(to: self.activeDefault.doubleSubject(forKey: key).map { $0.description })
					cell.accessoryType = .disclosureIndicator
					return cell
				case is Date:
					let cell = tableView.dequeueText(for: indexPath)
					cell.bindTitle(to: self.activeDefault.dateSubject(forKey: key).map {
						let dateFormatter = DateFormatter()
						dateFormatter.dateStyle = .long
						dateFormatter.timeStyle = .short
						return dateFormatter.string(from: $0)
					})
					cell.accessoryType = .disclosureIndicator
					return cell
				case is Array<Any>:
					let cell = tableView.dequeueText(for: indexPath)
					cell.bindTitle(to: self.activeDefault.arraySubject(forKey: key).map { "Array (\($0.count))" })
					cell.accessoryType = .disclosureIndicator
					return cell
				default:
					print("Unhandled: \(type(of: value))")
					print(" - \(value)")
					let cell = tableView.dequeueText(for: indexPath)
					cell.title = nil
					return cell
			}
	}

	// MARK: UITableViewDataSource

	public override func numberOfSections(in tableView: UITableView) -> Int {
		return self.data.count
	}

	public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return self.data[section]
	}

	public override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			self.delete(indexPath)
		}
	}

	// MARK: UITableViewDelegate

	public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let key = self.data[indexPath.section]
		guard let value = self.activeDefault.defaults.value(forKey: key) else {
			tableView.deselectRow(at: indexPath, animated: true)
			return
		}

		switch value {
			case is String:
				self.navigationController?.pushViewController(
					StringEditorController(subject: self.activeDefault.stringSubject(forKey: key)),
					animated: true)
			case is Double:
				self.navigationController?.pushViewController(
					DoubleEditorController(subject: self.activeDefault.doubleSubject(forKey: key)),
					animated: true)
			case is Date:
				self.navigationController?.pushViewController(
					DateEditorController(subject: self.activeDefault.dateSubject(forKey: key)),
					animated: true)
			case is Array<Any>:
				self.navigationController?.pushViewController(
					ArrayDetailController(subject: self.activeDefault.arraySubject(forKey: key)),
					animated: true)
			default:
				tableView.deselectRow(at: indexPath, animated: true)
		}
	}

	// MARK: Reload

	private func setFilter(_ filter: DefaultsFilter) {
		self.activeFilter = filter
		self.animateData()
	}

	private func setDefault(_ default: CBUserDefaults) {
		self.activeDefault = `default`
		self.animateData()
	}

	private func delete(_ indexPath: IndexPath) {
		self.activeDefault.delete(key: self.data[indexPath.section])
		self.animateData()
	}

	private func animateData() {
		let newData = self.activeDefault.alphabeticallySortedKeys.filter { self.activeFilter.shouldFilter($0) }
		let diff = newData.difference(from: self.data)

		self.tableView.performBatchUpdates {
			self.data = self.data.applying(diff) ?? []

			self.tableView.deleteSections(diff.removals.map { switch $0 {
				case .remove(let offset, _, _): return offset
				default: fatalError("can't happen")
			}}.reduce(into: IndexSet()) { $0.update(with: $1) }, with: .left)
			self.tableView.insertSections(diff.insertions.map { switch $0 {
				case .insert(let offset, _, _): return offset
				default: fatalError("can't happen")
			}}.reduce(into: IndexSet()) { $0.update(with: $1) }, with: .right)
		}
	}
}

#endif

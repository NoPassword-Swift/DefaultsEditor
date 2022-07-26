//
//  ArrayDetailController.swift
//  DefaultsEditor
//

#if os(iOS)

import CoreCombine
import Foundation
import StaticTable

class ArrayDetailController: DataTableController {
	public init(subject: CBSubject<Array<Any>>) {
		super.init(style: .insetGrouped)
		self.title = subject.name

		let value = subject.value
		let section = self.data.createSection(header: .string("Array (\(value.count))"))
		for item in value {
			switch item {
				case is Bool:
					section.createRow(named: .string("\(item as! Bool)"), kind: .text).enable()
				case is String:
					section.createRow(named: .string(item as! String), kind: .text).enable()
				case is Double:
					section.createRow(named: .string("\(item as! Double)"), kind: .text).enable()
				case is Date:
					let dateFormatter = DateFormatter()
					dateFormatter.dateStyle = .long
					dateFormatter.timeStyle = .short
					section.createRow(named: .string(dateFormatter.string(from: item as! Date)), kind: .text).enable()
				case is Array<Any>:
					section.createRow(named: .string("Array (\((item as! Array<Any>).count))"), kind: .text).enable()
				default:
					print("Unhandled Item: \(type(of: item))")
					print(" - \(item)")
			}
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

#endif

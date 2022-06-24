//
//  ArrayDetailController.swift
//  DefaultsEditor
//

#if os(iOS)

import CoreCombine
//import NPCombine
//import NPKit
import StaticTable
import Foundation
//import UIKit

class ArrayDetailController: StaticTableController {
	public init(subject: CBSubject<Array<Any>>) {
		let value = subject.value
		var data = TableData()
		var section = TableSection("Array (\(value.count))")
		for item in value {
			switch item {
				case is Bool: section.add(row: TableRow("\(item as! Bool)", kind: .text))
				case is String: section.add(row: TableRow(item as! String, kind: .text))
				case is Double: section.add(row: TableRow("\(item as! Double)", kind: .text))
				case is Date:
					let dateFormatter = DateFormatter()
					dateFormatter.dateStyle = .long
					dateFormatter.timeStyle = .short
					section.add(row: TableRow(dateFormatter.string(from: item as! Date), kind: .text))
				case is Array<Any>: section.add(row: TableRow("Array (\((item as! Array<Any>).count))", kind: .text))
				default:
					print("Unhandled Item: \(type(of: item))")
					print(" - \(item)")
			}
		}
		data.add(section: section)
		super.init(style: .insetGrouped, data: data)
		self.title = subject.name
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

#endif

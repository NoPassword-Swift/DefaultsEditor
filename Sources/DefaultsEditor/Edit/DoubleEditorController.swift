//
//  DoubleEditorController.swift
//  DefaultsEditor
//

#if os(iOS)

import Color
import CoreCombine
import Font
import NPKit
import UIKit

class DoubleEditorController: NPViewController {
	private let subject: CBSubject<Double>

	private lazy var titleLabel: NPLabel = {
		let view = NPLabel()
		view.numberOfLines = 2
		view.font = Font.preferredFont(for: .largeTitle, weight: .bold)
		view.adjustsFontSizeToFitWidth = true
		return view
	}()

	private lazy var valueView: NPTextField = {
		let view = NPTextField()
		view.keyboardType = .decimalPad
		return view
	}()

	public init(subject: CBSubject<Double>) {
		self.subject = subject
		super.init()
		self.navigationItem.largeTitleDisplayMode = .never
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .save, primaryAction: UIAction { [weak self] _ in
			guard let self = self else { return }
			self.subject.send(Double(self.valueView.text ?? "") ?? 0)
			self.navigationController?.popViewController(animated: true)
		})
	}

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		self.titleLabel.text = self.subject.name
		self.valueView.text = self.subject.value.description

		self.view.addSubview(self.titleLabel)
		self.view.addSubview(self.valueView)
		NSLayoutConstraint.activate([
			self.titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: self.view.safeAreaLayoutGuide.topAnchor, multiplier: 0.5),
			self.titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: self.view.leadingAnchor, multiplier: 2.5),
			self.titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			self.valueView.topAnchor.constraint(equalToSystemSpacingBelow: self.titleLabel.bottomAnchor, multiplier: 1),
			self.valueView.leadingAnchor.constraint(equalToSystemSpacingAfter: self.view.leadingAnchor, multiplier: 2.5),
			self.view.trailingAnchor.constraint(equalToSystemSpacingAfter: self.valueView.trailingAnchor, multiplier: 2.5),
		])
	}

	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.valueView.becomeFirstResponder()
	}

	public override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.valueView.resignFirstResponder()
	}
}

#endif

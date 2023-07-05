//
//  RangeView.swift
//  UIRangeSlider
//
//  Created by Юлия Филимонова on 19.06.2023.
//

import UIKit

protocol RangeTextViewDelegate: AnyObject {
    func editingDidBegin(_ sender: UITextView)
    func editingDidEnd(_ sender: UITextView)
}

class RangeView: UIView {

    let startTextView = UITextView()
    let endTextView = UITextView()
    let stackView = UIStackView()

    weak var delegate: RangeTextViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        styleView()
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 35)
    }

}

extension RangeView {

    func styleView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        startTextView.translatesAutoresizingMaskIntoConstraints = false
        endTextView.translatesAutoresizingMaskIntoConstraints = false

        startTextView.backgroundColor = .secondarySystemBackground
        startTextView.textAlignment = .center
        startTextView.font = UIFont.preferredFont(forTextStyle: .body)
        startTextView.keyboardType = .numberPad
        startTextView.delegate = self

        endTextView.backgroundColor = .secondarySystemBackground
        endTextView.textAlignment = .center
        endTextView.font = UIFont.preferredFont(forTextStyle: .body)
        endTextView.keyboardType = .numberPad
        endTextView.delegate = self

        stackView.axis = .horizontal
        stackView.spacing = 40
        stackView.distribution = .fillEqually
    }

    func setView() {
        self.addSubview(stackView)
        [startTextView, endTextView].forEach { stackView.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

}

//MARK: - TextViewDelegate

extension RangeView: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.editingDidBegin(textView)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.editingDidEnd(textView)
    }

}

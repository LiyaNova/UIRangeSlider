//
//  ViewController.swift
//  UIRangeSlider
//
//  Created by Юлия Филимонова on 13.06.2023.
//

import UIKit

class ViewController: UIViewController {

    private var minNumber: CGFloat = 19 // default 0,  should be/can be set depending on a range
    private var defaultMinNumber: CGFloat = 19 // == initial minPrice
    private var maxNumber: CGFloat = 2023 // no default value, should be/can be set depending on a range
    private var newMaxNumber: CGFloat = 0 // default 0, flexible max value

    private var rangeViewWithTextViews = RangeView()
    private lazy var rangeSlider: UIRangeSlider = {
        var sideInset: CGFloat { 40 }
        let sliderFrame = CGRect(x: sideInset, y: UIScreen.main.bounds.height / 2,
                                 width: UIScreen.main.bounds.width - sideInset * 2,
                                 height: 10)

        let slider = UIRangeSlider(frame: sliderFrame)
        slider.trackTintColor =  UIColor.systemFill
        slider.trackHighlightTintColor = UIColor.gray
        slider.thumbImage = UIImage(named: "thumb")!
        slider.thumbImageSize = CGSize(width: 18, height: 18)
        slider.configurate()

        slider.addTarget(self, action: #selector(rangeSliderAction(_ :)), for: .valueChanged)
        return slider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        hideKeyboardOnTap()
    }

    //MARK: - Settings

    private func configureUI() {
        view.backgroundColor = .white
        setView()
        setValues(minNumber, maxNumber)
        rangeViewWithTextViews.delegate = self
    }

    private func setView() {
        [rangeViewWithTextViews, rangeSlider].forEach { view.addSubview($0)}

        NSLayoutConstraint.activate([
            rangeViewWithTextViews.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 6),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: rangeViewWithTextViews.trailingAnchor, multiplier: 6),
            rangeViewWithTextViews.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60)
        ])
    }

    private func setValues(_ lowerValue: CGFloat, _ upperValue: CGFloat) {
        rangeSlider.setStartAndEndRangeValues(upperValue, lowerValue)
        rangeViewWithTextViews.startTextView.text = String(rangeSlider.startNumber)
        rangeViewWithTextViews.endTextView.text = String(rangeSlider.endNumber)
    }

    private func setNewValue(_ lowerValue: CGFloat, _ upperValue: CGFloat) {
        rangeSlider.setNewRangeValues(upperValue, lowerValue, defaultMinNumber)
        rangeViewWithTextViews.startTextView.text = String(rangeSlider.startNumber)
        rangeViewWithTextViews.endTextView.text = String(rangeSlider.endNumber)
    }

    //MARK: - RangeActions

    @objc private func rangeSliderAction(_ sender: UIRangeSlider) {
        let lowerValue = sender.startNumber
        let upperValue = sender.endNumber
        minNumber = CGFloat(lowerValue)
        newMaxNumber = CGFloat(upperValue)
        rangeViewWithTextViews.startTextView.text = String(lowerValue)
        rangeViewWithTextViews.endTextView.text = String(upperValue)
    }
}

//MARK: - RangeTextViewDelegate

extension ViewController: RangeTextViewDelegate {
    
    private var startNumberTextView: UITextView { rangeViewWithTextViews.startTextView }
    private var endNumberTextView: UITextView { rangeViewWithTextViews.endTextView }

    func editingDidBegin(_ sender: UITextView) {
        if sender == startNumberTextView && startNumberTextView.isFirstResponder {
            sender.text = ""
        } else {
            startNumberTextView.text = String(rangeSlider.startNumber)
        }
        if sender == endNumberTextView && endNumberTextView.isFirstResponder {
            sender.text = ""
        } else {
            endNumberTextView.text = String(rangeSlider.endNumber)
        }
    }

    func editingDidEnd(_ sender: UITextView) {
        if sender == startNumberTextView {

            if sender.text == "" {
                sender.text = String(rangeSlider.startNumber)
            }

            guard let number = Int(startNumberTextView.text)  else { return }
            minNumber = CGFloat(number)
            checkAndSetRangeWithStartNumber(&minNumber, maxNumber)

        } else if sender == endNumberTextView {

            if sender.text == "" {
                sender.text = String(rangeSlider.endNumber)
            }

            guard let number = Int(endNumberTextView.text)  else { return }
            newMaxNumber = CGFloat(number)
            checkAndSetRangeWithEndNumber(maxNumber)

        }
    }

    private func checkAndSetRangeWithStartNumber(_ minNumber: inout CGFloat,_ maxNumber: CGFloat) {
        if  (newMaxNumber == 0 || newMaxNumber >= maxNumber) && (minNumber < maxNumber && minNumber > defaultMinNumber) {
            setNewValue(minNumber, maxNumber)
        } else  if (newMaxNumber == 0 || newMaxNumber >= maxNumber) && (minNumber > maxNumber || minNumber < defaultMinNumber) {
            minNumber = defaultMinNumber
            setNewValue(defaultMinNumber, maxNumber)
        } else if newMaxNumber != 0 && newMaxNumber < maxNumber &&  minNumber < newMaxNumber &&  minNumber > defaultMinNumber {
            setNewValue(minNumber, newMaxNumber)
        } else if newMaxNumber != 0 && newMaxNumber < maxNumber && (minNumber > newMaxNumber || minNumber < defaultMinNumber) {
            minNumber = defaultMinNumber
            setNewValue(defaultMinNumber, newMaxNumber)
        }
    }

    private func checkAndSetRangeWithEndNumber(_ maxNumber: CGFloat) {
        if newMaxNumber != 0 && newMaxNumber < maxNumber && newMaxNumber > minNumber {
            setNewValue(minNumber, newMaxNumber)
        } else {
            setNewValue(minNumber, maxNumber)
        }
    }

}

//MARK: - Keyboard

extension ViewController {

    private func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

}

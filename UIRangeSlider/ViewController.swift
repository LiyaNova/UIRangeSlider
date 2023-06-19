//
//  ViewController.swift
//  UIRangeSlider
//
//  Created by Юлия Филимонова on 13.06.2023.
//

import UIKit

class ViewController: UIViewController {

    private var minPrice: CGFloat = 19 // default 0,  should be/can be set depending on a range
    private var defaultMinPrice: CGFloat = 19 // == minPrice
    private var maxPrice: CGFloat? = 2023 // no default value, should be/can be set depending on a range
    private var newMaxPrice: CGFloat = 0 // default 0, flexible max value

    private var rangeView = RangeView()
    private lazy var rangeSlider: UIRangeSlider = {
        var sideInset: CGFloat { 40 }
        let sliderFrame = CGRect(x: sideInset, y: UIScreen.main.bounds.height / 2,
                                 width: UIScreen.main.bounds.width - sideInset * 2,
                                 height: 10)

        let slider = UIRangeSlider(frame: sliderFrame)
        slider.trackTintColor =  UIColor.lightGray
        slider.trackHighlightTintColor = UIColor.gray
        slider.thumbImage = UIImage(named: "thumb")!
        slider.thumbImageSize = CGSize(width: 25, height: 25)
        slider.configurate()

        slider.addTarget(self, action: #selector(rangeSliderAction(_ :)), for: .valueChanged)

        return slider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        hideKeyboardOnTap()
    }

    private func configureUI() {
        setView()
        view.backgroundColor = .white
        rangeView.delegate = self
        rangeSlider.setStartAndEndRangeValues(maxPrice, minPrice)
        rangeView.startTextView.text = String(rangeSlider.startNumber)
        rangeView.endTextView.text = String(rangeSlider.endNumber)
    }

    private func setView() {
        [rangeView, rangeSlider].forEach { view.addSubview($0)}

        NSLayoutConstraint.activate([
            rangeView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 6),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: rangeView.trailingAnchor, multiplier: 6),
            rangeView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60)
        ])
    }

    private func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    //MARK: - RangeActions

    @objc private func rangeSliderAction(_ sender: UIRangeSlider) {
        let lowerPrice = sender.startNumber
        let upperPrice = sender.endNumber
        minPrice = CGFloat(lowerPrice)
        newMaxPrice = CGFloat(upperPrice)
        rangeView.startTextView.text = String(lowerPrice)
        rangeView.endTextView.text = String(upperPrice)
    }

    private func setNewValue(_ lowerPrice: CGFloat, _ upperPrice: CGFloat) {
        rangeSlider.setNewRangeValues(upperPrice, lowerPrice, defaultMinPrice)
        rangeView.startTextView.text = String(rangeSlider.startNumber)
        rangeView.endTextView.text = String(rangeSlider.endNumber)
    }

}

//MARK: - RangeTextViewDelegate

extension ViewController: RangeTextViewDelegate {
    
    private var startNumberTextView: UITextView { rangeView.startTextView }
    private var endNumberTextView: UITextView { rangeView.endTextView }

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
                startNumberTextView.text = String(rangeSlider.startNumber)
            }

            guard let price = Int(startNumberTextView.text)  else { return }
            guard let endPrice =  maxPrice  else { return }
            minPrice = CGFloat(price)

            if  (newMaxPrice == 0 || newMaxPrice >= endPrice) && (minPrice < endPrice && minPrice > defaultMinPrice) {
                setNewValue(minPrice, endPrice)
            } else  if (newMaxPrice == 0 || newMaxPrice >= endPrice) && (minPrice > endPrice || minPrice < defaultMinPrice) {
                minPrice = defaultMinPrice
                setNewValue(defaultMinPrice, endPrice)
            } else if newMaxPrice != 0 && newMaxPrice < endPrice &&  minPrice < newMaxPrice {
                setNewValue(minPrice, newMaxPrice)
            } else if newMaxPrice != 0 && newMaxPrice < endPrice && minPrice > newMaxPrice  {
                minPrice = defaultMinPrice
                setNewValue(defaultMinPrice, newMaxPrice)
            }

        } else if sender == endNumberTextView {

            if sender.text == "" {
                endNumberTextView.text = String(rangeSlider.endNumber)
            }

            guard let price = Int(endNumberTextView.text)  else { return }
            guard let endPrice =  maxPrice  else { return }
            newMaxPrice = CGFloat(price)

            if newMaxPrice != 0 && newMaxPrice < endPrice && newMaxPrice > minPrice {
                setNewValue(minPrice, newMaxPrice)
            } else {
                setNewValue(minPrice, endPrice)
            }
        }

    }

}

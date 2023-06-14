//
//  ViewController.swift
//  UIRangeSlider
//
//  Created by Юлия Филимонова on 13.06.2023.
//

import UIKit

class ViewController: UIViewController {

    private var maxPrice: CGFloat?
    private var newMaxPrice: CGFloat = 0
    private var minPrice: CGFloat = 0
    private var defaultMinPrice: CGFloat = 0

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
        slider.addTarget(self, action: #selector(rangeSliderEndAction(_ :)), for: .touchUpInside)
        return slider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(rangeSlider)
    }



    //MARK: - SetData

    private func setStartAndEndPrices(_ upperPrice: CGFloat?, _ lowerPrice: CGFloat?) {
        guard let lowerPrice = lowerPrice else { return }
        guard let upperPrice = upperPrice else { return }
        rangeSlider.upperPrice = upperPrice
        rangeSlider.lowerPrice = lowerPrice
//        endTextView.text = String(rangeSlider.endNumber)
//        startTextView.text = String(rangeSlider.startNumber)
        rangeSlider.updateLayerFrames()
    }

    private func setNewValue(_ lowerPrice: CGFloat, _ upperPrice: CGFloat) {
        let priceRange = rangeSlider.upperPrice - rangeSlider.lowerPrice
        rangeSlider.lowerValue = 1.0 / (priceRange/(lowerPrice - defaultMinPrice))
        rangeSlider.upperValue = 1.0 / (priceRange/(upperPrice - defaultMinPrice))
//        startTextView.text = String(rangeSlider.startNumber)
//        endTextView.text = String(rangeSlider.endNumber)
        rangeSlider.updateLayerFrames()
    }

    @objc private func rangeSliderAction(_ sender: UIRangeSlider) {
        let lowerPrice = sender.startNumber
        let upperPrice = sender.endNumber
        minPrice = CGFloat(lowerPrice)
        newMaxPrice = CGFloat(upperPrice)
//        startTextView.text = String(lowerPrice)
//        endTextView.text = String(upperPrice)
    }

    @objc private func rangeSliderEndAction(_ sender: UIRangeSlider) {
        let lowerPrice = sender.startNumber
        let upperPrice = sender.endNumber
        minPrice = CGFloat(lowerPrice)
        newMaxPrice = CGFloat(upperPrice)
//        startTextView.text = String(lowerPrice)
//        endTextView.text = String(upperPrice)

    }


}


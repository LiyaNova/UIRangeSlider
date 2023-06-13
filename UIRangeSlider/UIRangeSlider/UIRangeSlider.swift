//
//  RangeSlider.swift
//  Flubble
//
//  Created by Юлия Филимонова on 14.12.2022.
//

import UIKit

class UIRangeSlider: UIControl {

    var minimumValue: CGFloat = 0.0
    var maximumValue: CGFloat = 1.0
    var lowerValue: CGFloat = 0.0
    var upperValue: CGFloat = 1.0

    let trackLayer = UIRangeSliderTrackLayer()
    let lowerThumbImageView = UIImageView()
    let upperThumbImageView = UIImageView()
    var previousLocation = CGPoint()

    var trackTintColor: UIColor
    var trackHighlightTintColor: UIColor
    var thumbImage: UIImage
    var thumbImageSize: CGSize

    var upperPrice: CGFloat = 0
    var lowerPrice: CGFloat = 0

    var startNumber: Int {
        let priceRange = upperPrice - lowerPrice
        return lround((lowerValue + 1.0 / (priceRange/lowerPrice)) * priceRange)
    }

    var endNumber: Int {
        let priceRange = upperPrice - lowerPrice
        return lround((upperValue + 1.0 / (priceRange/lowerPrice)) * priceRange)
    }

    init(thumbImageSize: CGSize, thumbImage: UIImage, trackTintColor: UIColor, trackHighlightTintColor: UIColor,frame: CGRect) {
        self.thumbImageSize = thumbImageSize
        self.thumbImage = thumbImage
        self.trackTintColor = trackTintColor
        self.trackHighlightTintColor = trackHighlightTintColor
        super.init(frame: frame)

        configureUI()
        updateLayerFrames()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
//MARK: - UIConfiguration

extension UIRangeSlider {
    
    private func configureUI() {
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)

        lowerThumbImageView.image = thumbImage
        addSubview(lowerThumbImageView)

        upperThumbImageView.image = thumbImage
        addSubview(upperThumbImageView)
    }


   func updateLayerFrames() {
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        lowerThumbImageView.frame = CGRect(origin: thumbOriginForValue(lowerValue),
                                           size: thumbImageSize)
        upperThumbImageView.frame = CGRect(origin: thumbOriginForValue(upperValue),
                                           size: thumbImageSize)
    }

    func positionForValue(_ value: CGFloat) -> CGFloat {
        return bounds.width * value
    }

    private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
        let x = positionForValue(value) - thumbImageSize.width / 2
        return CGPoint(x: x, y: (bounds.height - thumbImageSize.height) / 2)
    }

}

//MARK: - UIRangeSliderTracking

extension UIRangeSlider {

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)

        if lowerThumbImageView.frame.contains(previousLocation) {
            lowerThumbImageView.isHighlighted = true
        } else if upperThumbImageView.frame.contains(previousLocation) {
            upperThumbImageView.isHighlighted = true
        }

        return lowerThumbImageView.isHighlighted || upperThumbImageView.isHighlighted
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.width

        previousLocation = location

        if lowerThumbImageView.isHighlighted {
            lowerValue += deltaValue
            lowerValue = boundValue(lowerValue, toLowerValue: minimumValue,
                                    upperValue: upperValue)
        } else if upperThumbImageView.isHighlighted {
            upperValue += deltaValue
            upperValue = boundValue(upperValue, toLowerValue: lowerValue,
                                    upperValue: maximumValue)
        }

        CATransaction.begin()
        CATransaction.setDisableActions(true)

        updateLayerFrames()

        CATransaction.commit()

        sendActions(for: .valueChanged)

        return true
    }

    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat,
                            upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbImageView.isHighlighted = false
        upperThumbImageView.isHighlighted = false
    }


}

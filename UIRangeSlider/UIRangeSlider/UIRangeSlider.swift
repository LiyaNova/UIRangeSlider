//
//  RangeSlider.swift
//  Flubble
//
//  Created by Юлия Филимонова on 14.12.2022.
//

import UIKit

class UIRangeSlider: UIControl {
    //MARK: - Range setup properties

    private var minimumValue: CGFloat = 0.0
    private var maximumValue: CGFloat = 1.0
    private let trackLayer = UIRangeSliderTrackLayer()
    private let lowerThumbImageView = UIImageView()
    private let upperThumbImageView = UIImageView()
    private var previousLocation = CGPoint()

    //MARK: - Range settings properties

    // values to set: image and color
    var trackTintColor: UIColor = UIColor()
    var trackHighlightTintColor: UIColor = UIColor()
    var thumbImage: UIImage = UIImage()

    // default values, can be reset: image size and hit area of UIRangeSlider
    var thumbImageSize: CGSize = CGSize(width: 20, height: 20)
    var minimumHitArea: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 100)

    // values to correct UIRangeSlider state depending on set lower/upper numbers:
    // UIRangeSlider upper and lower values
    var lowerValue: CGFloat = 0.0
    var upperValue: CGFloat = 1.0
    // Set lower/upper numbers (for example, price)
    var upperRangeNumber: CGFloat = 0.0
    var lowerRangeNumber: CGFloat = 0.0
    private var numbersRange: CGFloat { upperRangeNumber - lowerRangeNumber }

    // Сomputed properties, final start and end UIRangeSlider values to show
    var startNumber: Int {
        return numbersRange == 0 ? Int(upperRangeNumber) :
                                   lround((lowerValue + 1.0 / (numbersRange/lowerRangeNumber)) * numbersRange)
    }

    var endNumber: Int {
        return numbersRange == 0 ? Int(upperRangeNumber) :
                                   lround((upperValue + 1.0 / (numbersRange/lowerRangeNumber)) * numbersRange)
    }

    //MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setStartAndEndSliderValues(_ upperNumber: CGFloat, _ lowerNumber: CGFloat) {
        upperRangeNumber = upperNumber
        lowerRangeNumber = lowerNumber
        updateLayerFrames()
    }

    func setNewRangeAndUpdateSlider(_ upperNumber: CGFloat, _ lowerNumber: CGFloat,_ defaultMinNumber: CGFloat) {
        setNewSliderRange(upperNumber, lowerNumber, defaultMinNumber)
        updateLayerFrames()
    }

   func setNewSliderRange(_ upperNumber: CGFloat, _ lowerNumber: CGFloat,_ defaultMinNumber: CGFloat) {
        lowerValue = 1.0 / (numbersRange/(lowerNumber - defaultMinNumber))
        upperValue = 1.0 / (numbersRange/(upperNumber - defaultMinNumber))
    }

}
//MARK: - UIConfiguration

extension UIRangeSlider {

    func configurate() {
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        lowerThumbImageView.image = thumbImage
        upperThumbImageView.image = thumbImage

        layer.addSublayer(trackLayer)
        addSubview(lowerThumbImageView)
        addSubview(upperThumbImageView)
        
        updateLayerFrames()
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

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let sliderSize = self.bounds.size
        let widthToAdd = max(minimumHitArea.width - sliderSize.width, 0)
        let heightToAdd = max(minimumHitArea.height - sliderSize.height, 0)
        let largerFrame = self.bounds.insetBy(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
        return (largerFrame.contains(point)) ? self : nil
    }

}


//
//  UIRangeSliderTests.swift
//  UIRangeSliderTests
//
//  Created by Юлия Филимонова on 04.07.2023.
//

import XCTest
@testable import UIRangeSlider

final class UIRangeSliderTests: XCTestCase {

    //Arrange
    var sut: UIRangeSlider!
    var defaultNumber: CGFloat!

    override func setUpWithError() throws {
        sut = UIRangeSlider()
        defaultNumber = 5
    }

    override func tearDownWithError() throws {
        sut = nil
        defaultNumber = nil
    }

    func testUIRangeSlider_WhenRangeLowerAndUpperValuesEqual_SliderStartAndEndNumbersEqual() {
        //Act
        sut.lowerRangeNumber = defaultNumber
        sut.upperRangeNumber = defaultNumber
        //Assert
        XCTAssertEqual(sut.startNumber, sut.endNumber)
    }

    func testUIRangeSlider_WhenRangeLowerAndUpperValuesNotEqual_SliderStartAndEndNumbersNotEqual() {
        //Act
        sut.lowerRangeNumber = defaultNumber
        sut.upperRangeNumber = defaultNumber * 2
        //Assert
        XCTAssertNotEqual(sut.startNumber, sut.endNumber)
    }

    func testUIRangeSlider_WhenRangeLowerAndUpperValuesNotEqual_SliderStartNumberEqualToRangeLowerValue() {
        //Act
        sut.lowerRangeNumber = defaultNumber
        sut.upperRangeNumber = defaultNumber * 2
        //Assert
        XCTAssertEqual(sut.startNumber, Int(sut.lowerRangeNumber))
    }

    func testUIRangeSlider_WhenRangeLowerAndUpperValuesNotEqual_SliderEndNumberEqualToRangeUpperValue() {
        //Act
        sut.lowerRangeNumber = defaultNumber
        sut.upperRangeNumber = defaultNumber * 2
        //Assert
        XCTAssertEqual(sut.endNumber, Int(sut.upperRangeNumber))
    }

    func testUIRangeSlider_WhenSetNewRangeValues_SliderStartAndEndNumberEqualToNewValues() {
        //Act
        sut.lowerRangeNumber = defaultNumber
        sut.upperRangeNumber = defaultNumber * 2

        let defaultMinValue = defaultNumber
        let newMinValue = defaultNumber * 2
        let newMaxValue = defaultNumber * 5

        sut.setNewSliderRange(newMaxValue, newMinValue, defaultMinValue!)
        //Assert
        XCTAssertEqual(sut.startNumber, Int(newMinValue))
        XCTAssertEqual(sut.endNumber, Int(newMaxValue))
    }
}

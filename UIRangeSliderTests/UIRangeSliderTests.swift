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
    var commonNumber: CGFloat!

    override func setUpWithError() throws {
        sut = UIRangeSlider()
        commonNumber = 5
    }

    override func tearDownWithError() throws {
        sut = nil
        commonNumber = nil
    }

    func testUIRangeSlider_WhenRangeLowerAndUpperValuesEqual_SliderStartAndEndNumbersEqual() {
        //Act
        sut.upperRangeNumber = commonNumber
        sut.lowerRangeNumber = commonNumber
        //Assert
        XCTAssertEqual(sut.startNumber, sut.endNumber)
    }

    func testUIRangeSlider_WhenRangeLowerAndUpperValuesNotEqual_SliderStartAndEndNumbersNotEqual() {
        //Act
        sut.upperRangeNumber = commonNumber
        sut.lowerRangeNumber = commonNumber * 2
        //Assert
        XCTAssertNotEqual(sut.startNumber, sut.endNumber)
    }

    func testUIRangeSlider_WhenRangeLowerAndUpperValuesNotEqual_SliderStartNumberEqualToRangeLowerValue() {
        //Act
        sut.upperRangeNumber = commonNumber
        sut.lowerRangeNumber = commonNumber * 2
        //Assert
        XCTAssertEqual(sut.startNumber, Int(sut.lowerRangeNumber))
    }

    func testUIRangeSlider_WhenRangeLowerAndUpperValuesNotEqual_SliderEndNumberEqualToRangeUpperValue() {
        //Act
        sut.upperRangeNumber = commonNumber
        sut.lowerRangeNumber = commonNumber * 2
        //Assert
        XCTAssertEqual(sut.endNumber, Int(sut.upperRangeNumber))
    }
}

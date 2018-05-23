//
//  DirectionalPadTests.swift
//  DirectionalPadTests
//
//  Created by Aaron Sutton on 5/22/18.
//  Copyright © 2018 Aaron Sutton. All rights reserved.
//

import XCTest
@testable import DirectionalPad

class DirectionalPadTests: XCTestCase {

	override func setUp() {
		super.setUp()

	}

	func testSensitivitySet() {
		// Test custom sensitivity value
		var subject: DirectionalPad = DirectionalPad(frame: CGRect.zero, sensitivity: 0.25)
		XCTAssertNotNil(subject)
		XCTAssert(subject.sensitivity ==  CGFloat(0.25))

		// Test default sensitivty value
		subject = DirectionalPad(frame: CGRect.zero)
		XCTAssertNotNil(subject)
		XCTAssert(subject.sensitivity ==  CGFloat(DirectionalPad.sensitivityDefault))
	}

	func testRecognizerSetup() {
		let subject = DirectionalPad(frame: CGRect.zero)
		XCTAssertNotNil(subject.recognizer)
	}

	func testUnitPointConversion() {
		let subject = DirectionalPad(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
		XCTAssert(subject.unit(point: CGPoint(x: 50, y: 50)) == CGPoint(x: 0.5, y: 0.5))
		XCTAssert(subject.unit(point: CGPoint(x: 0, y: 0)) == CGPoint(x: 0, y: 0))
		XCTAssert(subject.unit(point: CGPoint(x: 100, y: 100)) == CGPoint(x: 1, y: 1))
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

}

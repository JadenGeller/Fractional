//
//  FractionalTests.swift
//  FractionalTests
//
//  Created by Jaden Geller on 12/26/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

import XCTest
@testable import Fractional

class FractionalTests: XCTestCase {
    
    func testNaN() {
        XCTAssertEqual(Fraction.NaN, 0/0 as Fraction)
        XCTAssertEqual(Fraction.NaN, -1/0 + 1/0 as Fraction)
        XCTAssertEqual(Fraction.NaN, 1/0 + -1/0 as Fraction)
        XCTAssertEqual(Fraction.NaN, 1/0 + .NaN as Fraction)
        XCTAssertEqual(Fraction.NaN, 1/0 * .NaN as Fraction)
    }
    
    func testInfinity() {
        XCTAssertEqual(Fraction.infinity, 1/0 as Fraction)
        XCTAssertEqual(-Fraction.infinity, -1/0 as Fraction)
        XCTAssertEqual(Fraction.infinity, 1/0 + 1/0 as Fraction)
        XCTAssertEqual(-Fraction.infinity, -1/0 + -1/0 as Fraction)
        XCTAssertEqual(Fraction.infinity, 1/0 * 1/0 as Fraction)
        XCTAssertEqual(-Fraction.infinity, -1/0 * 1/0 as Fraction)
        XCTAssertEqual(Fraction.infinity, -1/0 * -1/0 as Fraction)
    }
    
    func testMath() {
        XCTAssertEqual(3/4 as Fraction, 1/2 + 1/4 as Fraction)
        XCTAssertEqual(1 as Fraction, 3/4 * (3/4).reciprocal as Fraction)
        XCTAssertEqual(5/2 as Fraction, 1/4 * 10 as Fraction)
        XCTAssertEqual(1/2 as Fraction, (1/4) / (1/2) as Fraction)
    }
    
    func testPow() {
        func pow(base: Fraction, _ exponent: Int) -> Fraction {
            var result: Fraction = 1
            for _ in 1...abs(exponent) {
                result *= base
            }
            return exponent >= 0 ? result : result.reciprocal
        }
        
        XCTAssertEqual(1/8 as Fraction, pow(1/2, 3))
        XCTAssertEqual(9 as Fraction, pow(1/3, -2))
    }
}


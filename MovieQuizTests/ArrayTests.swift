//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Alex on 19.02.2024.
//

import XCTest
@testable import MovieQuiz

class ArayTests: XCTestCase {
    func testGetValueInRange() throws { // тест на успешное взятие элемента по индексу
        // Given
        let array = [1, 2, 3, 4, 5, 5]
        // When
        let value = array[safe: 2]
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 3)
    }
    
    func testGetValueOutOfRange() throws { // тест на взятие элемента по неправильному индексу
        let array = [1, 2, 3, 4, 5]
        let value = array[safe: 20]
        XCTAssertNil(value)
    }
}

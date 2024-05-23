//
//  MainViewUITests.swift
//  swiftui-movie-matchUITests
//
//  Created by Han-Saem Park on 2024-05-23.
//

import XCTest

final class MainViewUITests: XCTestCase {
  
  //MARK: - SETUP
  override func setUpWithError() throws {
    continueAfterFailure = false
    let app = XCUIApplication()
    app.launch()
  }
  
  //MARK: - TEAR DOWN
  override func tearDownWithError() throws {
  }
  
  //MARK: - TESTS
  func testSwipeMovieCardToRightToSaveInFavorites() throws {
    
    //Given
    let app = XCUIApplication()
    XCTAssertTrue(app.wait(for: .runningForeground, timeout: 10))
    let topMovieCard = app.otherElements["movieCard_1"]
    XCTAssertTrue(topMovieCard.waitForExistence(timeout: 5))
    
    //When
    let start = topMovieCard.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
    let finish = topMovieCard.coordinate(withNormalizedOffset: CGVector(dx: 1.5, dy: 0.5))
    start.press(forDuration: 0.01, thenDragTo: finish)
    
    //Then
    XCTAssertFalse(topMovieCard.exists, "The top movie card should be removed after dragging to the right")
  }
}

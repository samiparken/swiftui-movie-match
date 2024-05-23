import XCTest
@testable import swiftui_movie_match

class MainFooterViewUITests: XCTestCase {
  
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
  func testShowFavoriteButton() throws {
    
    //Given
    let app = XCUIApplication()
    XCTAssertTrue(app.wait(for: .runningForeground, timeout: 10))
    let showFavoriteButton = app.buttons["showFavoriteButton"]
    XCTAssertTrue(showFavoriteButton.exists)
    
    // When
    showFavoriteButton.tap()
    
    // Then
    let favoriteView = app.scrollViews["favoriteView"]
    XCTAssertTrue(favoriteView.waitForExistence(timeout: 5))
  }
}

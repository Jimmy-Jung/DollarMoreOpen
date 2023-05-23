//
//  DollarMoreRefactorUITests.swift
//  DollarMoreRefactorUITests
//
//  Created by 정준영 on 2023/05/23.
//

import XCTest

final class DollarMoreRefactorUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        }

    func testExample() throws {
        
        let dollarPlusIndexBtn = app.buttons["환율 + 인덱스"]
        let dollarPlusHanaBtn = app.buttons["환율 + 하나"]
        let dollarWonBtn = app.buttons["국제환율"]
        let dollarIndexBtn = app.buttons["달러인덱스"]
        let hanaBankBtn = app.buttons["하나은행"]
        let oneDayBtn = app.buttons["1일"]
        let oneWeekBtn = app.buttons["7일"]
        let oneMonthBtn = app.buttons["1달"]
        let threeMonthBtn = app.buttons["3달"]
        let oneYearBtn = app.buttons["1년"]
        let fiveYearBtn = app.buttons["5년"]
        let refreshBtn = app.buttons["새로 고침"]
        XCTAssertTrue(dollarPlusIndexBtn.exists)
        XCTAssertTrue(dollarPlusHanaBtn.exists)
        XCTAssertTrue(dollarWonBtn.exists)
        XCTAssertTrue(dollarIndexBtn.exists)
        XCTAssertTrue(hanaBankBtn.exists)
        XCTAssertTrue(oneDayBtn.exists)
        XCTAssertTrue(oneMonthBtn.exists)
        XCTAssertTrue(threeMonthBtn.exists)
        XCTAssertTrue(threeMonthBtn.exists)
        XCTAssertTrue(oneYearBtn.exists)
        XCTAssertTrue(fiveYearBtn.exists)
        XCTAssertTrue(refreshBtn.exists)
        
    }
    
//    func testHanaBank() {
//        let hanaBankBtn = app.buttons["하나은행"]
//        hanaBankBtn.tap()
//        
//        let hanaCurrencyLabel = app.staticTexts["1316.50"]
//        let hanaRateDiff = app.staticTexts["0.50"]
//        let hanaRateDiffPercentage = app.staticTexts["-0.04%"]
//        let hanaBuyCurrency = app.staticTexts["1,317.78"]
//        let hanaSellCurrency = app.staticTexts["1,315.22"]
//        
//        
//        let originalHanaCurrencyLabelText = hanaCurrencyLabel.label
//        let originalHanaRateDiffText = hanaRateDiff.label
//        let originalHanaRateDiffPercentageText = hanaRateDiffPercentage.label
//        let originalHanaBuyCurrencyText = hanaBuyCurrency.label
//        let originalHanaSellCurrencyText = hanaSellCurrency.label
//        hanaBankBtn.tap()
//        if hanaCurrencyLabel.label == originalHanaBuyCurrencyText {
//            XCTAssertEqual(hanaRateDiff.label, originalHanaRateDiffText)
//            XCTAssertEqual(hanaRateDiffPercentage.label, originalHanaRateDiffPercentageText)
//            XCTAssertEqual(hanaBuyCurrency.label, originalHanaBuyCurrencyText)
//            XCTAssertEqual(hanaSellCurrency.label, originalHanaSellCurrencyText)
//        } else {
//            XCTAssertNotEqual(hanaRateDiff.label, originalHanaRateDiffText)
//            XCTAssertNotEqual(hanaRateDiffPercentage.label, originalHanaRateDiffPercentageText)
//            XCTAssertNotEqual(hanaBuyCurrency.label, originalHanaBuyCurrencyText)
//            XCTAssertNotEqual(hanaSellCurrency.label, originalHanaSellCurrencyText)
//        }
//        
//    }

}

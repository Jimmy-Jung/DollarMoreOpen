//
//  DollarMoreRefactorTests.swift
//  DollarMoreRefactorTests
//
//  Created by 정준영 on 2023/05/23.
//

import XCTest
@testable import DollarMoreRefactor

final class DollarMoreRefactorTests: XCTestCase {
    var yfAPI: YahooFinanceAPI!
    var hanaAPI: HanaBankAPI!
    var mockViewModel: MainViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        hanaAPI = HanaBankAPI()
        yfAPI = YahooFinanceAPI()
        mockViewModel = MainViewModel(dataManager: MockDataManager())
    }

    override func tearDownWithError() throws {
        hanaAPI = nil
        yfAPI = nil
        try super.tearDownWithError()
    }

    func testHanaOneDayChartData() async {
        // When
        let result = await hanaAPI.fetchHanaChartData()
        // Then
        switch result {
        case .success(let chartData):
            XCTAssertNotNil(chartData)
            XCTAssertTrue(chartData?.indicators.count ?? 0 > 0)
            XCTAssertNotNil(chartData?.meta.previousClose)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDollarWonChartData() async throws {
        // Given
        let ranges: [ChartRange] =
        [.oneDay, .oneWeek, .oneMonth, .oneYear, .fiveYear]
        let symbol = StocksSymbol.dollar_Won.rawValue
        // When
        for range in ranges {
            let result = try await yfAPI.fetchChartData(
                tickerSymbol: symbol,
                range: range
            )
            // Then
            XCTAssertNotNil(result)
            XCTAssertTrue(result?.indicators.count ?? 0 > 0)
            XCTAssertTrue(result?.meta.regularMarketPrice ?? 0 != 0)
            if range == .oneDay, range == .oneWeek {
                XCTAssertTrue(result?.meta.previousClose ?? 0 != 0)
            }
        }
    }
    
    func testDollarIndexChartData() async throws {
        // Given
        let ranges: [ChartRange] =
        [.oneDay, .oneWeek, .oneMonth, .oneYear, .fiveYear]
        let symbol = StocksSymbol.dollar_Index.rawValue
        // When
        for range in ranges {
            let result = try await yfAPI.fetchChartData(
                tickerSymbol: symbol,
                range: range
            )
            // Then
            XCTAssertNotNil(result)
            XCTAssertTrue(result?.indicators.count ?? 0 > 0)
            XCTAssertTrue(result?.meta.regularMarketPrice ?? 0 != 0)
            if range == .oneDay, range == .oneWeek {
                XCTAssertTrue(result?.meta.previousClose ?? 0 != 0)
            }
        }
    }
    
    func testMockViewModel_DollarIndex() async throws {
        // Given
        let ranges: [ChartRange] =
        [.oneDay, .oneWeek, .oneMonth, .oneYear, .fiveYear]
        let symbol: StocksSymbol = .dollar_Index
        // When
        for range in ranges {
            let result = await mockViewModel
                .stocksDataManager
                .fetchChartData(
                    stockSymbol: symbol, range: range
                )
            //Then
            XCTAssertNotNil(result)
            XCTAssertTrue(result?.meta.previousClose ==  0)
            XCTAssertTrue(result?.meta.regularMarketPrice == 0)
            XCTAssertTrue(
                result?
                    .indicators[0]
                    .timestamp == Date(timeIntervalSince1970: 0)
            )
            XCTAssertTrue(result?.indicators[0].close == 0)
        }
    }
    func testMockViewModel_DollarWon() async throws {
        // Given
        let ranges: [ChartRange] =
        [.oneDay, .oneWeek, .oneMonth, .oneYear, .fiveYear]
        let symbol: StocksSymbol = .dollar_Won
        // When
        for range in ranges {
            let result = await mockViewModel
                .stocksDataManager
                .fetchChartData(
                    stockSymbol: symbol, range: range
                )
            //Then
            XCTAssertNotNil(result)
            XCTAssertTrue(result?.meta.previousClose ==  0)
            XCTAssertTrue(result?.meta.regularMarketPrice == 0)
            XCTAssertTrue(
                result?
                    .indicators[0]
                    .timestamp == Date(timeIntervalSince1970: 0)
            )
            XCTAssertTrue(result?.indicators[0].close == 0)
        }
    }
    
    func testMockViewModel_HanaBank() async throws {
        // Given
        let ranges: [ChartRange] =
        [.oneDay, .oneWeek, .oneMonth, .oneYear, .fiveYear]
        let symbol: StocksSymbol = .hanaBank
        // When
        for range in ranges {
            let result = await mockViewModel
                .stocksDataManager
                .fetchChartData(
                    stockSymbol: symbol, range: range
                )
            //Then
            XCTAssertNotNil(result)
            XCTAssertTrue(result?.meta.previousClose ==  0)
            XCTAssertTrue(result?.meta.regularMarketPrice == 0)
            XCTAssertTrue(
                result?
                    .indicators[0]
                    .timestamp == Date(timeIntervalSince1970: 0)
            )
            XCTAssertTrue(result?.indicators[0].close == 0)
        }
    }
    
}

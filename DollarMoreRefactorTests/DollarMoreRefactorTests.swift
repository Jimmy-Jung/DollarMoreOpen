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
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        hanaAPI = HanaBankAPI()
        yfAPI = YahooFinanceAPI()
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
    
    func testMockViewModel_ChartData() async throws {
        // Given
        let mockDataManager = MockDataManager()
        let mockViewModel = MainViewModel(dataManager: mockDataManager)
        let ranges: [ChartRange] =
        [.oneDay, .oneWeek, .oneMonth, .oneYear, .fiveYear]
        let symbols: [StocksSymbol] = [.dollar_Won, .dollar_Index]
        // When
        for symbol in symbols {
            for range in ranges {
                let result = await mockViewModel
                    .stocksDataManager
                    .fetchChartData(
                        stockSymbol: symbol, range: range
                    )
                //Then
                XCTAssertNotNil(result)
                XCTAssertEqual(result?.meta.previousClose, 0)
                XCTAssertEqual(result?.meta.regularMarketPrice, 0)
                XCTAssertEqual(
                    result?.indicators[0].timestamp,
                    Date(timeIntervalSince1970: 0)
                )
                XCTAssertEqual(result?.indicators[0].close, 0)
            }
        }
        XCTAssertEqual(mockDataManager.fetchChartDataCallCount, 10)
        XCTAssertEqual(mockDataManager.fetchWithHanaDataCallCount, 0)
        XCTAssertEqual(mockDataManager.fetchHanaChartDataCallCount, 0)
    }

    
    func testMockViewModel_FetchWithHanaData() async throws {
        // Given
        let mockDataManager = MockDataManager()
        let mockViewModel = MainViewModel(dataManager: mockDataManager)
        // When
        let result = await mockViewModel
            .stocksDataManager
            .fetchWithHanaData(stockSymbol: .hanaBank, startOfDay: 0)
        //Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.meta.previousClose, 0)
        XCTAssertEqual(result?.meta.regularMarketPrice, 0)
        XCTAssertEqual(
            result?.indicators[0].timestamp,
            Date(timeIntervalSince1970: 0)
        )
        XCTAssertEqual(result?.indicators[0].close, 0)
        
        XCTAssertEqual(mockDataManager.fetchChartDataCallCount, 0)
        XCTAssertEqual(mockDataManager.fetchWithHanaDataCallCount, 1)
        XCTAssertEqual(mockDataManager.fetchHanaChartDataCallCount, 0)
    }
    
    func testMockViewModel_FetchHanaChartData() async throws {
        // Given
        var mockDataManager = MockDataManager()
        var mockViewModel = MainViewModel(dataManager: mockDataManager)
        // When
        let result = await mockViewModel
            .stocksDataManager
            .fetchHanaChartData()
        //Then
        XCTAssertNotNil(result)
        switch result {
        case .success(let chartData):
            XCTAssertEqual(chartData?.meta.previousClose, 0)
            XCTAssertEqual(chartData?.meta.regularMarketPrice, 0)
            XCTAssertEqual(chartData?.indicators[0].close, 0)
            XCTAssertEqual(
                chartData?.indicators[0].timestamp,
                Date(timeIntervalSince1970: 0)
            )
        case .failure(_): break
        }
        XCTAssertEqual(mockDataManager.fetchChartDataCallCount, 0)
        XCTAssertEqual(mockDataManager.fetchWithHanaDataCallCount, 0)
        XCTAssertEqual(mockDataManager.fetchHanaChartDataCallCount, 1)
     
    }
    
}

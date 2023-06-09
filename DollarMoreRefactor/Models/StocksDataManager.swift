//
//  MockDataManager.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/06/09.
//

import Foundation

struct StocksDataManager {
    
    public let stockDataManagerMethod: StocksDataManagerProtocol
    
    public func fetchChartData(
        stockSymbol: StocksSymbol,
        range: ChartRange) async -> ChartData? {
            return await stockDataManagerMethod
                .fetchChartData(
                    stockSymbol: stockSymbol,
                    range: range
                )
        }
    
    public func fetchWithHanaData(
        stockSymbol: StocksSymbol,
        startOfDay: TimeInterval) async -> ChartData? {
            return await stockDataManagerMethod
                .fetchWithHanaData(
                    stockSymbol: stockSymbol,
                    startOfDay: startOfDay
                )
        }
    
    public func fetchHanaChartData(
    ) async -> Result<ChartData?, HanaAPIServiceError> {
        return await stockDataManagerMethod.fetchHanaChartData()
    }
    
}

struct StocksDataManagerOrigin: StocksDataManagerProtocol {
    private let api = YahooFinanceAPI()
    private let hanaAPI = HanaBankAPI()
    
    /// 차트데이터 가져오기
    /// - Parameters:
    ///   - stockName: 주식 이름
    ///   - range: 범위
    /// - Returns: 차트 데이타
    public func fetchChartData(
        stockSymbol: StocksSymbol,
        range: ChartRange
    ) async -> ChartData? {
        do {
            if range == .oneDay {
                let apiChartData = try await api
                    .oneDayFetchChartData(tickerSymbol: stockSymbol.rawValue)
                return apiChartData
            } else {
                let apiChartData = try await api
                    .fetchChartData(
                        tickerSymbol: stockSymbol.rawValue,
                        range: range
                    )
                return apiChartData
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    /// 하나은행 차트 데이터 가져오기
    /// - Parameters:
    ///   - stockSymbol: 주식 이름
    ///   - startOfDay: 시작 날짜
    /// - Returns: 차트 데이타
    public func fetchWithHanaData(
        stockSymbol: StocksSymbol,
        startOfDay: TimeInterval) async -> ChartData? {
            do {
                let apiChartData = try await api
                    .hanaFetchChartData(
                        tickerSymbol: stockSymbol.rawValue,
                        startOfDay: startOfDay
                    )
                return apiChartData
                
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    
    /// 하나은행 하루 데이터 가져오기
    /// - Returns: 차트 데이타
    public func fetchHanaChartData(
    ) async -> Result<ChartData?, HanaAPIServiceError> {
        return await hanaAPI.fetchHanaChartData()
    }
    
}

/// Mock데이타 가져오기
struct MockDataManager: StocksDataManagerProtocol {
    
    /// 차트데이터 Mock값 가져오기
    /// - Parameters:
    ///   - stockSymbol: 주식 이름
    ///   - range: 범위
    /// - Returns: 차트데이타
    public func fetchChartData(
        stockSymbol: StocksSymbol,
        range: ChartRange
    ) async -> ChartData? {
        return ChartData(
            meta: ChartMeta(
                regularMarketPrice: 0,
                previousClose: 0
            ),
            indicators: [
                Indicator(
                    timestamp: Date(timeIntervalSince1970: 0),
                    close: 0
                )
            ]
        )
    }
    /// 하나은행 차트 데이터 Mock값 가져오기
    /// - Parameters:
    ///   - stockSymbol: 주식 이름
    ///   - startOfDay: 시작 날짜
    /// - Returns: 차트 데이타
    public func fetchWithHanaData(
        stockSymbol: StocksSymbol,
        startOfDay: TimeInterval
    ) async -> ChartData? {
        return ChartData(
            meta: ChartMeta(
                regularMarketPrice: 0,
                previousClose: 0
            ),
            indicators: [
                Indicator(
                    timestamp: Date(timeIntervalSince1970: 0),
                    close: 0
                )
            ]
        )
    }
    
    /// 하나은행 하루 데이터 Mock값 가져오기
    /// - Returns: 차트 데이타
    public func fetchHanaChartData(
    ) async -> Result<ChartData?, HanaAPIServiceError> {
        return .success(
            ChartData(
                meta: ChartMeta(
                    regularMarketPrice: 0,
                    previousClose: 0
                ),
                indicators: [
                    Indicator(
                        timestamp: Date(timeIntervalSince1970: 0),
                        close: 0
                    )
                ]
            )
        )
    }
    
    
}



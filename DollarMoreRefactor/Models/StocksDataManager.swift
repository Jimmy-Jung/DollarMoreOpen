//
//  StocksDataManager.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/11.
//

import Foundation

struct StocksDataManager {
    
    /// 주식 이름
    enum StocksSymbol: String {
        case dollar_Won = "KRW=X"
        case dollar_Index = "DX-Y.NYB"
        case hanaBank = "hahabank"
    }
    
    private let api = YahooFinanceAPI()
    private let hanaAPI = HanaBankAPI()
    
    /// 차트데이터 가져오기
    /// - Parameters:
    ///   - stockName: 주식 이름
    ///   - range: 범위
    /// - Returns: 차트 데이터
    public func fetchChartData(stockSymbol: StocksSymbol, range: ChartRange) async -> ChartData? {
        do {
            let apiChartData = try await api
                .fetchChartData(tickerSymbol: stockSymbol.rawValue, range: range)
            return apiChartData
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// 한국기준 하루데이터 가져오기
    /// - Parameter stockName: 주식 이름
    /// - Returns: 차트 데이터
    public func oneDayFetchChartData(stockSymbol: StocksSymbol) async -> ChartData? {
        do {
            let apiChartData = try await api
                .oneDayFetchChartData(tickerSymbol: stockSymbol.rawValue)
            return apiChartData
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// 하나은행 하루 데이터 가져오기
    /// - Returns: 차트 데이터
    public func fetchHanaChartData() async -> ChartData? {
        do {
            return try await hanaAPI.fetchHanaChartData()
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}


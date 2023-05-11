//
//  YahooFinanceAPI.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/11.
//

import Foundation

public struct YahooFinanceAPI {
    private let session = URLSession.shared
    private let jsonDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    public init() {}
    
    private let baseURL = "https://query1.finance.yahoo.com"
    public func fetchChartData(tickerSymbol: String, range: ChartRange) async throws -> ChartData? {
        guard let url = urlForChartData(symbol: tickerSymbol, range: range) else { throw APIServiceError.invalidURL }
        let (resp, statusCode): (ChartResponse, Int) = try await fetch(url: url)
        if let error = resp.error {
            throw APIServiceError.httpStatusCodeFailed(statusCode: statusCode, error: error)
        }
        return resp.data?.first
    }
    
    
    public func oneDayFetchChartData(tickerSymbol: String) async throws -> ChartData? {
        var count = 0
        var response: ChartData?
        // 휴일일경우 하루 전 데이터 불러오기
        for _ in 0...3 {
            let yesterday = Calendar.current.date(byAdding: .day, value: count - 1, to: Date())!
            let beginningOfPreviousDay = Calendar.current.startOfDay(for: yesterday).timeIntervalSince1970
            guard let url = urlForOneDayData(symbol: tickerSymbol, startOfDay: beginningOfPreviousDay) else { throw APIServiceError.invalidURL }
            
            let (resp, statusCode): (ChartResponse, Int) = try await fetch(url: url)
            if let error = resp.error {
                throw APIServiceError.httpStatusCodeFailed(statusCode: statusCode, error: error)
            }
            if resp.data?.first?.indicators.count == 0 {
                count -= 1
            } else {
                response = resp.data?.first
                break
            }
        }
        guard let timestamp = response?.indicators.last?.timestamp else {
            return response
        }
        guard let yesterday = Calendar.current.date(byAdding: .hour, value: -12, to: timestamp)?.timeIntervalSince1970 else {return response}
        guard let url = urlForOneDayData(symbol: tickerSymbol, startOfDay: yesterday) else { throw APIServiceError.invalidURL }

        let (resp, statusCode): (ChartResponse, Int) = try await fetch(url: url)
        if let error = resp.error {
            throw APIServiceError.httpStatusCodeFailed(statusCode: statusCode, error: error)
        }
        return resp.data?.first
    }
    
    private func urlForOneDayData(symbol: String, startOfDay: TimeInterval) -> URL? {
        guard var urlComp = URLComponents(string: "\(baseURL)/v8/finance/chart/\(symbol)") else {
            return nil
        }
        let startOfDay = Int(startOfDay)
        let now = Int(Date().timeIntervalSince1970)
        
        urlComp.queryItems = [
            URLQueryItem(name: "period1", value: "\(startOfDay)"),
            URLQueryItem(name: "period2", value: "\(now)"),
            URLQueryItem(name: "interval", value: "1m")
        ]
        return urlComp.url
    }
    
    private func urlForChartData(symbol: String, range: ChartRange) -> URL? {
        guard var urlComp = URLComponents(string: "\(baseURL)/v8/finance/chart/\(symbol)") else {
            return nil
        }
        
        urlComp.queryItems = [
            URLQueryItem(name: "range", value: range.rawValue),
            URLQueryItem(name: "interval", value: range.interval)
        ]
        return urlComp.url
    }
    
    private func fetch<D: Decodable>(url: URL) async throws -> (D, Int) {
        let (data, response) = try await session.data(from: url)
        let statusCode = try validateHTTPResponse(response: response)
        return (try jsonDecoder.decode(D.self, from: data), statusCode)
    }
    
    
    private func validateHTTPResponse(response: URLResponse) throws -> Int {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIServiceError.invalidResponseType
        }
        
        guard 200...299 ~= httpResponse.statusCode ||
              400...499 ~= httpResponse.statusCode
        else {
            throw APIServiceError.httpStatusCodeFailed(statusCode: httpResponse.statusCode, error: nil)
        }
        
        return httpResponse.statusCode
    }
}



//
//  HanaBankAPI.swift
//  DollarMore
//
//  Created by 정준영 on 2023/05/05.
//
import Alamofire
import Foundation
import SwiftSoup

/// 하나은행 API
struct HanaBankAPI {

    // MARK: - Properties

    // 하나은행 URL
    private let baseURL = "https://www.hanabank.com/cms/rate/"
    private let dayQuery = "wpfxd651_07i_01.do?"
    private let rangeQuery = "wpfxd651_07i_02.do?"
    
    // User-Agent 설정
    private let headers: HTTPHeaders = [
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
    ]
    
    // MARK: - Methods

    /// 하나은행 어제 오늘 데이터 불러오기
    /// - Returns: 차트데이터
    public func fetchHanaChartData(
    ) async -> Result<ChartData?, HanaAPIServiceError> {
        do {
            guard let url = try urlForData(range: .today) else {
                return .failure(.invalidData)
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else {
                return .failure(.invalidData)
            }
            let chartData = try await parseHTML(html: html)
            return .success(chartData)
        } catch {
            if error is HanaAPIServiceError {
                switch error as! HanaAPIServiceError {
                case .invalidData:
                    return .failure(.invalidData)
                case .invalidURL:
                    return .failure(.invalidURL)
                case .networkError:
                    return .failure(.networkError)
                case .parsingError:
                    return .failure(.parsingError)
                }
            } else {
                return .failure(.invalidURL)
            }
            
        }
    }
    
    /// 하나은행 오늘 HTML파싱
    /// - Parameter html: HTML데이터
    /// - Returns: 차트데이터
    private func parseHTML(html: String) async throws -> ChartData {
        do {
            let table = try await makeTableData()
            let tableTimestamp = table.timestamp
            let tableReg = table.regularMarketPrice
            let tablePre = table.previousClose
            let doc: Document = try SwiftSoup.parse(html)
            let tbodyElements = try doc.select("tbody")
            let trElements = try tbodyElements.select("tr")
            var indicators = [Indicator]()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            for row in trElements {
                let time = try row.select("td")[1].text()
                let closeString = try row.select("td")[8].text()
                let close = formatter.number(from: closeString)?.doubleValue ?? 0
                let timestamp = dateFormatter
                    .date(from: tableTimestamp + " " + time) ?? Date()
                indicators.append(.init(timestamp: timestamp, close: close))
            }
            let meta = ChartMeta(regularMarketPrice: tableReg, previousClose: tablePre)
            return ChartData(meta: meta, indicators: indicators.reversed())
        } catch {
            throw HanaAPIServiceError.parsingError
        }
    }
    /// 하나은행 지난 데이터 불러오기
    /// - Returns: 데이터 구조체
    private func makeTableData() async throws -> Table {
        do {
            guard let url = try urlForData(range: .previous) else {
                throw HanaAPIServiceError.invalidURL
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else {
                throw HanaAPIServiceError.invalidData
            }
            return try await parseWeekHTML(html: html)
        } catch {
            if error is URLError {
                throw HanaAPIServiceError.invalidURL
            } else {
                throw HanaAPIServiceError.parsingError
            }
        }
    }
    
    /// 하나은행 한주치 HTML 파싱
    /// - Parameter html: HTML데이터
    /// - Returns: 테이블 구조체
    private func parseWeekHTML(html: String) async throws -> Table {
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let table = try doc.select("tbody")
            if table == Elements() {
                throw HanaAPIServiceError.networkError
            }
            let trElements = try table.select("tr")
            let td0Elements = try trElements[0].select("td")
            let td1Elements = try trElements[1].select("td")
            let timestamp = try td0Elements[0].text()
            let regularMarketPriceString = try td0Elements[7].text()
            let previousCloseString = try td1Elements[7].text()
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let regularMarketPrice = formatter
                .number(from: regularMarketPriceString)?
                .doubleValue ?? 0
            let previousClose = formatter
                .number(from: previousCloseString)?
                .doubleValue ?? 0
            
            return .init(
                timestamp: timestamp,
                regularMarketPrice: regularMarketPrice,
                previousClose: previousClose
            )
        } catch {
            throw HanaAPIServiceError.parsingError
        }
    }
    
    
    /// 하나은행 URL 만들기
    /// - Parameter range: 호출 날짜 범위 선택
    /// - Returns: URL
    private func urlForData(range: Range) throws -> URL? {
        let baseUrl = range == .today ? baseURL + dayQuery : baseURL + rangeQuery
        guard var urlComp = URLComponents(string: baseUrl) else {
            throw HanaAPIServiceError.invalidURL
        }
        switch range {
        case .today:
            urlComp.queryItems = [
                URLQueryItem(name: "curCd", value: "USD")
            ]
        case .previous:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let todayString = dateFormatter.string(from: Date())
            let lastWeek = NSCalendar.current.date(byAdding: .day, value: -7, to: Date())!
            let lastWeekString = dateFormatter.string(from: lastWeek)
            urlComp.queryItems = [
                URLQueryItem(name: "curCd", value: "USD"),
                URLQueryItem(name: "inqStrDt", value: lastWeekString),
                URLQueryItem(name: "inqEndDt", value: todayString)
            ]
        }
        return urlComp.url
    }
  
    
}

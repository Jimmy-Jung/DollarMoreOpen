//
//  NewsAPI.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/25.
//

import Foundation
import SwiftSoup
import Alamofire

/// 하나은행 API
struct NewsAPI {
    // MARK: - Properties
    
    // 하나은행 URL
    private let baseURL = "http://news.einfomax.co.kr/rss/S1N16.xml"
    
    // User-Agent 설정
    private let headers: HTTPHeaders = [
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
    ]
    
    
    // MARK: - Methods
    
    public func makeNewsItems() async -> Result<[NewsItem], NewsServiceError> {
        var newsItems: [NewsItem] = []
        
        guard let url = URL(string: baseURL),
              let xmlData = try? Data(contentsOf: url),
              let xmlString = String(data: xmlData, encoding: .utf8) else {
            return .failure(.invalidURL)
        }
        guard let doc = try? SwiftSoup.parse(xmlString),
              let items = try? doc.select("item") else {
            return .failure(.parsingError)
        }
        
        for item in items {
            guard let title = try? item.select("title").text(),
                  let description = try? item.select("description").text(),
                  let pubDate = try? item.select("pubDate").text(),
                  let link = try? item.select("link").text() else {
                return .failure(.parsingError)
            }
            
            // 시간 계산을 위해 pubDate를 Date 객체로 변환합니다.
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: pubDate) ?? Date()
            
            // 현재 시간과의 차이를 계산합니다.
            let timeInterval = Int(Date().timeIntervalSince(date)) / 3600
            let timeString = "\(timeInterval)시간 전"
            let newsItem = NewsItem(
                title: title,
                description: description,
                pubDate: timeString,
                link: link
            )
            newsItems.append(newsItem)
        }
        return .success(newsItems)
    }
}

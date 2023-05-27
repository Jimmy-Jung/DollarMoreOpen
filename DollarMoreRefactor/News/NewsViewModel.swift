//
//  NewsViewModel.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/25.
//

import Foundation
import Combine

final class NewsViewModel {
    private var cancellable: AnyCancellable?
    @Published var newsItems: [NewsItem]?
    enum Infomax: String {
        case bondAndExchange = "https://news.einfomax.co.kr/rss/S1N16.xml"
        case columnAndIssue = "https://news.einfomax.co.kr/rss/S1N9.xml"
    }
    
    public func fetchRSS() {
        guard let url1 = URL(string: Infomax.bondAndExchange.rawValue),
              let url2 = URL(string: Infomax.columnAndIssue.rawValue)
        else { return }

        let publisher1 = URLSession.shared.dataTaskPublisher(for: url1)
            .map(\.data)
            .compactMap { XMLParser(data: $0) }
            .compactMap { parser -> [NewsItem]? in
                let rssParser = RssParser()
                parser.delegate = rssParser
                if parser.parse() {
                    return rssParser.getNewsItems()
                }
                return nil
            }

        let publisher2 = URLSession.shared.dataTaskPublisher(for: url2)
            .map(\.data)
            .compactMap { XMLParser(data: $0) }
            .compactMap { parser -> [NewsItem]? in
                let rssParser = RssParser()
                parser.delegate = rssParser
                if parser.parse() {
                    return rssParser.getNewsItems()
                }
                return nil
            }

        cancellable = Publishers.Zip(publisher1, publisher2)
            .map { $0.0 + $0.1 }
            .map { $0.sorted { item1, item2 in item1.pubDate > item2.pubDate } }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] newsItems in
                self?.newsItems = newsItems
            })
    }

    deinit { cancellable?.cancel() }
}

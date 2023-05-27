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
    
    public func fetchRSS() {
        guard let url =
                URL(string: "https://news.einfomax.co.kr/rss/S1N16.xml")
        else { return }
        cancellable =
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { data in
                let parser = XMLParser(data: data)
                let rssParser = RssParser()
                parser.delegate = rssParser
                
                if parser.parse() {
                    self.newsItems = rssParser.getNewsItems()
                }
            })
    }
    deinit { cancellable?.cancel() }
}

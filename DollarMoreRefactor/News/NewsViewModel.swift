//
//  NewsViewModel.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/25.
//

import Foundation

final class NewsViewModel {
    private let newsAPI = NewsAPI()
    
    @Published var newsItems: [NewsItem]?
    
    public func updateNews() async {
        switch await newsAPI.makeNewsItems() {
        case .success(let items):
            newsItems = items
        case .failure(let error):
            newsItems = [
                NewsItem(
                    title: error.localizedDescription,
                    description: "새로고침을 시도해보세요",
                    pubDate: "",
                    link: ""
                )
            ]
        }
    }
}

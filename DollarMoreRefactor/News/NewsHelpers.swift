//
//  NewsModel.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/25.
//

import Foundation

struct NewsItem {
    let title: String
    let description: String
    let pubDate: String
    let link: String
}

enum NewsServiceError: Error {
    case invalidURL
    case invalidData
    case networkError
    case parsingError
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "URL 주소에 문제가 있습니다."
        case .invalidData:
            return "데이터를 이용할 수 없습니다."
        case .networkError:
            return "네트워킹에 문제가 있습니다."
        case .parsingError:
            return "데이터를 불러오는데 실패했습니다."
        }
    }
}

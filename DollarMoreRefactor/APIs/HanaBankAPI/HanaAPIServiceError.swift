//
//  HanaAPIServiceError.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/19.
//

import Foundation

enum HanaAPIServiceError: Error {
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
            return "네크워킹에 문제가 있습니다."
        case .parsingError:
            return "데이터를 불러오는데 실패했습니다."
        }
    }
}

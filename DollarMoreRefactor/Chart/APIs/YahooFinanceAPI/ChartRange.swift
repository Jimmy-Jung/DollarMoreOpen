//
//  ChartRange.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/11.
//

import Foundation

public enum ChartRange: String, CaseIterable {
    
    case oneDay = "1d"
    case oneWeek = "5d"
    case oneMonth = "1mo"
    case threeMonth = "3mo"
    case sixMonth = "6mo"
    case oneYear = "1y"
    case twoYear = "2y"
    case fiveYear = "5y"
    case tenYear = "10y"
    case max
    
    public var interval: String {
        switch self {
        case .oneDay: return "1m"
        case .oneWeek: return "1h"
        case .oneMonth: return "90m"
        case .threeMonth: return "1d"
        case .sixMonth: return "5d"
        case .oneYear, .twoYear: return "1wk"
        case .fiveYear, .tenYear: return "1mo"
        case .max: return "3mo"
        }
    }

}

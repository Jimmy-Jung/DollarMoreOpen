//
//  HanaBankModel.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/19.
//

import Foundation

/// URL 호출 날짜 범위
enum Range {
    case today
    case previous
}
/// 지난 데이터 구조체
struct Table {
    let timestamp: String
    let regularMarketPrice: Double
    let previousClose: Double
}

//
//  ChartViewModel.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/12.
//

import Foundation
import Charts

final class DateValueFormatter: NSObject, AxisValueFormatter {

    private let dateFormatter = DateFormatter()

    init(data: [Indicator], range: ChartRange) {
        super.init()
        
        switch range {
        case .oneDay:
            dateFormatter.dateFormat = "HH시"
        case .oneWeek:
            dateFormatter.dateFormat = "dd일"
        case .oneMonth:
            dateFormatter.dateFormat = "dd일"
        case .threeMonth:
            dateFormatter.dateFormat = "MM월"
        case .oneYear:
            dateFormatter.dateFormat = "MM월"
        default:
            dateFormatter.dateFormat = "yy년"
        }
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value / 1000)
        return dateFormatter.string(from: date)
    }
}

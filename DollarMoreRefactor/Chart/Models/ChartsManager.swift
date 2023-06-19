//
//  ChartsManager.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/06/19.
//

import Foundation

final class ChartsManager {
    static let shared = ChartsManager()
    init() {}
    private static let emptyChart = ChartData(
        meta: ChartMeta(regularMarketPrice: 0, previousClose: 0),
        indicators: [Indicator]()
        )
    
    var hanaBank = SingleChartDataSet(
        data: emptyChart,
        preClose: 1300.00,
        lineColor: [.systemGreen],
        chartRange: .oneDay
    )
    
    var dollar_Won = SingleChartDataSet(
        data: emptyChart,
        preClose: 1300.00,
        lineColor: [.orange],
        chartRange: .oneDay
    )
    
    var dollar_Index = SingleChartDataSet(
        data: emptyChart,
        preClose: 1300.00,
        lineColor: [.systemBlue],
        chartRange: .oneDay
    )
    
    var dual_Hana_Won = DualChartDataSet(
        data1: emptyChart,
        data2: emptyChart,
        lineColor1: [.systemOrange],
        lineColor2: [.systemBlue],
        chartRange: .oneDay
    )
    var dual_Won_Index = DualChartDataSet(
        data1: emptyChart,
        data2: emptyChart,
        lineColor1: [.systemOrange],
        lineColor2: [.systemGreen],
        chartRange: .oneDay
    )
}

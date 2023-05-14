//
//  MainViewModel.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/11.
//

import UIKit

final class MainViewModel {
    
    struct CurrencyLabelData {
        let currencyLabel: String
        let rateDiff: String
        let rateDiffColor: UIColor
        let rateDiffPercentage: String
        let rateDiffPercentageColor: UIColor
        let upDownImage: UIImage?
        let upDownImageColor: UIColor
    }
    // MARK: - Properies
    private var usdData: ChartData? {
        didSet {
            usdLabelSet = updateLabelSet(chartData: usdData)
            usdReferenceTimeLabel = updateReferenceTimeLabel(chartData: usdData)
        }
    }
    private var indexData: ChartData? {
        didSet {
            indexLabelSet = updateLabelSet(chartData: indexData)
        }
    }
    private var hanaData: ChartData? {
        didSet {
            hanaLabelSet = updateLabelSet(chartData: hanaData)
            hanaReferenceTimeLabel = updateReferenceTimeLabel(chartData: hanaData)
            hanaSellBuyLabel = updateSellBuyLabel(chartData: hanaData)
            
        }
    }
    // MARK: - Published
    @Published var usdLabelSet: CurrencyLabelData?
    @Published var indexLabelSet: CurrencyLabelData?
    @Published var hanaLabelSet: CurrencyLabelData?
    @Published var usdReferenceTimeLabel: String = ""
    @Published var hanaReferenceTimeLabel: String = ""
    @Published var hanaSellBuyLabel: (sell: String, buy: String) = ("", "")
    
    let stocksManager = StocksDataManager()
    let hanaBankSpread = 0.000973
    
    public func updateSingleChartData(
        symbol: StocksDataManager.StocksSymbol,
        range: ChartRange
    ) async -> SingleChartView.ChartDataSet {
        let emptyData = ChartData(
            meta: ChartMeta(regularMarketPrice: 0, previousClose: 0),
            indicators: [Indicator]()
            )
        switch symbol {
        case .dollar_Won:
            usdData = await stocksManager
                .fetchChartData(stockSymbol: symbol, range: range)
            return .init(
                data: usdData ?? emptyData,
                lineColor: [.systemOrange],
                chartRange: range
            )
        case .dollar_Index:
            indexData = await stocksManager
                .fetchChartData(stockSymbol: symbol, range: range)
            return .init(
                data: indexData ?? emptyData,
                lineColor: [.systemBlue],
                chartRange: range
            )
        case .hanaBank:
            hanaData = await stocksManager.fetchHanaChartData()
            return .init(
                data: hanaData ?? emptyData,
                lineColor: [.systemGreen],
                chartRange: range
            )
        }
    }
    
    public func updateDualChartData(
        range: ChartRange
    ) async -> DualChartView.ChartDataSet {
        let emptyData = ChartData(
            meta: ChartMeta(regularMarketPrice: 0, previousClose: 0),
            indicators: [Indicator]()
            )
        usdData = await stocksManager.fetchChartData(
            stockSymbol: .dollar_Won,
            range: range
        )
        indexData = await stocksManager.fetchChartData(
            stockSymbol: .dollar_Index,
            range: range
        )
        return .init(
            data1: usdData ?? emptyData,
            data2: indexData ?? emptyData,
            chartRange: range
        )
        
    }
    
    ///  레이블 모음 업데이트
    /// - Parameter chartData: 차트데이터
    /// - Returns: 현재 레이블 데이터
    private func updateLabelSet(chartData: ChartData?) -> CurrencyLabelData {
        let regularPrice = chartData?.meta.regularMarketPrice ?? 0
        let previousClose = chartData?.meta.previousClose ?? 0
        let change = regularPrice - previousClose
        let DiffRate = (change / previousClose) * 100
        let currencyLabel = String(format: "%.2f", regularPrice)
        let rateDiff = String(format: "%.2f", abs(change))
        let rateDiffColor: UIColor = change > 0 ? .systemRed : .systemBlue
        let rateDiffPercentage = String(format: "%.2f", DiffRate) + "%"
        let rateDiffPercentageColor: UIColor = change > 0 ? .systemRed : .systemBlue
        let upDownImage = UIImage(systemName: change > 0
            ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
        let upDownImageColor: UIColor = change > 0 ? .systemRed : .systemBlue
        let currentLabelData = CurrencyLabelData(
            currencyLabel: currencyLabel,
            rateDiff: rateDiff,
            rateDiffColor: rateDiffColor,
            rateDiffPercentage: rateDiffPercentage,
            rateDiffPercentageColor: rateDiffPercentageColor,
            upDownImage: upDownImage,
            upDownImageColor: upDownImageColor
        )
        return currentLabelData
    }
    
    ///  현재 기준기간 업데이트
    /// - Parameter chartData: 차트데이터
    /// - Returns: 기준시간 문자열
    private func updateReferenceTimeLabel(chartData: ChartData?) -> String {
        let time = chartData?.indicators.last?.timestamp ?? Date()
        let timeSince1970 = time.timeIntervalSince1970
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: timeSince1970)
        dateFormatter.dateFormat = "MM월 dd일 HH:mm:ss 기준"
        let currentTime = dateFormatter.string(from: date)
        return currentTime
    }
    
    private func updateSellBuyLabel(chartData: ChartData?) -> (
        sell: String, buy: String
    ) {
        let currentPrice = chartData?.meta.regularMarketPrice ?? 0
        let spread = hanaBankSpread
        let margin = currentPrice * spread
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        let sellPrice = formatter
            .string(from: NSNumber(value: currentPrice + margin)) ?? ""
        
        let buyPrice = formatter
            .string(from: NSNumber(value: currentPrice - margin)) ?? ""
        return (sellPrice, buyPrice)
    }
}




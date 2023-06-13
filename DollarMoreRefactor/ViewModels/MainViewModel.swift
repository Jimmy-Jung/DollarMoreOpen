//
//  MainViewModel.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/11.
//

import UIKit

final class MainViewModel: ObservableObject {
    
    struct CurrencyLabelData {
        let currencyLabel: String
        let rateDiff: String
        let rateDiffColor: UIColor
        let rateDiffPercentage: String
        let rateDiffPercentageColor: UIColor
        let upDownImage: UIImage?
        let upDownImageColor: UIColor
    }
    init(dataManager: StocksDataManagerProtocol = StocksDataManager()) {
        self.stocksDataManager = dataManager
    }
    
    // MARK: - Properies
    private var usdData: ChartData? {
        didSet {
            usdLabelSet = updateLabelSet(chartData: usdData)
            usdReferenceTimeLabel =
            updateReferenceTimeLabel(chartData: usdData)
        }
    }
    private var indexData: ChartData? {
        didSet {
            indexLabelSet = updateLabelSet(chartData: indexData)
        }
    }
    private var hanaData: Result<ChartData?, HanaAPIServiceError> =
        .success(
            .init(
                meta: .init(regularMarketPrice: 0, previousClose: 0),
                indicators: [Indicator]()
            )
        ) {
            didSet {
                switch hanaData {
                case .success(let data):
                    hanaLabelSet = updateLabelSet(chartData: data)
                hanaReferenceTimeLabel =
                updateReferenceTimeLabel(chartData: data)
                hanaSellBuyLabel = updateSellBuyLabel(chartData: data)
            case .failure(let error):
                hanaLabelSet = invalidLabelSet()
                hanaReferenceTimeLabel =
                invalidReferenceTimeLabel(error: error)
                hanaSellBuyLabel = invalidSellBuyLabel()
            }
        }
    }
    // MARK: - Published
    @Published var usdLabelSet: CurrencyLabelData?
    @Published var indexLabelSet: CurrencyLabelData?
    @Published var hanaLabelSet: CurrencyLabelData?
    @Published var usdReferenceTimeLabel: String = ""
    @Published var hanaReferenceTimeLabel: String = ""
    @Published var hanaSellBuyLabel: (sell: String, buy: String) = ("", "")
    
    var stocksDataManager: StocksDataManagerProtocol
    let hanaBankSpread = 0.000973
    
    
    // MARK: - Public Methods

    public func updateSingleChartData(
        symbol: StocksSymbol,
        range: ChartRange
    ) async -> SingleChartView.ChartDataSet {
        let emptyData = ChartData(
            meta: ChartMeta(regularMarketPrice: 0, previousClose: 0),
            indicators: [Indicator]()
            )
        
        let resultData = await fetchSymbolData(symbol: symbol, range: range)
        switch resultData {
        case .success(let data):
            return .init(
                data: data ?? emptyData,
                preClose: getPreviousClose(symbol: symbol),
                lineColor: getColor(symbol: symbol),
                chartRange: range
            )
        case .failure(_):
            return .init(
                data: emptyData,
                preClose: getPreviousClose(symbol: symbol),
                lineColor: getColor(symbol: symbol),
                chartRange: range
            )
        }
    }
    
    public func updateDualChartData(
        symbol1: StocksSymbol,
        symbol2: StocksSymbol,
        range: ChartRange
    ) async -> DualChartView.ChartDataSet {
        let emptyData = ChartData(
            meta: ChartMeta(regularMarketPrice: 0, previousClose: 0),
            indicators: [Indicator]()
            )
        var data1: ChartData?
        var data2: ChartData?
        let dataResult2 = await fetchSymbolData(symbol: symbol2, range: range)
        switch dataResult2 {
        case .success(let data):
            data2 = data
        case .failure(_):
            data2 = emptyData
        }
        if symbol2 == .hanaBank {
            switch hanaData {
            case .success(let data):
                let startOfDay =
                data?
                    .indicators
                    .first?
                    .timestamp
                    .timeIntervalSince1970
                ?? Calendar
                    .current
                    .startOfDay(for: Date())
                    .timeIntervalSince1970
                usdData =
                await stocksDataManager
                    .fetchWithHanaData(
                        stockSymbol: .dollar_Won,
                        startOfDay: startOfDay - 360
                    )
                data1 = usdData
            case .failure(_):
                break
            }
            
        } else {
            let dataResult =
            await fetchSymbolData(symbol: symbol1, range: range)
            switch dataResult {
            case .success(let data):
                data1 = data
            case .failure(_):
                data1 = emptyData
            }
        }
        
        return .init(
            data1: data1 ?? emptyData,
            data2: data2 ?? emptyData,
            lineColor1: getColor(symbol: symbol1),
            lineColor2: getColor(symbol: symbol2),
            chartRange: range
        )
        
    }
    // MARK: - Private Methods

    private func getPreviousClose(
        symbol: StocksSymbol
    ) -> Double {
        switch symbol {
        case .dollar_Index:
            return indexData?.meta.previousClose ?? 100.00
        case .dollar_Won:
            return usdData?.meta.previousClose ?? 1300.00
        case .hanaBank:
            switch hanaData {
            case .success(let data):
                return data?.meta.previousClose ?? 1300.00
            case .failure(_):
                return 1300.00
            }
            
        }
    }
    private func fetchSymbolData(
        symbol: StocksSymbol,
        range: ChartRange
    ) async -> Result<ChartData?, HanaAPIServiceError> {
        switch range {
        case .oneDay, .oneWeek, .oneMonth:
            switch symbol {
            case .dollar_Won:
                usdData = await stocksDataManager.fetchChartData(
                    stockSymbol: symbol,
                    range: range)
                return .success(usdData)
            case .dollar_Index:
                indexData = await stocksDataManager.fetchChartData(
                    stockSymbol: symbol,
                    range: range)
                return .success(indexData)
            case .hanaBank:
                hanaData = await stocksDataManager.fetchHanaChartData()
                switch hanaData {
                case .success(let data):
                    return .success(data)
                case .failure(let error):
                    return .failure(error)
                }
                
            }
        default:
            switch symbol {
            case .dollar_Won:
                let usdData = await stocksDataManager.fetchChartData(
                    stockSymbol: symbol,
                    range: range)
                return .success(usdData)
            case .dollar_Index:
                let indexData = await stocksDataManager.fetchChartData(
                    stockSymbol: symbol,
                    range: range)
                return .success(indexData)
            case .hanaBank:
                let hanaData = await stocksDataManager.fetchHanaChartData()
                switch hanaData {
                case .success(let data):
                    return .success(data)
                case .failure(let error):
                    return .failure(error)
                }
            }
        }
        
    }
    private func getColor(
        symbol: StocksSymbol
    ) -> [UIColor] {
        switch symbol {
        case .dollar_Won:
            return [.systemOrange]
        case .dollar_Index:
            return [.systemBlue]
        default:
            return [.systemGreen]
        }
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
        let upDownImage = UIImage(systemName: change > 0
            ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
        let currentLabelData = CurrencyLabelData(
            currencyLabel: currencyLabel,
            rateDiff: rateDiff,
            rateDiffColor: rateDiffColor,
            rateDiffPercentage: rateDiffPercentage,
            rateDiffPercentageColor: rateDiffColor,
            upDownImage: upDownImage,
            upDownImageColor: rateDiffColor
        )
        return currentLabelData
    }
    private func invalidLabelSet() -> CurrencyLabelData {
        let currentLabelData = CurrencyLabelData(
            currencyLabel: "Error!",
            rateDiff: "E.EE",
            rateDiffColor: .systemYellow,
            rateDiffPercentage: "E.EE%",
            rateDiffPercentageColor: .systemYellow,
            upDownImage: UIImage(systemName: "exclamationmark.triangle.fill"),
            upDownImageColor: .systemYellow
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
    
    private func invalidReferenceTimeLabel(
        error: HanaAPIServiceError
    ) -> String {
        return error.localizedDescription
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
        formatter.minimumFractionDigits = 2
        let sellPrice = formatter
            .string(from: NSNumber(value: currentPrice - margin)) ?? "0,000.00"
        
        let buyPrice = formatter
            .string(from: NSNumber(value: currentPrice + margin)) ?? "0,000.00"
        return (sellPrice, buyPrice)
    }
    private func invalidSellBuyLabel() -> (
        sell: String, buy: String
    ) {
        let sellPrice = "Error"
        let buyPrice = "Error"
        return (sellPrice, buyPrice)
    }
}




//
//  File.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/11.
//
import Foundation

public struct ChartResponse: Decodable {
    
    public let data: [ChartData]?
    public let error: ErrorResponse?
    
    enum CodingKeys: CodingKey {
        case chart
    }
    
    enum ChartKeys: CodingKey {
        case result
        case error
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let chartContainer = try? container.nestedContainer(keyedBy: ChartKeys.self, forKey: .chart) {
            data = try? chartContainer.decodeIfPresent([ChartData].self, forKey: .result)
            error = try? chartContainer.decodeIfPresent(ErrorResponse.self, forKey: .error)
        } else {
            data = nil
            error = nil
        }
    }
    
}

public struct ChartData: Decodable {
    
    public let meta: ChartMeta
    public let indicators: [Indicator]
    
    enum CodingKeys: CodingKey {
        case meta
        case timestamp
        case indicators
    }
    
    enum IndicatorsKeys: CodingKey {
        case quote
    }
    
    enum QuoteKeys: CodingKey {
        case close
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        meta = try container.decode(ChartMeta.self, forKey: .meta)
        
        let timestamps = try container.decodeIfPresent([Date].self, forKey: .timestamp) ?? []
        if let indicatorsContainer = try? container.nestedContainer(keyedBy: IndicatorsKeys.self, forKey: .indicators),
           var quotes = try? indicatorsContainer.nestedUnkeyedContainer(forKey: .quote),
           let quoteContainer = try? quotes.nestedContainer(keyedBy: QuoteKeys.self) {
            let closes = try quoteContainer.decodeIfPresent([Double?].self, forKey: .close) ?? []
            
            indicators = timestamps.enumerated().compactMap { (offset, timestamp) in
                guard let close = closes[offset] else { return nil}
                return .init(timestamp: timestamp, close: close)
            }
        } else {
            self.indicators = []
        }
    }
    
    public init(meta: ChartMeta, indicators: [Indicator]) {
        self.meta = meta
        self.indicators = indicators
    }
}

public struct ChartMeta: Decodable {
    
    public let regularMarketPrice: Double
    public let previousClose: Double
    
    enum CodingKeys: CodingKey {
        case regularMarketPrice
        case previousClose
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.regularMarketPrice = try container
            .decodeIfPresent(Double.self, forKey: .regularMarketPrice) ?? 0
        self.previousClose = try container
            .decodeIfPresent(Double.self, forKey: .previousClose) ?? 0
    }
    
    public init(regularMarketPrice: Double, previousClose: Double) {
        self.regularMarketPrice = regularMarketPrice
        self.previousClose = previousClose
    }
}

public struct Indicator: Decodable {
    public let timestamp: Date
    public let close: Double
    
    public init(timestamp: Date, close: Double) {
        self.timestamp = timestamp
        self.close = close
    }
}


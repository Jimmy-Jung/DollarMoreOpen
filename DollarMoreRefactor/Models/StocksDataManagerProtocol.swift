//
//  StocksDataManagerProtocol.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/06/10.
//

import Foundation

protocol StocksDataManagerProtocol {
    func fetchChartData(
        stockSymbol: StocksSymbol,
        range: ChartRange) async -> ChartData?
    
    func fetchWithHanaData(
        stockSymbol: StocksSymbol,
        startOfDay: TimeInterval) async -> ChartData?
    
    func fetchHanaChartData(
    ) async -> Result<ChartData?, HanaAPIServiceError>
}

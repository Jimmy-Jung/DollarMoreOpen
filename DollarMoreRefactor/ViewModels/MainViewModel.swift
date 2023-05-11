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
    
    @Published var usdData: ChartData?
    @Published var indexData: ChartData?
    @Published var hanaData: ChartData?
    
    @Published var usdLabelSet: CurrencyLabelData?
    @Published var indexLabelSet: CurrencyLabelData?
    @Published var hanaLabelSet: CurrencyLabelData?
    
    @Published var usdReferenceTimeLabel: String = ""
    @Published var hanaReferenceTimeLabel: String = ""
    
    
    
}




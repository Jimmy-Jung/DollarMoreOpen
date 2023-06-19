//
//  CustomFont.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/06/15.
//

import UIKit

enum CustomFont: Int, CaseIterable {
    case system = 0
    case size1 = 1
    case size2 = 2
    case size3 = 3
    case size4 = 4
}
extension UIFont {
    
    func customFont(ofSize fontSize: CGFloat, isBold: Bool = false) -> UIFont {
        switch UserFont.customFont {
        case CustomFont.size1.rawValue:
            return UIFont.systemFont(ofSize: fontSize + 1)
        case CustomFont.size2.rawValue:
            return UIFont.systemFont(ofSize: fontSize + 2)
        case CustomFont.size3.rawValue:
            return UIFont.systemFont(ofSize: fontSize + 3)
        case CustomFont.size4.rawValue:
            return UIFont.systemFont(ofSize: fontSize + 4)
        default:
            return UIFont.systemFont(ofSize: fontSize)
        }
    }
}

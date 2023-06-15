//
//  CustomFont.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/06/15.
//

import UIKit

enum CustomFont: Int, CaseIterable {
    case system = 0
    case small = 1
    case midium1 = 2
    case midium2 = 3
    case large = 4
}

extension UIFont {
   
    var customSmallTextFont: UIFont {
        return customFont(ofSize: 15)
    }
    
    var customTextFont: UIFont {
        return customFont(ofSize: 17)
    }
    
    var customContentFont: UIFont {
        return customFont(ofSize: 18)
    }
    
    var customTitleFont: UIFont {
        return customFont(ofSize: 20)
    }
    
    var customBoldTitleFont: UIFont {
        return customFont(ofSize: 20, isBold: true)
    }
    
    /// Home - 총금액 표시레이블에 사용
    var customExtraLargeFont: UIFont {
        return customFont(ofSize: 25, isBold: true)
    }
    
    func customFont(ofSize fontSize: CGFloat, isBold: Bool = false) -> UIFont {
        switch UserFont.customFont {
        case CustomFont.small.rawValue:
            return UIFont.systemFont(ofSize: fontSize + 1)
        case CustomFont.midium1.rawValue:
            return UIFont.systemFont(ofSize: fontSize + 2)
        case CustomFont.midium2.rawValue:
            return UIFont.systemFont(ofSize: fontSize + 3)
        case CustomFont.large.rawValue:
            return UIFont.systemFont(ofSize: fontSize + 4)
        default:
            return UIFont.systemFont(ofSize: fontSize)
        }
    }
}

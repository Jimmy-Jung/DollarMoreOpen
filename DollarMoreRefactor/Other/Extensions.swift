//
//  Extensions.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/12.
//

import Foundation
import SVProgressHUD


extension UIViewController {
    func showLoader() {
        SVProgressHUD.show()
        SVProgressHUD.setForegroundColor(UIColor.secondaryLabel)
        SVProgressHUD.setRingThickness(3.0)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
    }

    func hideLoader() {
        SVProgressHUD.dismiss()
    }
}

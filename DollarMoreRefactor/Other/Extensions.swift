//
//  Extensions.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/12.
//

import Foundation
import JGProgressHUD

extension UIViewController {
    static let hud = JGProgressHUD()
    func showLoader(_ show: Bool) {
        view.endEditing(true)
        if show {
            UIViewController.hud.tintColor = .secondaryLabel
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }
}

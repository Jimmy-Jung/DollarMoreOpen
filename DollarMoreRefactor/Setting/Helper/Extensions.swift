//
//  Extensions.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/06/15.
//

import UIKit

extension UIViewController {
    func setNavigationBarAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .systemBackground
        navigationBarAppearance.shadowColor = nil
        
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        
    }
}
extension Date {
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    public var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    public var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    public var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    public var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }

}

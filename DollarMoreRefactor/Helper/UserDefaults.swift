//
//  UserDefaults.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/06/15.
//

import UIKit

@propertyWrapper
struct UserDefault<T> {
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

struct FirstLaunch {
    @UserDefault(key: keyEnum.launchedBefore.rawValue, defaultValue: false)
    static var launchedBefore: Bool
}

struct DarkMode {
    @UserDefault(key: keyEnum.isDarkMode.rawValue, defaultValue: false)
    static var isDarkMode: Bool
}

struct UserFont {
    @UserDefault(key: keyEnum.customFont.rawValue, defaultValue: CustomFont.system.rawValue)
    static var customFont: Int
}

enum keyEnum: String {
    case launchedBefore = "hasShownAdConsentScreen"
    case isDarkMode = "isDarkMode"
    case customFont = "customFont"
}


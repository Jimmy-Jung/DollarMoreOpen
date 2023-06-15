//
//  UserDefaults.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/06/15.
//

import Foundation

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

struct RegisterDate {
    @UserDefault(key: keyEnum.firstRegisteredDate.rawValue, defaultValue: Date())
    static var firstRegisteredDate: Date
}

struct UserName {
    @UserDefault(key: keyEnum.username.rawValue, defaultValue: "User")
    static var username: String
}

struct MaximumCost {
    @UserDefault(key: keyEnum.maximum.rawValue, defaultValue: 0)
    static var maximum: Int
}

struct UserFont {
    @UserDefault(key: keyEnum.customFont.rawValue, defaultValue: CustomFont.system.rawValue)
    static var customFont: Int
}

struct DarkMode {
    @UserDefault(key: keyEnum.isDarkMode.rawValue, defaultValue: false)
    static var isDarkMode: Bool
}

enum keyEnum: String {
    case launchedBefore = "launchedBefore"
    case firstRegisteredDate = "firstRegisteredDate"
    case username = "username"
    case maximum = "maximum"
    case customFont = "customFont"
    case isDarkMode = "isDarkMode"
}

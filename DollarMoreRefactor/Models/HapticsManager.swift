//
//  HapticsManager.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/11.
//

import UIKit

/// Object to manage haptics
final class HapticsManager {
    /// Singleton
    static let shared = HapticsManager()
    
    /// Private constructor
    private init() {}
    
    // MARK: - Public
    
    /// Vibrate slightly for selection
    public func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    /// Play haptic for given type interaction
    /// - Parameter type: Type to vibrate for
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    /// 드래그 햅틱
    public func dragVibrate() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        //feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
}


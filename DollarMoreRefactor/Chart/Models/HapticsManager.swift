//
//  HapticsManager.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/11.
//

import UIKit

/// 햅틱 매니저
final class HapticsManager {
    /// 싱글톤
    static let shared = HapticsManager()
    
    /// Private constructor
    private init() {}
    
    // MARK: - Public
    
    /// 선택시 얇은 진동 피드백
    public func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    /// 햅틱 반응 선택
    /// - Parameter type: 진동 타입
    public func vibrate(
        for type: UINotificationFeedbackGenerator.FeedbackType
    ) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    /// 드래그 햅틱
    public func dragVibrate() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
}


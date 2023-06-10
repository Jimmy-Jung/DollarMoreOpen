//
//  SceneDelegate.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/11.
//

import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        hasShownAdConsentScreen()
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    private func hasShownAdConsentScreen() {
        if !UserDefaults.standard.bool(forKey: "hasShownAdConsentScreen") {
                // "무료 앱은 광고로 유지됩니다" 라벨과 "계속" 버튼이 있는 뷰컨트롤러를 생성합니다.
                let adConsentVC = AdConsentViewController()

                // 뷰컨트롤러를 표시합니다.
            window?.rootViewController = adConsentVC

                // 뷰컨트롤러가 표시된 것을 저장합니다.
                UserDefaults.standard.set(true, forKey: "hasShownAdConsentScreen")
            }
    }
    
}


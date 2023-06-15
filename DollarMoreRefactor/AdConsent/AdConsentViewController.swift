//
//  AdConsentViewController.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/06/11.
//

import UIKit
import AdSupport
import AppTrackingTransparency

final class AdConsentViewController: UIViewController {
    // MARK: - Properties
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "dollarsign.circle")
        imageView.tintColor = .systemYellow
        return imageView
    }()
    private lazy var tittleLabel:  UILabel = {
        let label = UILabel()
        label.text = "무료 앱은 광고로 유지됩니다."
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var messageLabel:  UILabel = {
        let label = UILabel()
        label.text = "사용자의 광고 활동 정보(예: 광고를 볼 후 수행한 작업)를 광고 서비스 제공업체와 공유할지 결정하세요. 공유된 정보는 개인에게 최적화된 광고 경혐을 제공하기 위해 사용합니다."
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    
    
    lazy var continueButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.setTitle("계속", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.systemBackground, for: .normal)
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .systemBackground
        setupLayout()
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        tittleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [tittleLabel, messageLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(stackView)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: min(view.frame.width - 100,300)),
//            stackView.leftAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
//            stackView.rightAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            
            continueButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.widthAnchor.constraint(equalToConstant: 250),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc private func continueButtonTapped() {
        setNotification()
        self.dismiss(animated: true) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
            tabBarController.selectedIndex = 0
            self.view.window?.rootViewController = tabBarController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    private func setNotification() {
        let n = NotificationHandler()
        n.askNotificationPermission {
            // 다른 권한 요청 창보다 늦게 띄우기
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if #available(iOS 14, *) {
                    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                        switch status {
                        case .authorized:        // 허용됨
                            print("Authorized")
                            print("IDFA = \(ASIdentifierManager.shared().advertisingIdentifier)")    // IDFA 접근
                        case .denied:        // 거부됨
                            print("Denied")
                        case .notDetermined:    // 결정되지 않음
                            print("Not Determined")
                        case .restricted:        // 제한됨
                            print("Restricted")
                        @unknown default:        // 알려지지 않음
                            print("Unknown")
                        }
                    })
                }
            }
        }
    }
    
    
    // MARK: - Overrides
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


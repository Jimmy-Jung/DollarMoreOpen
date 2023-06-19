//
//  NotificationViewController.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/06/15.
//

import UIKit
import SnapKit
//import SwiftUI

final class NotificationViewController: UIViewController {
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "매일 알림"
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 소비 기록을 잊지 않도록 알려드려요"
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .darkGray
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.date = Date()
        picker.datePickerMode = .time
        picker.locale = Locale(identifier: "ko_KR")
        picker.timeZone = .autoupdatingCurrent
        picker.contentHorizontalAlignment = .leading
        picker.minuteInterval = 10
        return picker
    }()
    
    private lazy var dailyNotificationSwitch: UISwitch = {
        let modeSwitch = UISwitch()
        modeSwitch.onTintColor = .systemGreen
        modeSwitch.contentHorizontalAlignment = .trailing
        modeSwitch.isOn = isDailyNotiOn
        return modeSwitch
    }()
    
    private lazy var upperStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [datePicker, dailyNotificationSwitch])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private let secondTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "매월 1일"
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let secondSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이번달 소비한도 수정 알림"
        label.numberOfLines = 1
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var monthlyNotificationSwitch: UISwitch = {
        let modeSwitch = UISwitch()
        modeSwitch.onTintColor = .systemGreen
        modeSwitch.contentHorizontalAlignment = .trailing
        modeSwitch.isOn = isMonthlyNotiOn
        return modeSwitch
    }()
    
    private lazy var lowerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [secondSubtitleLabel, monthlyNotificationSwitch])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    private var isDailyNotiOn = UserDefaults.standard.bool(forKey: "isDailyNotiOn") {
        didSet {
            UserDefaults.standard.set(isDailyNotiOn, forKey: "isDailyNotiOn")
            datePicker.isEnabled = isDailyNotiOn
        }
    }
    
    private var isMonthlyNotiOn = UserDefaults.standard.bool(forKey: "isMonthlyNotiOn") {
        didSet {
            UserDefaults.standard.set(isMonthlyNotiOn, forKey: "isMonthlyNotiOn")
        }
    }
    
    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        setDatePicker()
        setNavigationBarAppearance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.addTarget(self, action: #selector(timeSetHasChanged), for: .valueChanged)
        dailyNotificationSwitch.addTarget(self, action: #selector(updateNotificationSetting), for: .valueChanged)
        monthlyNotificationSwitch.addTarget(self, action: #selector(updateNotificationSetting), for: .valueChanged)
        
        configure()
    }
    
    // MARK: - Actions
    @objc func timeSetHasChanged(_ sender: UIDatePicker) {
        updateNotificationSetting(dailyNotificationSwitch)
        UserDefaults.standard.set(sender.date, forKey: "notiTime")
    }
    
    @objc func updateNotificationSetting(_ sender: UISwitch) {
        if sender.isOn {
            let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .sound)
            
            userNotificationCenter.requestAuthorization(options: authOptions) { success, error in
                if success {
                    if sender == self.dailyNotificationSwitch {
                        DispatchQueue.main.async {
                            self.sendDailyNotification(baseTime: self.datePicker.date)
                            self.isDailyNotiOn = true
                        }
                    } else {
                        self.sendMonthlyNotification()
                        self.isMonthlyNotiOn = true
                    }
                    print("Notification: 설정 완료")
                } else {
                    if let error {
                        print("Notification Error: ", error)
                    }
                }
            }
            
        } else {
            if sender == dailyNotificationSwitch {
                userNotificationCenter.removePendingNotificationRequests(withIdentifiers: ["dailyNoti"])
                isDailyNotiOn = false
                print("Notification: 매일 알림 취소")
            } else {
                userNotificationCenter.removePendingNotificationRequests(withIdentifiers: ["monthlyNoti"])
                isMonthlyNotiOn = false
                print("Notification: 매월 1일 알림 취소")
            }
        }
    }

    // MARK: - Helpers
    func configure() {
        view.backgroundColor = .systemBackground
        [titleLabel, descriptionLabel, upperStackView, secondTitleLabel, lowerStackView].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        upperStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        secondTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(upperStackView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        lowerStackView.snp.makeConstraints { make in
            make.top.equalTo(secondTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    func sendDailyNotification(baseTime: Date) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "삐용비용을 입력할 시간!"
        notificationContent.body = "오늘 하루 감정 소비를 기록해주세요"
        notificationContent.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = baseTime.hour
        dateComponents.minute = baseTime.minute

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )
        
        let request = UNNotificationRequest(identifier: "dailyNoti",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { error in
            if let error {
                print("Notification Error: ", error)
            }
        }
    }
    
    func sendMonthlyNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "새로운 달의 소비한도 설정하기!"
        notificationContent.body = "이번 달은 최대 얼마의 삐용비용을 사용할까요?"
        notificationContent.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )
        
        let request = UNNotificationRequest(identifier: "monthlyNoti",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { error in
            if let error {
                print("Notification Error: ", error)
            }
        }
    }
    
    func setDatePicker() {
        datePicker.isEnabled = isDailyNotiOn // 알림 설정 off일 땐, DatePicker 선택 불가

        guard let baseTime = UserDefaults.standard.object(forKey: "notiTime") as? Date else {
            return
        }
        datePicker.date = baseTime
    }
//
//    struct NotificationViewController_PreViews: PreviewProvider {
//        static var previews: some View {
//            NotificationViewController().toPreview()
//        }
//    }
}

//
//  SettingViewController.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/06/15.
//

import UIKit
import SnapKit
import MessageUI


final class SettingViewController: UIViewController {
    
    // MARK: - Properties
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        
        return table
    }()
    
    var model: [Section] = []
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
        configureUI()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Helpers
    func configureUI() {
        navigationItem.title = "설정"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configureData() {
        let bodyString = """
                 문의 사항 및 의견을 작성해주세요.
                 
                 
                 
                 
                 -------------------
                 
                 Device Model : \(Utils.getDeviceModelName())
                 Device OS : \(UIDevice.current.systemVersion)
                 App Version : \(Utils.getAppVersion())
                 
                 -------------------
                 """
        self.model.append(
            Section(
                title: "시스템",
                options: [
                    .switchCell(
                        model: SettingSwitchOption(
                            title: "다크모드",
                            icon: UIImage(systemName: "moon.fill"),
                            iconBackgroundColor: .darkGray) {}
                    ),
                    .staticCell(
                        model: SettingsOption(
                            title: "알림",
                            icon: UIImage(systemName: "bell.fill"),
                            iconBackgroundColor: .systemRed) {
                                let vc = NotificationViewController()
                                vc.navigationItem.title = "알림"
                                self.navigationController?
                                    .pushViewController(vc, animated: true)
                            }
                    ),
                    .staticCell(
                        model: SettingsOption(
                            title: "서체 변경",
                            icon: UIImage(systemName: "textformat"),
                            iconBackgroundColor: .black) {
                                let vc = FontTableViewController()
                                vc.navigationItem.title = "서체 변경"
                                self.navigationController?
                                    .pushViewController(vc, animated: true)
                            }
                    )
                ]
            )
        )
        
        self.model.append(
            Section(
                title: "정보",
                options: [
                    .staticCell(
                        model: SettingsOption(
                            title: "문의하기",
                            icon: UIImage(systemName: "questionmark.circle.fill"),
                            iconBackgroundColor: .systemBlue
                        ) {
                            if MFMailComposeViewController.canSendMail() {
                                let vc = MFMailComposeViewController()
                                vc.mailComposeDelegate = self
                                
                                
                                vc.setToRecipients(["DollarMoreSP@gmail.com"])
                                vc.setSubject("[달러모아] 문의")
                                vc.setMessageBody(bodyString, isHTML: false)
                                
                                self.present(vc, animated: true, completion: nil)
                            } else {
                                let sendMailErrorAlert =
                                UIAlertController(
                                    title: "메일 전송 실패",
                                    message: "'Mail' 앱을 찾을 수 없습니다.",
                                    preferredStyle: .alert
                                )
                                let okAction =
                                UIAlertAction(
                                    title: "확인",
                                    style: .destructive,
                                    handler: nil
                                )
                                sendMailErrorAlert.addAction(okAction)
                                self.present(
                                    sendMailErrorAlert,
                                    animated: true,
                                    completion: nil
                                )
                            }
                        }
                    ),
                    .staticCell(
                        model: SettingsOption(
                            title: "버전",
                            icon: UIImage(systemName: "wand.and.rays.inverse"),
                            iconBackgroundColor: .lightGray) {}
                    )
                ]
            )
        )
    }
    
    
}

// MARK: - UITableViewDataSource
extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = model[indexPath.section].options[indexPath.row]
        
        switch data.self {
        case .staticCell(let data):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
            cell.configure(with: data)
            return cell
            
        case .switchCell(let data):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as? SwitchTableViewCell else { return UITableViewCell() }
            cell.configure(with: data)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = model[section]
        return section.title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}

// MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let type = model[indexPath.section].options[indexPath.row]
        switch type.self {
        case .staticCell(let data):
            data.handler()
        case .switchCell(let data):
            data.handler()
            
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}



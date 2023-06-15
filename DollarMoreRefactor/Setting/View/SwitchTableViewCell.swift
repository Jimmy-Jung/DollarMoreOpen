//
//  SwitchTableViewCell.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/06/15.
//

import UIKit
import SnapKit

final class SwitchTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let identifier = "SwitchTableViewCell"
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let modeSwitch: UISwitch = {
        let modeSwitch = UISwitch()
        modeSwitch.onTintColor = .systemGreen
        return modeSwitch
    }()
    
    // MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.accessoryType = .none
        
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        contentView.addSubview(modeSwitch)
        contentView.addSubview(label)
        modeSwitch.addTarget(self, action: #selector(updateAppearance), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.frame.size.height - 12
        iconContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(size)
        }
        
        let imageSize = size / 1.5
        iconContainer.center = iconContainer.center
        iconImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(imageSize)
        }

        label.snp.makeConstraints { make in
            make.centerY.height.equalToSuperview()
            make.leading.equalTo(iconContainer.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(10)
        }
        
        modeSwitch.sizeToFit()
        modeSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // reset
        modeSwitch.isOn = DarkMode.isDarkMode
    }
    
    // MARK: - Helpers
    public func configure(with model: SettingSwitchOption) {
        label.text = model.title
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
        modeSwitch.isOn = DarkMode.isDarkMode
    }
    
    @objc func updateAppearance(_ sender: UISwitch) {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        let windows = window.windows.first
        windows?.overrideUserInterfaceStyle = sender.isOn == true ? .dark : .light
        DarkMode.isDarkMode = sender.isOn
    }
}

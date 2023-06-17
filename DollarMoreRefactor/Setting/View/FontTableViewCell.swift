//
//  SettingTableViewCell.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/06/15.
//

import UIKit
import SnapKit

class FontTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "FontTableViewCell"

    let fontNameLabel: UILabel = {
        let label = UILabel()
        label.text = "폰트 이름"
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17)
        
        return label
    }()
    
    private let radioButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle.circle"), for: .normal)
        button.isEnabled = false
        button.tintColor = .systemGreen
        return button
    }()
    // MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(fontNameLabel)
        contentView.addSubview(radioButton)
        backgroundColor = .systemBackground
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            radioButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
        } else {
            radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    
    override func layoutSubviews() {
        fontNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        radioButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
}

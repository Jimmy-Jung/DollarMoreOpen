//
//  FontExampleHeaderView.swift
//  Bbiyong-Biyong
//
//  Created by Jade Yoo on 2023/04/06.
//

import UIKit
import SnapKit

class FontExampleHeaderView: UIView {
    // MARK: - Properties
    private let exampleLabel: UILabel = {
        let label = UILabel()
        label.text = "굴비를 든 삐용이\n123456789"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        return label
    }()

    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(exampleLabel)
        exampleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func changeTextFont(font: UIFont) {
        exampleLabel.font = font
    }
    
}

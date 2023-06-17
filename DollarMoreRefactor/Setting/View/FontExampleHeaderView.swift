//
//  FontExampleHeaderView.swift
//  Bbiyong-Biyong
//
//  Created by Jade Yoo on 2023/04/06.
//

import UIKit
import SnapKit

final class FontExampleHeaderView: UIView {
    // MARK: - Properties
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    let stackView = UIStackView()
    
    let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        label.numberOfLines = 2
        label.text = "[오늘 외환딜러 환율 예상레인지]"
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 3
        label.text = "서울 외환시장의 외환딜러들은 15일 달러-원 환율이 1,270원대를 중심으로 등락할 것으로 전망했다. 미 연방공개시장위원회(FOMC)는 기준금리를 동결했다"
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.text = "1시간전"
        return label
    }()
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .fill
        self.addSubview(backgroundView)
        backgroundView.addSubview(stackView)
        backgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        stackView.addArrangedSubview(newsTitleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(releaseDateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func changeTextFont(size: CGFloat) {
        newsTitleLabel.font = UIFont.systemFont(ofSize: 16 + size, weight: .heavy)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14 + size, weight: .medium)
        releaseDateLabel.font = UIFont.systemFont(ofSize: 12 + size, weight: .medium)
        self.layoutIfNeeded()
    }
    
}

//
//  NewsCell.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/24.
//

import UIKit

final class NewsCell: UITableViewCell {

    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var newsLink: String?
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    
    // 스토리보드 또는 Nib으로 만들때, 사용하게 되는 생성자 코드
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
   
}


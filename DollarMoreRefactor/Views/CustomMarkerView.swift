//
//  CustomMarkerView.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/12.
//

import Charts
import UIKit

class CustomMarkerView: MarkerView {
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet var contentView: UIView!
    override init(frame: CGRect) {
            super.init(frame: frame)
            initUI()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            initUI()
        }
        
        private func initUI() {
            Bundle.main.loadNibNamed("CustomMarkerView", owner: self, options: nil)
            addSubview(contentView)
            backgroundColor = .clear
            contentView.backgroundColor = .clear

            self.frame = CGRect(x: 0, y: 0, width: dateLabel.frame.width, height: 40)
            self.offset = CGPoint(x: -self.frame.width/2, y: -self.frame.height*2)
        }
    
    public func updateOffset() {
        guard let chartViewHeight = chartView?.bounds.height else {return}
        let markerViewHeight = self.bounds.height
        let offset =
        CGPoint(x: -self.frame.width/2, y: -chartViewHeight - markerViewHeight)
        self.offset = offset
    }
}

//
//  CustomMarkerView.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/12.
//

import Charts
import UIKit

final class CustomMarkerView: MarkerView {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var centerY: NSLayoutConstraint!
    @IBOutlet weak var centerX: NSLayoutConstraint!
    override init(frame: CGRect) {
    super.init(frame: frame)
            initUI()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        private func initUI() {
            Bundle.main.loadNibNamed("CustomMarkerView", owner: self, options: nil)
            addSubview(contentView)
            backgroundColor = .clear

            self.frame = CGRect(x: 0, y: 0, width: dateLabel.frame.width + 10, height: 40)
            self.offset = CGPoint(x: -self.frame.width/2, y: -self.bounds.height*2)
        }
    public func adjustTOP() {
        centerY.constant = -20
        centerX.constant = -self.frame.width/2
        self.layoutIfNeeded()
    }
    public func updateOffset() {
        guard let chartViewHeight = chartView?.bounds.height else {return}
        let markerViewHeight = self.bounds.height
        let offset =
        CGPoint(x: -self.frame.width/2, y: -chartViewHeight - markerViewHeight - markerViewHeight)
        self.offset = offset
    }
    
   
}

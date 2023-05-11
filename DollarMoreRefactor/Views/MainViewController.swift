//
//  ViewController.swift
//  DollarMore
//
//  Created by 정준영 on 2023/04/18.
//

import UIKit
import Charts

final class MainViewController: UIViewController {
    
    // MARK: - Outlet
    /// 1. 기준시간 레이블
    @IBOutlet weak var referenceTimeLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    // 2. 실시간 환율
    // USD 실시간
    @IBOutlet weak var usdFlag: UIImageView!
    @IBOutlet weak var usdCurrencyLabel: UILabel!
    @IBOutlet weak var usdUpDownImage: UIImageView!
    @IBOutlet weak var rateDiff: UILabel!
    @IBOutlet weak var rateDiffPercentage: UILabel!
    
    // 달러 인덱스
    @IBOutlet weak var dollarIndexLabel: UILabel!
    @IBOutlet weak var indexUpDownImage: UIImageView!
    @IBOutlet weak var indexRateDiff: UILabel!
    @IBOutlet weak var indexRateDiffPercentage: UILabel!
    
    // 3. 그래프 버튼
    @IBOutlet weak var currencyIndexButton: UIButton!
    @IBOutlet weak var hanaBankButton: UIButton!
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var dollarIndexButton: UIButton!
    // 3-1.버튼 라인
    @IBOutlet weak var currencyIndexLine: UIView!
    @IBOutlet weak var hanaBankLine: UIView!
    @IBOutlet weak var currencyLine: UIView!
    @IBOutlet weak var dollarIndexLine: UIView!
    
    // 4.그래프 뷰
    @IBOutlet weak var graphView: UIView!
    
    // 6. 하나은행 뷰
    @IBOutlet weak var hanaBankView: UIView!
    @IBOutlet weak var hanaReferenceTimeLabel: UILabel!
    
    //4.범위버튼
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var threeMonthButton: UIButton!
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var fiveYearButton: UIButton!
    
    // 5. 하나은행 실시간
    @IBOutlet weak var hanaCurrencyLabel: UILabel!
    @IBOutlet weak var hanaUpDownImage: UIImageView!
    @IBOutlet weak var hanaRateDiff: UILabel!
    @IBOutlet weak var hanaRateDiffPercentage: UILabel!
    @IBOutlet weak var hanaBuyCurrency: UILabel!
    @IBOutlet weak var hanaSellCurrency: UILabel!
    
    /// 범위 버튼들
    private lazy var rangeButton: [UIButton] = [
        dayButton,
        weekButton,
        monthButton,
        threeMonthButton,
        yearButton,
        fiveYearButton
    ]
    
    /// 그래프 버튼 밑 라인들
    private lazy var lines: [UIView] = [
        currencyIndexLine,
        currencyLine,
        dollarIndexLine,
        hanaBankLine
    ]
    
    /// 달러인덱스 레이블 모음
    private lazy var indexLabelSet: [UIView] = [
        dollarIndexLabel,
        indexRateDiff,
        indexRateDiffPercentage,
        indexUpDownImage
    ]
    
    /// 달러원 레이블 모음
    private lazy var dollarWonLabelSet: [UIView] = [
        usdCurrencyLabel,
        rateDiff,
        rateDiffPercentage,
        usdUpDownImage
    ]
    /// 하나은행 레이블 모음
    private lazy var hanaLabelSet: [UIView] = [
        hanaCurrencyLabel,
        hanaRateDiff,
        hanaRateDiffPercentage,
        hanaUpDownImage
    ]
    
    /// 기간
//    private let period: [ChartRange] = [
//        .oneDay,
//        .oneWeek,
//        .oneMonth,
//        .threeMonth,
//        .oneYear,
//        .fiveYear
//    ]
    
    // MARK: - 프로퍼티
    /// 버튼 눌렀을 때 그래프 바꾸기
    private var currentButtonState: (Int, Int) = (0, 0) {
        didSet {}
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
        }

    // MARK: - Action
    /// 1. 새로고침 버튼
    /// - Parameter sender: 버튼
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
    }
    
    /// 2. 그래프 버튼 선택(햅틱 반응)
    /// - Parameter sender: 주기 선택
    @IBAction func graphButtonTapped(_ sender: UIButton) {
    }
    
    /// 4. 범위 버튼 선택
    /// - Parameter sender: 범위 버튼
    @IBAction func rangeButtonTapped(_ sender: UIButton) {
    }
}


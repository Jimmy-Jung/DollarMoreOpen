//
//  ViewController.swift
//  DollarMore
//
//  Created by 정준영 on 2023/04/18.
//

import UIKit
import Charts
import Combine

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
    
    // MARK: - View Properties Sets
    
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
    private let period: [ChartRange] = [
        .oneDay,
        .oneWeek,
        .oneMonth,
        .threeMonth,
        .oneYear,
        .fiveYear
    ]
    
    // MARK: - Properties
    /// 뷰모델
    private let mainViewModel = MainViewModel()
    // cancellable을 저장하기 위한 Set 선언
    private var cancellables = Set<AnyCancellable>()
    private var dualChartView = DualChartView()
    private var singleChartView = SingleChartView()
    /// 타이머
    private var timer: Timer?
    /// 버튼 눌렀을 때 그래프 바꾸기
    /// (symbol, range)
    private var currentButtonState: (Int, Int) = (0, 0) {
        didSet {
            if currentButtonState.0 == 3 {
                currentButtonState = (3,0)
                rangeButton.forEach { $0.isEnabled = false }
                dayButton.isEnabled = true
            } else {
                rangeButton.forEach { $0.isEnabled = true }
            }
            showLoader(true)
            if currentButtonState.0 == 0 {
                self.dualChartView = DualChartView()
            } else {
                self.singleChartView = SingleChartView()
            }
            Task{ await makeChart(with: currentButtonState) }
            showLoader(false)
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Task { await updateChartData() }
        makeTimer()
        setUpGraphButton()
        initCurrentButton()
        setupRangeButton()
        configureSubscribe()
    }
    
    override func viewDidLayoutSubviews() {
        setUpLayers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 뷰컨트롤러가 화면에서 사라지기 전에 타이머를 해제합니다
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Action
    /// 1. 새로고침 버튼
    /// - Parameter sender: 버튼
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        HapticsManager.shared.vibrateForSelection()
        refresh()
        
    }
    /// 2. 그래프 버튼 선택(햅틱 반응)
    /// - Parameter sender: 주기 선택
    @IBAction func graphButtonTapped(_ sender: UIButton) {
        HapticsManager.shared.vibrateForSelection()
        clearLines()
        lines[sender.tag].isHidden = false
        currentButtonState = (sender.tag, currentButtonState.1)
    }
    /// 4. 범위 버튼 선택
    /// - Parameter sender: 범위 버튼
    @IBAction func rangeButtonTapped(_ sender: UIButton) {
        HapticsManager.shared.vibrateForSelection()
        clearButtonBGColor()
        rangeButton[sender.tag].backgroundColor = .secondarySystemFill
        currentButtonState = (currentButtonState.0, sender.tag)
    }
    
    
    // MARK: - Methods
    private func makeTimer() {
        // 1분 마다 refreshButtonTapped 메서드를 호출하도록 예약합니다
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.refresh()
        }
        // 타이머가 실행될 루프에 추가되도록 합니다
        RunLoop.current.add(timer!, forMode: .common)
    }
    private func refresh() {
        UIView.animate(withDuration: 1) {
            self.refreshButton.backgroundColor = .secondarySystemFill
            self.refreshButton.tintColor = .systemBlue
        }
        UIView.animate(withDuration: 1) {
            self.refreshButton.backgroundColor = .clear
            self.refreshButton.tintColor = .secondaryLabel
        }
        showLoader(true)
        Task {
            await updateChartData()
        }
        showLoader(false)
    }
    
    /// 차트데이터, 레이블 데이터 업데이트
    private func updateChartData() async {
        await makeChart(with: currentButtonState)
        switch currentButtonState.0 {
        case 0:
            _ = await mainViewModel.updateSingleChartData(
                symbol: .hanaBank,
                range: .oneDay
            )
        case 1:
            _ = await mainViewModel.updateSingleChartData(
                symbol: .dollar_Index,
                range: .oneDay
            )
            _ = await mainViewModel.updateSingleChartData(
                symbol: .hanaBank,
                range: .oneDay
            )
        case 2:
            _ = await mainViewModel.updateSingleChartData(
                symbol: .dollar_Won,
                range: .oneDay
            )
            _ = await mainViewModel.updateSingleChartData(
                symbol: .hanaBank,
                range: .oneDay
            )
        default:
            _ = await mainViewModel.updateDualChartData(
                range: .oneDay
            )
        }
    }
    // 2. USD 실시간
    ///  USD실시간 셋업
    private func setUpLayers() {
        usdFlag.layer.cornerRadius = 11
        usdFlag.layer.masksToBounds = true
        refreshButton.layer.cornerRadius = 12
        refreshButton.layer.masksToBounds = true
    }
    // 3. 그래프 버튼
    ///  그래프 버튼 셋업
    private func setUpGraphButton() {
        clearLines()
        textSizeToFit()
        currencyIndexLine.isHidden = false
    }
    ///  그래프 버튼 밑 라인 비활성화
    private func clearLines() {
        lines.forEach { $0.isHidden = true }
    }
    /// 그래프 버튼 크기 자동조절
    private func textSizeToFit() {
        lines.forEach { $0.sizeToFit() }
    }
    // 4. 그래프
    private func initCurrentButton() {
        currentButtonState = (0, 0)
    }
    /// 그래프 만들기
    /// - Parameter buttonState: 현재 버튼 상태
    private func makeChart(with buttonState: (Int, Int)) async {
        let symbol = buttonState.0
        let range = period[buttonState.1]
        switch symbol {
        case 0:
            await makeDualChart(with: range)
        case 1, 2:
            await makeSingleChart(
                stockSymbol: symbol == 1 ? .dollar_Won : .dollar_Index,
                range: range
            )
        default:
            await makeSingleChart(
                stockSymbol: .hanaBank,
                range: range
            )
        }
    }
    /// 듀얼그래프 범위 선택해서 만들기
    /// - Parameter range: 차트 범위
    private func makeDualChart(with range: ChartRange) async {
        let chartDatas = await mainViewModel.updateDualChartData(range: range)
        dualChartView.configure(
            with: .init(
                data1: chartDatas.data1,
                data2: chartDatas.data2,
                chartRange: range
            )
        )
        graphView.subviews.first?.removeFromSuperview()
        graphView.addSubview(dualChartView)
        dualChartView.frame = graphView.bounds
    }
    
    /// 싱글차트 만들기
    /// - Parameters:
    ///   - stockName: 종목 이름
    ///   - range: 차트 범위
    ///   - lineColor: 차트 라인 색상
    private func makeSingleChart(
        stockSymbol: StocksDataManager.StocksSymbol,
        range: ChartRange
    ) async {
        let chartData = await mainViewModel.updateSingleChartData(
            symbol: stockSymbol,
            range: range
        )
        singleChartView.configure(with: chartData)
        graphView.subviews.first?.removeFromSuperview()
        graphView.addSubview(singleChartView)
        singleChartView.frame = graphView.bounds
    }
    
    // 5. 범위 버튼
    /// 범위 버는 셋업
    private func setupRangeButton() {
        buttonToRound()
        clearButtonBGColor()
        dayButton.backgroundColor = .secondarySystemFill
    }
    
    /// 범위 버튼 테두리 곡선
    private func buttonToRound() {
        rangeButton.forEach {
            let height = $0.frame.height
            $0.clipsToBounds = true
            $0.layer.cornerRadius = height/2
        }
    }
    
    /// 범위 버튼 배경색상 초기화
    private func clearButtonBGColor() {
        rangeButton.forEach { $0.backgroundColor = .clear }
    }
    
    // MARK: - Subscribe
    private func configureSubscribe() {
        subscribeLabelSet()
        subscribeTimeLabel()
        subscribeSellBuyLabel()
    }
    /// 레이블셋 구독
    private func subscribeLabelSet() {
        let labelSets = [
            (labelSet: dollarWonLabelSet,
             $set: mainViewModel.$usdLabelSet),
            (labelSet: indexLabelSet,
             $set: mainViewModel.$indexLabelSet),
            (labelSet: hanaLabelSet,
             $set: mainViewModel.$hanaLabelSet)
        ]
        
        for set in labelSets {
            set.$set.sink { [weak self] value in
                guard let self = self, let value = value else { return }
                self.updateCurrentRate(currentData: value, labelSet: set.labelSet)
            }.store(in: &cancellables)
        }
    }
    /// 현재시간 레이블 구독
    private func subscribeTimeLabel() {
        mainViewModel.$usdReferenceTimeLabel.receive(on: DispatchQueue.main).sink { [weak self] value in
            guard let self = self else {return}
            self.referenceTimeLabel.text = value
        }.store(in: &cancellables)
        
        mainViewModel.$hanaReferenceTimeLabel.receive(on: DispatchQueue.main).sink { [weak self] value in
            guard let self = self else {return}
            self.hanaReferenceTimeLabel.text = value
        }.store(in: &cancellables)
    }
    
    /// 판매 구매 레이블 구독
    private func subscribeSellBuyLabel() {
        mainViewModel.$hanaSellBuyLabel.receive(on: DispatchQueue.main).sink { [weak self] value in
            guard let self = self else {return}
            self.hanaSellCurrency.text = value.sell
            self.hanaBuyCurrency.text = value.buy
        }.store(in: &cancellables)
    }
    /// 현재 가격 업데이트 델리게이트 메서드
    /// - Parameters:
    ///   - currencyLabelData: 현재 가격 뷰모델에서 가져오기
    ///   - labelSet: 업데이트 할 레이블 모음 셋
    private func updateCurrentRate(
        currentData: MainViewModel.CurrencyLabelData,
        labelSet: [UIView]
    ) {
        guard let currencyLabel = labelSet[0] as? UILabel,
              let rateDiff = labelSet[1] as? UILabel,
              let rateDiffColor = labelSet[1] as? UILabel,
              let rateDiffPercentage = labelSet[2] as? UILabel,
              let rateDiffPercentageColor = labelSet[2] as? UILabel,
              let upDownImage = labelSet[3] as? UIImageView,
              let upDownImageColor = labelSet[3] as? UIImageView
        else { return }
        DispatchQueue.main.async {
            currencyLabel.text = currentData.currencyLabel
            rateDiff.text = currentData.rateDiff
            rateDiffColor.textColor = currentData.rateDiffColor
            rateDiffPercentage.text = currentData.rateDiffPercentage
            rateDiffPercentageColor.textColor = currentData.rateDiffPercentageColor
            upDownImage.image = currentData.upDownImage
            upDownImageColor.tintColor = currentData.upDownImageColor
        }
    }
}


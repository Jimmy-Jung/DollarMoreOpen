//
//  DualChartView.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/14.
//

import UIKit
import Charts

final class DualChartView: UIView, ChartViewDelegate {
   
    /// 차트데이터셋
    struct ChartDataSet {
        let data1: ChartData
        let data2: ChartData
        let lineColor1: [UIColor]
        let lineColor2: [UIColor]
        let chartRange: ChartRange
    }
    // MARK: - Properties
    private let customMarkerView = CustomMarkerView()
    private let dateFormatter = DateFormatter()
    private var entries1 = [ChartDataEntry]()
    private var entries2 = [ChartDataEntry]()
    // 라인 차트 뷰를 생성
    let chartView: LineChartView = {
        let chartView = LineChartView()
        // 스케일
        chartView.scaleXEnabled = true
        chartView.scaleYEnabled = false
        chartView.autoScaleMinMaxEnabled = true
        // X축
        chartView.xAxis.enabled = true
        chartView.xAxis.granularityEnabled = true
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont =
            .systemFont(ofSize: 11, weight: .medium)
        chartView.xAxis.drawGridLinesEnabled = false
        // Y축
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.enabled = true
        chartView.rightAxis.enabled = true
        chartView.rightAxis.axisLineWidth = 0
        chartView.leftAxis.axisLineWidth = 0
        chartView.rightAxis.labelFont =
            .systemFont(ofSize: 12,weight: .medium)
        chartView.leftAxis.gridColor =
            .secondarySystemFill
        chartView.leftAxis.labelFont =
            .systemFont(ofSize: 12, weight: .medium)
        // 차트 이름
        chartView.legend.enabled = true
        chartView.legend.verticalAlignment = .top
        chartView.legend.horizontalAlignment = .right
        chartView.legend.form = .line
        // 차트 관련
        chartView.highlightPerTapEnabled = false
        chartView.highlightPerDragEnabled = true
        chartView.drawGridBackgroundEnabled = false
        chartView.notifyDataSetChanged()
        chartView.extraTopOffset = 20.0
        return chartView
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(chartView)
        setupMarker()
        chartView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = bounds
        customMarkerView.updateOffset()
    }
    
    // MARK: - Public Methods
    public func configure(with chartDataSet: ChartDataSet) {
        entries1 = [ChartDataEntry]()
        entries2 = [ChartDataEntry]()
        fetchEntries(with: chartDataSet)
        configureDataSet(with: chartDataSet)
        chartView.xAxis.valueFormatter = DateValueFormatter(
            data: chartDataSet.data1.indicators,
            range: chartDataSet.chartRange
        )
        dateFormat(with: chartDataSet)
        if chartDataSet.chartRange ==
            .threeMonth || chartDataSet.chartRange == .oneDay {
            chartView.xAxis.labelCount = 4
        }
    }
    
    // MARK: - Private Methods
    private func fetchEntries(with chartDataSet: ChartDataSet) {
        chartDataSet.data1.indicators.forEach { indicator in
            let timestamp = indicator.timestamp.timeIntervalSince1970 * 1000
            let entry = ChartDataEntry(x: timestamp, y: indicator.close)
            entries1.append(entry)
        }
        chartDataSet.data2.indicators.forEach { indicator in
            let timestamp = indicator.timestamp.timeIntervalSince1970 * 1000
            let entry = ChartDataEntry(x: timestamp, y: indicator.close)
            entries2.append(entry)
        }
    }
    
    /// 데이터셋 패치
    /// - Parameter entries: 좌표값모음
    /// - Returns: 라인차트 데이터 셋
    private func fetchDataSet(with entries: [ChartDataEntry], label: String) -> LineChartDataSet {
        let toggle = entries == entries1
        let dataSet = LineChartDataSet(
            entries: entries,
            label: label
        )
        dataSet.axisDependency = toggle ? .left : .right
        dataSet.fillColor = .clear
        dataSet.drawFilledEnabled = true
        dataSet.drawIconsEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 2
        return dataSet
    }
    
    /// 데이터셋 구성하기
    private func configureDataSet(with chartDataSet: ChartDataSet) {
        var label1: String
        var label2: String
        var toggle: YAxis.AxisDependency
        switch (chartDataSet.lineColor1, chartDataSet.lineColor2) {
        case ([.systemOrange], [.systemBlue]):
            label1 = "국제환율"
            label2 = "달러인덱스"
            toggle = .left
        default:
            label1 = "국제환율"
            label2 = "하나은행"
            toggle = .right
        }
        
        chartView.leftAxis.enabled = toggle == .right ? false : true
        let dataset1 = fetchDataSet(with: entries1, label: label1)
        dataset1.colors = chartDataSet.lineColor1
        dataset1.axisDependency = toggle
        let dataset2 = fetchDataSet(with: entries2, label: label2)
        dataset2.colors = chartDataSet.lineColor2
        chartView.data = LineChartData(dataSets: [dataset1, dataset2])
    }
    
    private func createChartDataEntries(
        from data: [Indicator]
    ) -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        for data in data {
            let timestamp = data.timestamp
                .timeIntervalSince1970 * 1000
            let entry = ChartDataEntry(
                x: timestamp,
                y: data.close
            )
            entries.append(entry)
        }
        return entries
    }
    /// 하이라이트 선택시 데이터 포멧
    /// - Parameter chartDataSet: 뷰모델 데이터
    private func dateFormat(with chartDataSet: ChartDataSet) {
        switch chartDataSet.chartRange {
        case .oneDay, .oneWeek:
            dateFormatter.dateFormat = "MM.dd HH:mm"
        default:
            dateFormatter.dateFormat = "yy.MM.dd"
        }
    }
    
    // MARK: - Setup Custom Marker
    private func setupMarker() {
        customMarkerView.chartView = chartView
        customMarkerView.adjustTOP()
        chartView.marker = customMarkerView
    }
    
    // MARK: - ChartViewDelegate
    /// 차트 선택시 해당 값을 띄워주는 UI 구현
    func chartValueSelected(
        _ chartView: ChartViewBase,
        entry: ChartDataEntry,
        highlight: Highlight
    ) {
        HapticsManager.shared.vibrateForSelection() //햅틱반응
        let date = Date(timeIntervalSince1970: entry.x/1000)
        let xAxis = dateFormatter.string(from: date)
        let yAxis = String(format: "%.2f", entry.y)
        customMarkerView.dateLabel.text = xAxis
        customMarkerView.valueLabel.text = yAxis
        
    }
  
}


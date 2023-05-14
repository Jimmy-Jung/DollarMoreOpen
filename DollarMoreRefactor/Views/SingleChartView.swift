//
//  SingleChartView.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/11.
//

import UIKit
import Charts

final class SingleChartView: UIView, ChartViewDelegate {
    /// 차트데이터셋
    struct ChartDataSet {
        let data: ChartData
        let preClose: Double
        let lineColor: [UIColor]
        let chartRange: ChartRange
    }
    
    // MARK: - Properties
    private let customMarkerView = CustomMarkerView()
    private let dateFormatter = DateFormatter()
    private var entries1 = [ChartDataEntry]()
    private var entries2 = [ChartDataEntry]()
    private let chartView: LineChartView = {
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
        chartView.rightAxis.labelFont =
            .systemFont(ofSize: 12,weight: .medium)
        chartView.rightAxis.axisLineWidth = 0
        chartView.rightAxis.enabled = true
        chartView.leftAxis.enabled = false
        // 차트 관련
        chartView.legend.enabled = false // 차트 이름
        chartView.notifyDataSetChanged()
        chartView.highlightPerTapEnabled = false // 선택시 하이라이트
        chartView.extraTopOffset = 30.0
        return chartView
    }()
    
    // MARK: - Public Methods
    public func configure(with chartDataSet: ChartDataSet) {
        entries1 = [ChartDataEntry]()
        entries2 = [ChartDataEntry]()
        fetchEntries(with: chartDataSet)
        fetchPreviousEntries(with: chartDataSet)
        let dataset1 = fetchDataSet(with: chartDataSet)
        let dataset2 = fetchPreviousDataSet()
        chartView.data = LineChartData(dataSets: [dataset1, dataset2])
        dateFormat(with: chartDataSet)
        chartView.xAxis.valueFormatter = DateValueFormatter(
            data: chartDataSet.data.indicators,
            range: chartDataSet.chartRange
        )
    }
    
    // MARK: - Private Methods
    private func fetchEntries(with chartDataSet: ChartDataSet) {
        chartDataSet.data.indicators.forEach { indicator in
            let timestamp = indicator.timestamp.timeIntervalSince1970 * 1000
            let entry = ChartDataEntry(x: timestamp, y: indicator.close)
            entries1.append(entry)
        }
    }
    
    /// 이전 데이터 패치
    /// - Parameter chartDataSet: 차트 데이터 셋
    private func fetchPreviousEntries(with chartDataSet: ChartDataSet) {
        let previousClose = chartDataSet.preClose
        let indicators = chartDataSet.data.indicators
        let firstXAxis = indicators.first!.timestamp.timeIntervalSince1970 * 1000
        let lastXAxis = indicators.last!.timestamp.timeIntervalSince1970 * 1000
        entries2.append(
            contentsOf: [
                ChartDataEntry(x: firstXAxis, y: previousClose),
                ChartDataEntry(x: lastXAxis, y: previousClose)
            ]
        )
    }
    
    /// 데이터셋
    /// - Parameter chartDataSet: 뷰모델 데이터
    private func fetchDataSet(with chartDataSet: ChartDataSet) -> LineChartDataSet {
        let dataSet = LineChartDataSet(entries: entries1)
        dataSet.fillColor = .clear
        dataSet.colors = chartDataSet.lineColor
        dataSet.drawFilledEnabled = true
        dataSet.drawIconsEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 2
        return dataSet
    }
    
    /// 전날 가격 입력
    private func fetchPreviousDataSet() -> LineChartDataSet {
        let dataSet = LineChartDataSet(entries: entries2)
        dataSet.fillColor = .clear
        dataSet.lineDashLengths = [8, 8]
        dataSet.colors = [.secondarySystemFill]
        dataSet.drawFilledEnabled = true
        dataSet.drawIconsEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 2
        return dataSet
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
        chartView.marker = customMarkerView
    }
    
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

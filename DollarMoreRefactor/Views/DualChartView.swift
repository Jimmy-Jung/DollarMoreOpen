//
//  DualChartView.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/05/14.
//

import UIKit
import Charts

final class DualChartView: UIView {
   
    /// 차트데이터셋
    struct ChartDataSet {
        let data1: ChartData
        let data2: ChartData
        let chartRange: ChartRange
    }
    // MARK: - Properties
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
        chartView.highlightPerDragEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.notifyDataSetChanged()
        return chartView
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(chartView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = bounds
    }
    
    // MARK: - Public Methods
    public func configure(with chartDataSet: ChartDataSet) {
        fetchEntries(with: chartDataSet)
        configureDataSet()
        chartView.xAxis.valueFormatter = DateValueFormatter(
            data: chartDataSet.data1.indicators,
            range: chartDataSet.chartRange
        )
        
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
    private func fetchDataSet(with entries: [ChartDataEntry]) -> LineChartDataSet {
        let dataSet2 = LineChartDataSet(
            entries: entries,
            label: entries == entries1 ? "환율" : "달러인덱스"
        )
        dataSet2.axisDependency = .right
        dataSet2.fillColor = .clear
        dataSet2.colors =
        entries == entries1 ? [.systemOrange] : [.systemBlue]
        dataSet2.drawFilledEnabled = true
        dataSet2.drawIconsEnabled = false
        dataSet2.drawValuesEnabled = false
        dataSet2.drawCirclesEnabled = false
        dataSet2.lineWidth = 2
        return dataSet2
    }
    
    /// 데이터셋 구성하기
    private func configureDataSet() {
        let dataset1 = fetchDataSet(with: entries1)
        let dataset2 = fetchDataSet(with: entries2)
        chartView.data = LineChartData(dataSets: [dataset1, dataset2])
    }
    
    
    /// ResetChartView
    func reset() {
        chartView.data = nil
    }
    
}


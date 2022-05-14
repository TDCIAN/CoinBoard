//
//  ChartCardCell.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/05.
//

import UIKit
import Charts
import RxSwift

class ChartCardCell: UICollectionViewCell, ChartViewDelegate {
    private let disposeBag = DisposeBag()
    
    static let identifier = "ChartCardCell"
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var lastChangeLabel: UILabel!
    @IBOutlet weak var chartViewForCardCell: LineChartView!
    
    var viewModel: ChartViewModel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bind(viewModel)
    }
    
    func bind(_ viewModel: ChartViewModel) {
        viewModel.coinName
            .bind(to: coinNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.periodString
            .bind(to: lastChangeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.chartViewSource
            .bind(onNext: { [weak self] chartViewSource in
                self?.renderChart(chartViewSource: chartViewSource)
            }).disposed(by: disposeBag)
    }
    
    // 차트 그리는 곳
    func renderChart(chartViewSource: ChartViewSource) {
        // 데이터 가져오기
        guard let coinChartData = chartViewSource.chartModels.first(
            where: { $0.key == Period.week }
        )?.value else { return }
        // 차트에 필요한 차트데이터 가공
        let chartDataEntry = coinChartData.map { chartData -> ChartDataEntry in
            let time = chartData.time
            let price = chartData.closePrice
            return ChartDataEntry(x: time, y: price)
        }
        
        // 차트에 적용 -> how to draw
        let lineChartDataSet = LineChartDataSet(entries: chartDataEntry, label: "Coin Value")
        // -- draw mode
        lineChartDataSet.mode = .horizontalBezier
        // -- color
        lineChartDataSet.colors = [UIColor.systemRed]
        // -- draw circle
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawCircleHoleEnabled = false
        // -- draw y value
        lineChartDataSet.drawValuesEnabled = false
        // -- highlight when user touch
        lineChartDataSet.highlightEnabled = false
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.highlightColor = UIColor.systemRed
        
        let data = LineChartData(dataSet: lineChartDataSet)
        chartViewForCardCell.data = data
        
        // gradient fill -> 이거 나중에 바꾸면 차트 컬러 바꿀 수 있겠다
        let startColor = UIColor.systemRed
        let endColor = UIColor(white: 1, alpha: 0.3)
        
        let gradientColors = [startColor.cgColor, endColor.cgColor] as CFArray // Colors of the gradient
        let colorLocation: [CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: gradientColors,
            locations: colorLocation
        )
        lineChartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        lineChartDataSet.drawFilledEnabled = true
        
        // Axis - xAxis
        let xAxis = chartViewForCardCell.xAxis
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = xAxisDateFormatter(period: chartViewSource.period)
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = true
        xAxis.drawLabelsEnabled = true
        
        let leftYAxis = chartViewForCardCell.leftAxis
        leftYAxis.drawGridLinesEnabled = false
        leftYAxis.drawAxisLineEnabled = false
        leftYAxis.drawLabelsEnabled = false
        
        let rightYAxis = chartViewForCardCell.rightAxis
        rightYAxis.drawGridLinesEnabled = false
        rightYAxis.drawAxisLineEnabled = false
        rightYAxis.drawLabelsEnabled = false
        
        // User InterAction
        chartViewForCardCell.doubleTapToZoomEnabled = false
        chartViewForCardCell.dragEnabled = false
        
        chartViewForCardCell.delegate = self
        chartViewForCardCell.isUserInteractionEnabled = false
        
        // Chart Description
        let description = Description()
        description.text = ""
        chartViewForCardCell.chartDescription = description
        
        // Legend
        let legend = chartViewForCardCell.legend
        legend.enabled = false
    }
    
    func xAxisDateFormatter(period: Period) -> IAxisValueFormatter {
        switch period {
        case .day: return ChartXAxisDayFormatter()
        case .week: return ChartXAxisWeekFormatter()
        case .month: return ChartXAxisMonthFormatter()
        case .year: return ChartXAxisYearFormatter()
        }
    }
}

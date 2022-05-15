//
//  ChartDetailViewController.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/03.
//

import UIKit
import Charts
import RxSwift
import RxCocoa

//typealias CoinChartInfo = (key: Period, value: [ChartData])
class ChartDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()

    @IBOutlet weak var coinTypeLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var currencyType: UILabel!
    @IBOutlet weak var highlightBar: UIView!
    @IBOutlet weak var highlightBarLeading: NSLayoutConstraint!
    @IBOutlet weak var chartView: LineChartView!
    
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var yearButton: UIButton!
    
//    var viewModel: ChartDetailViewModel!
    
    var chartViewModel: ChartViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(chartViewModel)
        chartViewModel.fetchChartViewSourceList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        updateCoinInfo(viewModel)
        // -> changeHandler에 대한 업데이트
//        viewModel.updateNotify { chartDatas, selectedPeriod in
//            self.renderChart(chartViewSource: chartDatas, selectedPeriod: selectedPeriod)
//        }
//        viewModel.fetchData()
    }
    
    func bind(_ viewModel: ChartViewModel) {
        viewModel.coinName
            .bind(to: coinTypeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.currentPrice
            .bind(to: currentPriceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.currencyType
            .bind(to: currencyType.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.chartViewSourceList
            .subscribe(onNext: { [weak self] chartViewSourceList in
                let dayChartData = chartViewSourceList.first { $0.period == .day }
                print("바인드 - dayChartData - 카운트: \(dayChartData?.chartModels.count)")
                self?.renderChart(chartModels: dayChartData?.chartModels ?? [], selectedPeriod: .day)
            })
            .disposed(by: disposeBag)
        
        dayButton.rx.tap.bind {
            print("데이버튼 클릭함")
            self.moveHighlightBar(to: self.dayButton)
            guard let dayChartData = viewModel.chartViewSourceList.value.first(
                where: { $0.period == Period.day }
            ) else { return }
            self.renderChart(chartModels: dayChartData.chartModels, selectedPeriod: .day)
        }.disposed(by: disposeBag)
        
        weekButton.rx.tap.bind {
            print("위크버튼 클릭함")
            self.moveHighlightBar(to: self.weekButton)
            guard let dayChartData = viewModel.chartViewSourceList.value.first(
                where: { $0.period == Period.week }
            ) else { return }
            self.renderChart(chartModels: dayChartData.chartModels, selectedPeriod: .week)
        }.disposed(by: disposeBag)
        
        monthButton.rx.tap.bind {
            print("몬쓰버튼 클릭함")
            self.moveHighlightBar(to: self.monthButton)
            guard let dayChartData = viewModel.chartViewSourceList.value.first(
                where: { $0.period == Period.month }
            ) else { return }
            self.renderChart(chartModels: dayChartData.chartModels, selectedPeriod: .month)
        }.disposed(by: disposeBag)
        
        yearButton.rx.tap.bind {
            print("이어버튼 클릭함 - 몇개있나: \(viewModel.chartViewSourceList.value.count)")
            self.moveHighlightBar(to: self.yearButton)
            guard let dayChartData = viewModel.chartViewSourceList.value.first(
                where: { $0.period == Period.year }
            ) else { return }
            self.renderChart(chartModels: dayChartData.chartModels, selectedPeriod: .year)
        }.disposed(by: disposeBag)
    }

}

extension ChartDetailViewController {

    private func moveHighlightBar(to button: UIButton) {
        self.highlightBarLeading.constant = button.frame.minX
    }
    
    private func renderChart(chartModels: [ChartModel], selectedPeriod: Period) {
//    func renderChart(chartViewSource: ChartViewSource, selectedPeriod: Period) {
        // 데이터 가져오기
        guard let coinChartData = chartModels.first(
            where: { $0.key == selectedPeriod }
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
        lineChartDataSet.highlightEnabled = true
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.highlightColor = UIColor.systemRed
        
        let data = LineChartData(dataSet: lineChartDataSet)
        chartView.data = data
        
        // gradient fill
        let startColor = UIColor.systemRed
        let endColor = UIColor(white: 1, alpha: 0.3)
        
        let gradientColors = [startColor.cgColor, endColor.cgColor] as CFArray // Colors of the gradient
        let colorLocations: [CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: gradientColors,
            locations: colorLocations
        )
        lineChartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the gradient
        lineChartDataSet.drawFilledEnabled = true // Draw the gradient
        
        // Axis - xAxis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = xAxisDateFormatter(period: selectedPeriod)
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = true
        xAxis.drawLabelsEnabled = true
        
        // Axis - yAxis
        let leftYAxis = chartView.leftAxis
        leftYAxis.drawGridLinesEnabled = false
        leftYAxis.drawAxisLineEnabled = false
        leftYAxis.drawLabelsEnabled = false
        
        let rightYAxis = chartView.rightAxis
        rightYAxis.drawGridLinesEnabled = false
        rightYAxis.drawAxisLineEnabled = false
        rightYAxis.drawLabelsEnabled = false
        
        // User Interaction
        chartView.doubleTapToZoomEnabled = false
        chartView.dragEnabled = true
        
        chartView.delegate = self
        
        // Chart Description
        let description = Description()
        description.text = ""
        chartView.chartDescription = description
        
        // Legend
        let legend = chartView.legend
        legend.enabled = false
    }
}

extension ChartDetailViewController {
    private func xAxisDateFormatter(period: Period) -> IAxisValueFormatter {
        switch period {
        case .day: return ChartXAxisDayFormatter()
        case .week: return ChartXAxisWeekFormatter()
        case .month: return ChartXAxisMonthFormatter()
        case .year: return ChartXAxisYearFormatter()
        }
    }
}

extension ChartDetailViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        currentPriceLabel.text = String(format: "%.1f", entry.y)
    }
}

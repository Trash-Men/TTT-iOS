//
//  ChartViewController.swift
//  TTT-iOS
//
//  Created by 이현욱 on 2021/03/29.
//

import UIKit

import Charts
import RxSwift

class ChartViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var dataEntries: [BarChartDataEntry] = []
    private var areaTrashDic: [String:Int] = [:]
    private var areaTrashCanDic: [String:Int] = [:]
    
    lazy var indicatorView = UIActivityIndicatorView()
    
    let backBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        btn.tintColor = .customRed
        btn.addTarget(self, action: #selector(popVC), for: .touchDown)
        return btn
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 지역 통계"
        label.font = label.font.withSize(20)
        label.textColor = .customRed
        return label
    }()
    
    let trashChart: BarChartView = {
        let view = BarChartView()
        view.noDataText = "데이터가 없습니다"
        view.noDataFont = .systemFont(ofSize: 20)
        view.noDataTextColor = .lightGray
        view.tag = 1
        return view
    }()
    
    let trashCanChart: BarChartView = {
        let view = BarChartView()
        view.noDataText = "데이터가 없습니다"
        view.noDataFont = .systemFont(ofSize: 20)
        view.noDataTextColor = .lightGray
        view.tag = 2
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        autoLayout()
        startAnimation()
    }
    
    override func loadView() {
        super.loadView()
        a()
    }

    func a() {
        NetworkService.shared.getTrashes()
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .map { data in
                var areaArr: [String] = []
                var valueArr: [Int] = []
                data.trashes?.forEach({ info in
                    if self.areaTrashDic[info.area] != nil {
                        let cnt = self.areaTrashDic[info.area]
                        self.areaTrashDic.updateValue(cnt! + 1, forKey: info.area)
                        
                    } else {
                        self.areaTrashDic.updateValue(1, forKey: info.area)
                    }
                })
                self.areaTrashDic.forEach { (key: String, value: Int) in
                    areaArr.append(key)
                    valueArr.append(value)
                }
                
                self.settingChart(areas: areaArr, data: valueArr, chart: self.trashChart, labelStr: "쓰레기량")
            }.observeOn(MainScheduler.instance).subscribe().disposed(by: disposeBag)
        
        NetworkService.shared.getTrashCans()
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .map { data in
                var areaArr: [String] = []
                var valueArr: [Int] = []
                data.trashCans?.forEach({ info in
                    if self.areaTrashCanDic[info.area] != nil {
                        let cnt = self.areaTrashCanDic[info.area]
                        self.areaTrashCanDic.updateValue(cnt! + 1, forKey: info.area)
                        
                    } else {
                        self.areaTrashCanDic.updateValue(1, forKey: info.area)
                    }
                })
                self.areaTrashCanDic.forEach { (key: String, value: Int) in
                    areaArr.append(key)
                    valueArr.append(value)
                }
                
                self.settingChart(areas: areaArr, data: valueArr, chart: self.trashCanChart, labelStr: "쓰레기통 갯수")
            }.observeOn(MainScheduler.instance).subscribe().disposed(by: disposeBag)
    }
}

extension ChartViewController {
    func stopAnimationg() {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
    }
    
    func startAnimation() {
        indicatorView.isHidden = false
        indicatorView.startAnimating()
    }
    
    func settingChart(areas: [String], data: [Int], chart: BarChartView, labelStr: String) {
        chart.rightAxis.enabled = false
        chart.xAxis.labelPosition = .bottom
        chart.doubleTapToZoomEnabled = true
        chart.pinchZoomEnabled = true
        chart.xAxis.setLabelCount(areas.count, force: false)
        var a = areas
        a.insert("", at: 0)
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: a)
        for i in 0..<data.count {
            let dataEntry = BarChartDataEntry(x: Double(i + 1), y: Double(data[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: labelStr)
        chartDataSet.highlightEnabled = false
        chartDataSet.colors = [.customRed]
        let chartData = BarChartData(dataSet: chartDataSet)
        chart.data = chartData
        stopAnimationg()
        return
    }
    
    @objc func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func autoLayout() {
        self.view.addSubviews([backBtn, titleLabel, trashChart, trashCanChart, indicatorView])
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 35).isActive = true
        backBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 23).isActive = true
        backBtn.heightAnchor.constraint(equalToConstant: 31).isActive = true
        backBtn.widthAnchor.constraint(equalToConstant: 17).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: backBtn.trailingAnchor, constant: 15).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 29).isActive = true
        
        trashChart.translatesAutoresizingMaskIntoConstraints = false
        trashChart.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        trashChart.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        trashChart.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        trashChart.heightAnchor.constraint(equalToConstant: self.view.frame.height / 2 - 95).isActive = true
        
        trashCanChart.translatesAutoresizingMaskIntoConstraints = false
        trashCanChart.topAnchor.constraint(equalTo: trashChart.bottomAnchor, constant: 30).isActive = true
        trashCanChart.leadingAnchor.constraint(equalTo: trashChart.leadingAnchor).isActive = true
        trashCanChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        trashCanChart.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
    }
}


//
//  RankViewController.swift
//  TTT-iOS
//
//  Created by 이현욱 on 2021/05/01.
//


import UIKit

import RxSwift

class RankViewController: UIViewController {
    var b : [Rank] = []
    private lazy var infoDic: [String:Int] = [:]
    private let disposeBag = DisposeBag()
    
    lazy var segment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["쓰레기", "쓰레기통"])
        segment.addTarget(self, action: #selector(getData(_:)), for: .valueChanged)
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    lazy var indicatorView = UIActivityIndicatorView()
    
    lazy var rankLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "순위"
        lbl.textColor = .label
        return lbl
    }()
    
    lazy var areaLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "지역"
        lbl.textColor = .label
        return lbl
    }()
    
    lazy var countLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "개수"
        lbl.textColor = .label
        return lbl
    }()
    
    let backBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        btn.tintColor = .customRed
        btn.addTarget(self, action: #selector(popVC), for: .touchDown)
        return btn
    }()
    
    lazy var rankTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "랭킹"
        lbl.textColor = .customRed
        lbl.font = UIFont.systemFont(ofSize: 25)
        return lbl
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RankTableViewCell.self, forCellReuseIdentifier: "RankTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        layout()
        startAnimation()
        NetworkService.shared.getTrashes()
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
            .map {
                if $0.trashes != nil {
                    $0.trashes?.forEach { [weak self] info in
                        if ((self?.infoDic.keys.contains(info.area)) != nil) {
                            let value = self?.infoDic[info.area] ?? 0
                            self?.infoDic.updateValue(value + 1, forKey: info.area)
                        } else {
                            self?.infoDic.updateValue(1, forKey: info.area)
                        }
                    }
                }}.map {
                    let sort = self.infoDic.sorted { value1, value2 -> Bool in
                        value1.value > value2.value
                    }
                    
                    sort.forEach { (key: String, value: Int) in
                        self.b.append(Rank(area: key, count: "\(value)"))
                    }
                }
            .observeOn(MainScheduler.instance)
            .map { self.tableView.reloadData() }
            .map { self.stopAnimationg() }
            .subscribe().disposed(by: disposeBag)
    }
}

extension RankViewController {
    func stopAnimationg() {
        indicatorView.isHidden = true
        indicatorView.stopAnimating()
    }
    
    func startAnimation() {
        indicatorView.isHidden = false
        indicatorView.startAnimating()
    }
    
    func layout() {
        view.addSubviews([rankLbl, areaLbl, countLbl, segment, tableView, backBtn, rankTitleLbl, indicatorView])
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        backBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        rankTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        rankTitleLbl.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor).isActive = true
        rankTitleLbl.leadingAnchor.constraint(equalTo: backBtn.trailingAnchor, constant: 15).isActive = true
        
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 20).isActive = true
        segment.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        rankLbl.translatesAutoresizingMaskIntoConstraints = false
        rankLbl.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 30).isActive = true
        rankLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        
        areaLbl.translatesAutoresizingMaskIntoConstraints = false
        areaLbl.topAnchor.constraint(equalTo: rankLbl.topAnchor).isActive = true
        areaLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        countLbl.translatesAutoresizingMaskIntoConstraints = false
        countLbl.topAnchor.constraint(equalTo: areaLbl.topAnchor).isActive = true
        countLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: areaLbl.bottomAnchor, constant: 30).isActive = true
        tableView.leadingAnchor.constraint(equalTo: rankLbl.leadingAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 30).isActive = true
    }
    
    @objc func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func getData(_ segment: UISegmentedControl) {
        startAnimation()
        if segment.selectedSegmentIndex == 0 { // 쓰레기
            infoDic.removeAll()
            b.removeAll()
            
            NetworkService.shared.getTrashes()
                .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
                .map {
                    if $0.trashes != nil {
                        $0.trashes?.forEach { [weak self] info in
                            if ((self?.infoDic.keys.contains(info.area)) != nil) {
                                let value = self?.infoDic[info.area] ?? 0
                                self?.infoDic.updateValue(value + 1, forKey: info.area)
                            } else {
                                self?.infoDic.updateValue(1, forKey: info.area)
                            }
                        }
                    }}.map {
                        let sort = self.infoDic.sorted { value1, value2 -> Bool in
                            value1.value > value2.value
                        }
                        
                        sort.forEach { (key: String, value: Int) in
                            self.b.append(Rank(area: key, count: "\(value)"))
                        }
                    }
                .observeOn(MainScheduler.instance)
                .map { self.tableView.reloadData() }
                .subscribe().disposed(by: disposeBag)
        } else { // 쓰레기통
            infoDic.removeAll()
            b.removeAll()
            NetworkService.shared.getTrashCans()
                .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
                .map {
                    if $0.trashCans != nil {
                        $0.trashCans?.forEach { [weak self] info in
                            if ((self?.infoDic.keys.contains(info.area)) != nil) {
                                let value = self?.infoDic[info.area] ?? 0
                                self?.infoDic.updateValue(value + 1, forKey: info.area)
                            } else {
                                self?.infoDic.updateValue(1, forKey: info.area)
                            }
                        }
                    }
                }.map {
                    let sort = self.infoDic.sorted { value1, value2 -> Bool in
                        value1.value > value2.value
                    }
                    
                    sort.forEach { (key: String, value: Int) in
                        self.b.append(Rank(area: key, count: "\(value)"))
                    }
                }
                .observeOn(MainScheduler.instance)
                .map { self.tableView.reloadData() }
                .subscribe().disposed(by: disposeBag)
        }
        stopAnimationg()
    }
}

extension RankViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoDic.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RankTableViewCell", for: indexPath) as? RankTableViewCell else { return UITableViewCell() }
        cell.setting(rank: b[indexPath.item], idx: "\(indexPath.item + 1)")
        return cell
    }
}

struct Rank {
    let area: String
    let count: String
}


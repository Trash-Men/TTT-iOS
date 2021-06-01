//
//  RankCell.swift
//  TTT-iOS
//
//  Created by 이현욱 on 2021/05/17.
//

import UIKit

class RankTableViewCell: UITableViewCell {
    let rankLbl = UILabel()
    let areaLbl = UILabel()
    let countLbl = UILabel()
    
    func setting(rank: Rank, idx: String) {
        self.rankLbl.text = idx
        self.areaLbl.text = rank.area
        self.countLbl.text = rank.count
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        attribute()
    }
    
    func attribute() {
        self.contentView.addSubviews([areaLbl, rankLbl, countLbl])
        
        areaLbl.translatesAutoresizingMaskIntoConstraints = false
        rankLbl.translatesAutoresizingMaskIntoConstraints = false
        countLbl.translatesAutoresizingMaskIntoConstraints = false
        rankLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        rankLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        areaLbl.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        areaLbl.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        
        countLbl.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        countLbl.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }
}

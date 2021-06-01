//
//  SelectViewController.swift
//  TTT-iOS
//
//  Created by 이현욱 on 2021/04/12.
//

import UIKit

class SelectViewController: UIViewController {
    
    lazy var backBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = button.frame.height / 2
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(popVC), for: .touchDown)
        return button
    }()
    
    lazy var viewTitle: UILabel = {
        let label = UILabel()
        label.text = "어떤 종류의 사진을 찍으시겠습니까?"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    lazy var trashBtn: UIButton = {
        let button = UIButton()
        button.isSelected = true
        button.layer.cornerRadius = button.frame.height / 2
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "record.circle"), for: .selected)
        button.tintColor = .white
        button.tag = 2
        button.addTarget(self, action: #selector(checkTag(_:)), for: .touchDown)
        return button
    }()
    
    lazy var trashCanBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = button.frame.height / 2
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "record.circle"), for: .selected)
        button.tag = 1
        button.tintColor = .white
        button.addTarget(self, action: #selector(checkTag(_:)), for: .touchDown)
        return button
    }()
    
    lazy var trashLbl: UILabel = {
        let label = UILabel()
        label.text = "쓰레기"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var trashCanLbl: UILabel = {
        let label = UILabel()
        label.text = "쓰레기통"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var nextVCBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customRed
        button.layer.cornerRadius = 40
        button.tintColor = .white
        button.setImage(UIImage(systemName: "arrow.forward"), for: .normal)
        button.addTarget(self, action: #selector(pushView), for: .touchDown)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        
    }
    
}

extension SelectViewController {
    func layout() {
        self.view.backgroundColor = .customPink
        self.view.addSubviews([backBtn, viewTitle, trashBtn, trashCanBtn, trashLbl, trashCanLbl, nextVCBtn])
        
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 23).isActive = true
        backBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 35).isActive = true
        backBtn.heightAnchor.constraint(equalToConstant: 27).isActive = true
        backBtn.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        viewTitle.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 38).isActive = true
        viewTitle.leadingAnchor.constraint(equalTo: backBtn.trailingAnchor, constant: 13).isActive = true
        viewTitle.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        trashBtn.translatesAutoresizingMaskIntoConstraints = false
        trashBtn.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 62).isActive = true
        trashBtn.leadingAnchor.constraint(equalTo: viewTitle.leadingAnchor, constant: 4).isActive = true
        trashBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true
        trashBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        trashCanBtn.translatesAutoresizingMaskIntoConstraints = false
        trashCanBtn.topAnchor.constraint(equalTo: trashBtn.bottomAnchor, constant: 20).isActive = true
        trashCanBtn.leadingAnchor.constraint(equalTo: trashBtn.leadingAnchor).isActive = true
        trashCanBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true
        trashCanBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        trashCanLbl.translatesAutoresizingMaskIntoConstraints = false
        trashCanLbl.centerYAnchor.constraint(equalTo: trashCanBtn.centerYAnchor).isActive = true
        trashCanLbl.leadingAnchor.constraint(equalTo: trashCanBtn.trailingAnchor, constant: 21).isActive = true
        
        trashLbl.translatesAutoresizingMaskIntoConstraints = false
        trashLbl.centerYAnchor.constraint(equalTo: trashBtn.centerYAnchor).isActive = true
        trashLbl.leadingAnchor.constraint(equalTo: trashBtn.trailingAnchor, constant: 21).isActive = true
        
        nextVCBtn.translatesAutoresizingMaskIntoConstraints = false
        nextVCBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        nextVCBtn.heightAnchor.constraint(equalToConstant: 80).isActive = true
        nextVCBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        nextVCBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
    }
    
    @objc func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func pushView() {
        let vc = CameraViewController()
        vc.state = trashCanBtn.isSelected ? .trashCan : .trash
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func checkTag( _ sender: UIButton) {
        if sender.tag == 1 {
            trashCanBtn.isSelected = true
            trashBtn.isSelected = false
        } else if sender.tag == 2 {
            trashBtn.isSelected = true
            trashCanBtn.isSelected = false
        }
    }
}

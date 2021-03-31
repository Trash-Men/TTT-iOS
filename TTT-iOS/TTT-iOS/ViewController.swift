//
//  ViewController.swift
//  TTT-iOS
//
//  Created by 이현욱 on 2021/03/24.
//

import UIKit
import MapKit

let screen = UIScreen.main.bounds

class ViewController: UIViewController {
    var value = true
    
    let menuButton : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "plus"), for: .normal)
        btn.backgroundColor = .red
        btn.layer.cornerRadius = 30
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return btn
    }()
    
    let setCameraBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "camera"), for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 30
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return btn
    }()
    
    let chartBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "chart"), for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 30
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return btn
    }()
    
    let rankBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "rank"), for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 30
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return btn
    }()
    
    let mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeBtn()
        autolayout()
    }
}

extension ViewController {
    @objc func tabMenu(_ sender: Any) {
        if value {
            UIView.animate(withDuration: 0.3) {
                self.menuButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
                self.setCameraBtn.frame = CGRect(x: screen.width - (self.menuButton.bounds.minX + 80), y: self.menuButton.frame.midY - (self.menuButton.bounds.height + 43), width: 60, height: 60)
                self.chartBtn.frame = CGRect(x: screen.width - (self.menuButton.bounds.minX + 80), y: self.menuButton.frame.midY - (self.menuButton.bounds.height * 2 + 56), width: 60, height: 60)
                self.rankBtn.frame = CGRect(x: screen.width - (self.menuButton.bounds.minX + 80), y: self.menuButton.frame.midY - (self.menuButton.bounds.height * 3 + 69), width: 60, height: 60)
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.menuButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
                self.setCameraBtn.frame = CGRect(x: self.menuButton.frame.minX, y: self.menuButton.frame.minY, width: 60, height: 60)
                self.chartBtn.frame =  CGRect(x: self.menuButton.frame.minX, y: self.menuButton.frame.minY, width: 60, height: 60)
                self.rankBtn.frame =  CGRect(x: self.menuButton.frame.minX, y: self.menuButton.frame.minY, width: 60, height: 60)
            }
        }
        value.toggle()
    }
    
    func makeBtn() {
        self.view.addSubviews([mapView, rankBtn, chartBtn,setCameraBtn, menuButton])
        
        menuButton.addTarget(self, action: #selector(tabMenu(_:)), for: .touchDown)
        setCameraBtn.addTarget(self, action: #selector(setCamera), for: .touchDown)
        chartBtn.addTarget(self, action: #selector(chart), for: .touchDown)
        rankBtn.addTarget(self, action: #selector(rank), for: .touchDown)
    }
    
    func autolayout() {
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        menuButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.setCameraBtn.translatesAutoresizingMaskIntoConstraints = false
        setCameraBtn.bottomAnchor.constraint(equalTo: menuButton.bottomAnchor).isActive = true
        setCameraBtn.trailingAnchor.constraint(equalTo: menuButton.trailingAnchor).isActive = true
        setCameraBtn.widthAnchor.constraint(equalTo:  menuButton.widthAnchor).isActive = true
        setCameraBtn.heightAnchor.constraint(equalTo:  menuButton.heightAnchor).isActive = true
        
        self.chartBtn.translatesAutoresizingMaskIntoConstraints = false
        chartBtn.bottomAnchor.constraint(equalTo: setCameraBtn.bottomAnchor).isActive = true
        chartBtn.trailingAnchor.constraint(equalTo: menuButton.trailingAnchor).isActive = true
        chartBtn.widthAnchor.constraint(equalTo:  menuButton.widthAnchor).isActive = true
        chartBtn.heightAnchor.constraint(equalTo:  menuButton.heightAnchor).isActive = true
        
        self.rankBtn.translatesAutoresizingMaskIntoConstraints = false
        rankBtn.bottomAnchor.constraint(equalTo: chartBtn.bottomAnchor).isActive = true
        rankBtn.trailingAnchor.constraint(equalTo: menuButton.trailingAnchor).isActive = true
        rankBtn.widthAnchor.constraint(equalTo:  menuButton.widthAnchor).isActive = true
        rankBtn.heightAnchor.constraint(equalTo:  menuButton.heightAnchor).isActive = true
    }
    
    @objc func setCamera() {
        let vc = storyboard?.instantiateViewController(identifier: "CameraViewController") as! CameraViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func chart() {
        let vc = storyboard?.instantiateViewController(identifier: "ChartViewController") as! ChartViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func rank() {
        let vc = storyboard?.instantiateViewController(identifier: "RankViewController") as! RankViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}

//
//  AnimationViewController.swift
//  TTT-iOS
//
//  Created by 이현욱 on 2021/04/30.
//

import UIKit

import CoreLocation
import RxSwift

struct StuffInfo {
    let type: TrashType
    let path: String
    let latitude: Double
    let longitude: Double
}

class AnimationViewController: UIViewController {
    var model: StuffInfo!
    private let disposeBag = DisposeBag()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let goToMainBtn: UIButton = {
        let but = UIButton()
        but.setTitle("메인으로 가기", for: .normal)
        but.setTitleColor(.customPink, for: .normal)
        but.addTarget(self, action: #selector(goToMain), for: .touchDown)
        return but
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getCityName()
        attribute()
    }
}

extension AnimationViewController {
    @objc func goToMain() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func a(area: String) {
        if model.type == .trash {
            NetworkService.shared.postInfo(photoUrl: model.path,
                                           latitude: model.latitude,
                                           longitude: model.longitude,
                                           area: area)
                .map {
                    if $0.status == 201 {
                        self.imageView.image = UIImage(named: "성공버전")
                    } else {
                        self.imageView.image = UIImage(named: "실패버전")
                    }
                }.subscribe().disposed(by: disposeBag)
        } else {
            NetworkService.shared.postCanInfo(photoUrl: model.path,
                                              latitude: model.latitude,
                                              longitude: model.longitude,
                                              area: area)
                .map {
                    if $0.status == 201 {
                        self.imageView.image = UIImage(named: "성공버전")
                    } else {
                        self.imageView.image = UIImage(named: "실패버전")
                    }
                }.subscribe().disposed(by: disposeBag)
        }
    }
    
    func getCityName() {
        let findLocation = CLLocation(latitude: model.latitude, longitude: model.longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr") //원하는 언어의 나라 코드를 넣어주시면 됩니다.
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale) {(placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                return self.a(area: address.first?.administrativeArea ?? "")
            }
        }
    }
    
    func attribute() {
        view.addSubviews([imageView, goToMainBtn])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        goToMainBtn.translatesAutoresizingMaskIntoConstraints = false
        goToMainBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        goToMainBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        goToMainBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
    }
}

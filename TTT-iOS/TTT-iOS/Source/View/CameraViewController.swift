//
//  CameraViewController.swift
//  TTT-iOS
//
//  Created by 이현욱 on 2021/03/29.
//

import UIKit

import CoreLocation
import RxSwift
import Photos

class CameraViewController: UIViewController {
    let picker = UIImagePickerController()
    let locationManager = CLLocationManager()
    
    var state: TrashType!
    private let disposeBag = DisposeBag()
    
    lazy var backBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(backVC), for: .touchDown)
        return btn
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var sendBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("이미지 전송하기", for: .normal)
        btn.backgroundColor = .customRed
        btn.addTarget(self, action: #selector(sendPicture), for: .touchDown)
        return btn
    }()
    
    lazy var takePictureBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "camera"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(takePicture), for: .touchDown)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        attribute()
        picker.delegate = self
        picker.sourceType = .camera
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            let alert = UIAlertController(title: "권한설정이 되어있지 않습니다.", message: "설정에 들어가 권한을 승인해주세요.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { (_) in
                if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
                }
            }))
            self.present(alert, animated: false, completion: nil)
        }
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:  nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion:  nil)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        imageView.image = image
    }
}

extension CameraViewController {
    @objc func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func takePicture() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        
        case .authorized:
            present(picker, animated: true, completion: nil)
        case .notDetermined:
            present(picker, animated: true, completion: nil)
        default:
            let alert = UIAlertController(title: "권한설정이 되어있지 않습니다.", message: "설정에 들어가 권한을 승인해주세요.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { (_) in
                if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
                }
            }))
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    @objc func sendPicture() {
        if imageView.image != nil {
            NetworkService.shared.postImage(with: imageView.image!, type: state)
                .map { [weak self] model in
                    if model.photoPath != nil {
                        let vc = AnimationViewController()
                        var currentLoc: CLLocation!
                        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                            CLLocationManager.authorizationStatus() == .authorizedAlways) {
                            currentLoc = self?.locationManager.location
                            vc.model = StuffInfo(type: self!.state,
                                                 path: model.photoPath ?? "",
                                                 latitude: currentLoc.coordinate.latitude,
                                                 longitude: currentLoc.coordinate.longitude)
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }.subscribe().disposed(by: disposeBag)
        }
    }
    
    func attribute() {
        self.view.backgroundColor = .customPink
        sendBtn.layer.cornerRadius = sendBtn.frame.height / 2
        self.view.addSubviews([imageView, sendBtn, takePictureBtn, backBtn])
        
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        sendBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        sendBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        imageView.topAnchor.constraint(equalTo: takePictureBtn.bottomAnchor, constant: 10).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        imageView.bottomAnchor.constraint(equalTo: sendBtn.topAnchor, constant: -50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: screen.width - 40).isActive = true
        
        takePictureBtn.translatesAutoresizingMaskIntoConstraints = false
        takePictureBtn.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor).isActive = true
        takePictureBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        takePictureBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        takePictureBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        backBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        backBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
}


enum TrashType: String {
    case trash = "trash"
    case trashCan = "trashCan"
}

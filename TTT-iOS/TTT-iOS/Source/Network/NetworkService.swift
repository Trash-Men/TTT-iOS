//
//  NetworkService.swift
//  TTT-iOS
//
//  Created by 이현욱 on 2021/04/28.
//

import Foundation

import Moya
import RxSwift

class NetworkService {
    static let shared = NetworkService()
    
    func login() -> Maybe<Void> {
        provider.rx.request(.login(id: "admin", pw: "admin1234"))
            .map(LoginModel.self)
            .map { UserDefaults.standard.setValue($0.accessToken, forKey: "token") }
            .asMaybe()
    }
    
    func getTrashes() -> Maybe<GetTrashModel> {
        provider.rx.request(.getTrashes)
            .map(GetTrashModel.self)
            .asMaybe()
    }
    
    func getTrashCans() -> Maybe<GetTrashCanModel> {
        provider.rx.request(.getTrashCans)
            .map(GetTrashCanModel.self)
            .asMaybe()
    }
    
    func postImage(with image: UIImage, type: TrashType) -> Maybe<UploadImage> {
        provider.rx.request(.uploadPhoto(photo: image, type: type.rawValue))
            .map(UploadImage.self)
            .asMaybe()
    }

    func postInfo(photoUrl: String, latitude: Double, longitude: Double, area: String) -> Maybe<PostInfoModel> {
        provider.rx.request(.postTrash(photoUrl: photoUrl, latitude: latitude, longitude: longitude, area: area))
            .map {
                if $0.response?.statusCode == 201 {
                    return PostInfoModel(status: 201, code: "", message: "")
                } else {
                     return try $0.map(PostInfoModel.self)
                }
            }
            .asMaybe()
    }
    
    func postCanInfo(photoUrl: String, latitude: Double, longitude: Double, area: String) -> Maybe<PostInfoModel> {
        provider.rx.request(.postTrashCan(photoUrl: photoUrl, latitude: latitude, longitude: longitude, area: area))
            .map {
                if $0.response?.statusCode == 201 {
                    return PostInfoModel(status: 201, code: "", message: "")
                } else {
                     return try $0.map(PostInfoModel.self)
                }
            }
            .asMaybe()
    }
}



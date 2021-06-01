//
//  TTTAPI.swift
//  TTT-iOS
//
//  Created by 이현욱 on 2021/04/07.
//

import Foundation

import Moya

let imageURL = "https://ttt-image.s3.ap-northeast-2.amazonaws.com/"
let provider = MoyaProvider<TTTAPI>()

enum TTTAPI {
    case login(id: String, pw: String)
    case uploadPhoto(photo: UIImage, type: String)
    case deletePhoto(photo: String)
    case getTrashes
    case getTrashCans
    case postTrash(photoUrl: String, latitude: Double, longitude: Double, area: String)
    case postTrashCan(photoUrl: String, latitude: Double, longitude: Double, area: String)
}

extension TTTAPI: TargetType {
    var method: Moya.Method {
        switch self {
        case .login,
             .uploadPhoto,
             .postTrash,
             .postTrashCan:
            return .post
            
        case .deletePhoto:
            return .delete
            
        case .getTrashes,
             .getTrashCans:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getTrashCans:
            return "{\"trashCans\": [{\"photo_url\": \"/sadf/asf.pngas\",\"latitude\": 0.1,\"longitude\": 0.2,\"area\": \"전주\",\"address\": \"서울시\",\"created_at\": \"2021-03-31T05:22:18.741735Z\"}]}".data(using: .utf8)!
        default:
            return Data()
        }
    }
    
    var token: String {
        return UserDefaults.standard.value(forKey: "token") as! String
    }
    
    var task: Task {
        switch self {
        case .login(let id, let pw):
            return .requestParameters(parameters: ["id":id, "password":pw],
                                      encoding: JSONEncoding.default)
            
        case .uploadPhoto(let data, let type):
            let formData = MultipartFormData(provider: .data(data.jpegData(compressionQuality: 0)!), name: "photo", fileName: "photo.jpg", mimeType: "image/jpg")
            let text = MultipartFormData(provider: .data(type.data(using: .utf8)!), name: "type")
            return .uploadMultipart([formData,text])
        case .postTrash(let photoUrl, let latitude, let longitude, let area),
             .postTrashCan(let photoUrl, let latitude, let longitude, let area):
            return .requestParameters(parameters: [
                "photoUrl": photoUrl,
                "latitude": latitude,
                "longitude": longitude,
                "area": area
            ], encoding: JSONEncoding.default)
            
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .deletePhoto,
             .getTrashes,
             .postTrash,
             .postTrashCan,
             .getTrashCans:
            return [
                "Authorization": "Bearer \(token)"
            ]
            
        case .uploadPhoto:
            return [
                "Content-type": "multipart/form-data",
                "Authorization": "Bearer \(token)"
            ]
        default:
            return nil
        }
    }
    
    var baseURL: URL {
        return URL(string: "http://dsm-rank.site")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/user/login"
        case .deletePhoto(let photo):
            return "/photo?photoPath=\(photo)"
        case .getTrashCans:
            return "/trash-can/all"
        case .getTrashes:
            return "/trash/all"
        case .postTrash:
            return "/trash"
        case .postTrashCan:
            return "/trash-can"
        case .uploadPhoto:
            return "/photo"
        }
    }
}



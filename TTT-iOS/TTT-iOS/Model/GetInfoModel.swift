//
//  GetInfoModel.swift
//  TTT-iOS
//
//  Created by 이현욱 on 2021/04/20.
//

import Foundation

struct GetTrashModel: Codable {
    let trashes: [TrashInfo]?
    let status: Int?
    let code: String?
    let message: String?
}

struct TrashInfo: Codable {
    let photo_url: String
    let latitude: Double
    let longitude: Double
    let area: String
    let created_at: String
}

struct GetTrashCanModel: Codable {
    let trashCans: [TrashInfo]?
    let status: Int?
    let code: String?
    let message: String?
}

struct PostInfoModel: Codable {
    let status: Int?
    let code: String?
    let message: String?
}

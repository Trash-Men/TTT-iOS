//
//  UploadImage.swift
//  TTT-iOS
//
//  Created by 이현욱 on 2021/04/16.
//

import Foundation

struct UploadImage: Codable {
    let photoPath: String?
    let status: Int?
    let code: String?
    let message: String?
}

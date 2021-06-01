//
//  Dictionary.swift
//  TTT-iOS
//
//  Created by 이현욱 on 2021/05/17.
//

import Foundation

extension Dictionary {
    subscript(i: Int) -> (key: Key, value: Value) {
        return self[index(startIndex, offsetBy: i)]
    }
}

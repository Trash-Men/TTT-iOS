//
//  UIColor.swift
//  TTT-iOS
//
//  Created by 이현욱 on 2021/05/01.
//

import UIKit

extension UIColor {
    static var customRed: UIColor {
        return rgb(255, 75, 64, 1)
    }
    
    static var customPink: UIColor {
        return rgb(255, 107, 106, 1)
    }
    
    static func rgb( _ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat) -> UIColor {
        return .init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
    }
}

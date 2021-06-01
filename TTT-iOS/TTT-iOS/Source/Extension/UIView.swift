//
//  UIView.swift
//  TTT-iOS
//
//  Created by 이현욱 on 2021/05/01.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}

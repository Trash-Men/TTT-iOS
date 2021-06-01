//
//  TrashPin.swift
//  TTT-iOS
//
//  Created by 이현욱 on 2021/04/27.
//

import UIKit
import MapKit

protocol Pin: MKAnnotation {
    var image: UIImage? { get }
}

class TrashPin: NSObject, MKAnnotation, Pin {
    
    var title: String? = NSLocalizedString("쓰레기", comment: "")
    
    var subtitle: String? = NSLocalizedString("쓰레기의 위치입니다.", comment: "")
    
    var image: UIImage?
    var coordinate: CLLocationCoordinate2D

    override init() {
        self.coordinate = CLLocationCoordinate2D()
        self.image = nil
    }
}

class ImageAnnotationView: MKAnnotationView {
    private var imageView: UIImageView!

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.addSubview(self.imageView)
        
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.layer.cornerRadius = 5.0
        self.imageView.layer.masksToBounds = true
    }

    override var image: UIImage? {
        get {
            return self.imageView.image
        }

        set {
            self.imageView.image = newValue
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TrashCanPin: NSObject, MKAnnotation, Pin {
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    
    var title: String? = NSLocalizedString("쓰레기통", comment: "")
    
    var subtitle: String? = NSLocalizedString("쓰레기통의 위치입니다.", comment: "")

    override init() {
        self.coordinate = CLLocationCoordinate2D()
        self.image = nil
    }
}

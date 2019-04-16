//
//  TakePhoto.swift
//  Ice Cream Tracker
//
//  Created by Christopher Hovey on 4/15/19.
//  Copyright © 2019 Chris Hovey. All rights reserved.
//

import UIKit

class TakePhotoBtn: UIButton {

    override func awakeFromNib() {
        clipsToBounds = true
        layer.cornerRadius = self.frame.width/2
        alpha = 0.5
        backgroundColor = UIColor.white
        titleLabel?.text = ""
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        alpha = 1
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        alpha = 0.5
//    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        alpha = 0.5
//    }
    
}

class TakePhotoOuterView: UIView{
    override func awakeFromNib() {
        clipsToBounds = true
        layer.cornerRadius = self.frame.width/2
        alpha = 0.9
        layer.borderWidth = 3
        layer.borderColor = UIColor.white.cgColor
        backgroundColor = UIColor.clear
    }
}

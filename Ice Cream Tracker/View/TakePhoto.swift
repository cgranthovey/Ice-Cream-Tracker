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
        
        addTarget(self, action: #selector(buttonSolid), for: .touchDown)
        addTarget(self, action: #selector(buttonAlpha), for: .touchDragExit)
        addTarget(self, action: #selector(animate), for: .touchUpInside)
        print("button awake from nib")
    }
    
    @objc func buttonSolid(){
        alpha = 1
    }
    
    @objc func buttonAlpha(){
        alpha = 0.5
    }
    
    @objc func animate(){
        alpha = 0.5
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (success) in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.transform = .identity
            }, completion: { (success) in
            })
        }
        
    }
    
    
    
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

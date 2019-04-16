//
//  PhotoVC.swift
//  Ice Cream Tracker
//
//  Created by Christopher Hovey on 4/15/19.
//  Copyright © 2019 Chris Hovey. All rights reserved.
//

import UIKit

class PhotoVC: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgView.image = image
    }
    
    
    
    
    //MARK: - IBActions
    
    @IBAction func approveImgBtnPress(_ sender: AnyObject){
        
    }
    
    @IBAction func retakeImgBtnPress(_ sender: AnyObject){
        
    }
    
    @IBAction func exitBtnPress(_ sender: AnyObject){
        
    }
    

}

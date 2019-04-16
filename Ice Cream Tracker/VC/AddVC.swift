//
//  AddVC.swift
//  Ice Cream Tracker
//
//  Created by Christopher Hovey on 4/15/19.
//  Copyright © 2019 Chris Hovey. All rights reserved.
//

import UIKit

class AddVC: UIViewController {
    
    @IBOutlet weak var tfFlavor: UITextField!
    @IBOutlet weak var tfLocation: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var img: UIImage?
    var stars = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = img
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dropKB))
//        self.view.addGestureRecognizer(tap)
        
    }

    @IBAction func saveBtnPress(_ sender: AnyObject){
        print("save btn press")
    }
    
//    @IBAction func cancelBtnPress(_ sender: AnyObject){
//        
//    }
    
    @objc func dropKB(){
        self.view.endEditing(true)
    }
    
    
}


extension AddVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? StarCell{
            cell.imgView.image = UIImage(named: "starEmpty")
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stars
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthOfCell = collectionView.frame.width/CGFloat(stars)
        return CGSize(width: widthOfCell, height: widthOfCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didselect1")
        for i in 0..<10{
            print("didselect2")
            if i <= indexPath.row, let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? StarCell{
                print("didselect3")
                cell.imgView.image = UIImage(named: "starFilled")
            } else if let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? StarCell{
                print("didselect4")
                cell.imgView.image = UIImage(named: "starEmpty")
            }
        }
    }
    
    
}

extension AddVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

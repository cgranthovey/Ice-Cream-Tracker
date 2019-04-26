//
//  AddVC.swift
//  Ice Cream Tracker
//
//  Created by Christopher Hovey on 4/15/19.
//  Copyright © 2019 Chris Hovey. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class AddVC: UIViewController {
    
    @IBOutlet weak var tfFlavor: UITextField!
    @IBOutlet weak var tfLocation: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSave: UIButton!
    
    var img: UIImage?
    var stars = 5
    var starsSelectedCount: Double?
    var urlPath: String?
    var editingIceCream: IceCream?
    var hasLocations = false
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = img
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setUpUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dropKB))
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
        
        tfLocation.delegate = self
    }
    
    //MARK: - IBActions
    
    @IBAction func saveBtnPress(_ sender: AnyObject){
        print("save btn press")
        if let iceCream = editingIceCream{
            do{
                let realm = try Realm()
                try realm.write {
                    iceCream.imagePath = urlPath
                    if let flavor = tfFlavor.text{
                        iceCream.flavor = flavor
                    }
                    if let starsSelectedCount = starsSelectedCount{
                        iceCream.rating = starsSelectedCount
                    }
                }
            } catch{
                print("error udpating realm", error.localizedDescription)
            }
        } else{
            let iceCream = IceCream()
            if let flavor = tfFlavor.text{
                iceCream.flavor = flavor
            }
            if let starsSelectedCount = starsSelectedCount{
                iceCream.rating = starsSelectedCount
            }
            iceCream.date = Date()
            iceCream.imagePath = urlPath
            
            let location = Location()
            if let locationText = tfLocation.text{
                location.name = locationText
                location.iceCreams.append(iceCream)
                do{
                    let realm = try Realm()
                    try realm.write {
                        realm.add(location)
                    }
                } catch{
                    print("error saving data", error.localizedDescription)
                }
            }
            
            
            
            do{
                let realm = try Realm()
                try realm.write {
                    realm.add(iceCream)
                }
            } catch{
                print("error saving data", error.localizedDescription)
            }
        }
        
        
        if editingIceCream != nil{
            self.navigationController?.popViewController(animated: true)
        } else{
            dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Functions
    
    func setUpUI(){
        //        collectionView.canCancelContentTouches = true
        if let iceCream = editingIceCream{
            tfFlavor.text = iceCream.flavor
            starsSelectedCount = iceCream.rating
            urlPath = iceCream.imagePath
            if let path = iceCream.imagePath{
                if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
                    let imgURL = url.appendingPathComponent(path)
                    imgView.image = UIImage(contentsOfFile: imgURL.path)
                }
            }
        }
        checkIfLocations()
    }
    
    func checkIfLocations(){
        let locations = realm.objects(Location.self)
        if locations.count > 0 {
            hasLocations = true
        }
    }
    
    @objc func dropKB(){
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollView.contentInset = insets
            scrollView.scrollIndicatorInsets = insets
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    
}


extension AddVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? StarCell{
            cell.imgView.image = UIImage(named: "starEmpty")
            
            if let starsSelectedCount = starsSelectedCount, starsSelectedCount > 0.0{
                if starsSelectedCount > Double(indexPath.row){
                    cell.imgView.image = UIImage(named: "starFilled")
                }
            }
            
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
        starsSelectedCount = Double(indexPath.row + 1)
        for i in 0..<stars{
            if i <= indexPath.row, let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? StarCell{
                cell.imgView.image = UIImage(named: "starFilled")
            } else if let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? StarCell{
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

extension AddVC: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: collectionView) == true || touch.view?.isDescendant(of: btnSave) == true{
            return false
        }
        return true
    }
    
    
}


extension AddVC: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfLocation && hasLocations{
//            performSegue(withIdentifier: "PopupVC", sender: nil)
            print("show tfLocation1")
            if let vc = storyboard?.instantiateViewController(withIdentifier: "PopupVC") as? PopupVC{
                vc.modalPresentationStyle = .popover
                vc.delegate = self
                if let popover = vc.popoverPresentationController{
                    popover.sourceView = tfLocation
                    popover.sourceRect = tfLocation.bounds
                    vc.preferredContentSize = CGSize(width: 250, height: 350)
                    popover.delegate = self
                    self.present(vc, animated: true, completion: nil)
                }
                
            }
            return false
        }
        
        return true
    }
}

extension AddVC: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension AddVC: PopupVCDelegate{
    func locationPress(location: Location){
        tfLocation.text = location.name
    }
    func addNewLocation(){
        tfLocation.becomeFirstResponder()
        print("add new lcoations")
    }
}

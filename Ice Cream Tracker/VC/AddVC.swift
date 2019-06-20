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
import AVFoundation

class AddVC: UIViewController {
    
    @IBOutlet weak var tfFlavor: UITextField!
    @IBOutlet weak var tfLocation: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnAddImg: UIButton!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var heightStars: NSLayoutConstraint!
    
    
//    var img: UIImage?
    var stars = 5
    var starsSelectedCount: Double?
    var urlPath: String?
    var editingIceCream: IceCream?
    var hasLocations = false
    let realm = try! Realm()
    var shouldAddNewLocation = false
    var addNewLocationPress = false
    var selectedLocation: Location?
    var locationsCount = 0
    var imgToSave: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imgView.image = imgToSave
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setUpUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dropKB))
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
        
        tfLocation.delegate = self
        self.navigationController?.title = "Edit Details"
    }
    
    //MARK: - IBActions
    
    @IBAction func saveBtnPress(_ sender: AnyObject){
        print("save btn press")
        
        if let img = imgToSave{
            if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
                if let imgData = img.jpegData(compressionQuality: 1){
                    let urlDatePath = String(Date().timeIntervalSince1970)
                    let urlToSave = url.appendingPathComponent(urlDatePath)
                    do{
                        try imgData.write(to: urlToSave)
                        urlPath = urlDatePath
                    } catch{
                        print("save btn error - ", error.localizedDescription)
                    }
                }
            }
        }
        
        if let iceCream = editingIceCream{
            print("save btn press2")
            do{
                let realm = try Realm()
                try realm.write {
                    print("save btn press")
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
            addLocation(with: iceCream)
            

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
            
            addLocation(with: iceCream)
            
            do{
                let realm = try Realm()
                try realm.write {
                    realm.add(iceCream)
                }
            } catch{
                print("error saving data", error.localizedDescription)
            }
        }
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        if editingIceCream != nil{
            self.navigationController?.popViewController(animated: true)
        } else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    func showImgPicker(sourceType: UIImagePickerController.SourceType){
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.sourceType = sourceType
        present(imgPicker, animated: true, completion: nil)
    }
    
    @IBAction func editBtnPress(_ sender: AnyObject){
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.showImgPicker(sourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.showImgPicker(sourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        present(alert, animated: true, completion: nil)

    }
    
    //MARK: - Functions
    
    func setUpUI(){
        //        collectionView.canCancelContentTouches = true
        
        imgView.alpha = 0.54
        
        
        if let iceCream = editingIceCream{
            viewTop.isHidden = true
            navigationItem.title = "Edit"
            if let firstLocation = iceCream.location.first{
                tfLocation.text = firstLocation.name
            }
            tfFlavor.text = iceCream.flavor
            starsSelectedCount = iceCream.rating
            urlPath = iceCream.imagePath
            if let path = iceCream.imagePath{
                if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
                    let imgURL = url.appendingPathComponent(path)
                    imgView.image = UIImage(contentsOfFile: imgURL.path)
                    imgView.alpha = 1
                    btnAddImg.titleLabel?.text = "Edit"
                }
            }
        } else{
            navigationItem.title = "Add"
        }
        checkIfLocations()
    }
    
    func addLocation(with iceCream: IceCream){
        print("addLocation1")
        if let location = selectedLocation{
            print("addLocation2")
            do{
                try realm.write {
                    if let location = iceCream.location.first{
                        if let index = location.iceCreams.index(of: iceCream){
                            location.iceCreams.remove(at: index)
                        }
                    }
                    
                    if !location.iceCreams.contains(iceCream){
                        print("addLocation2.2")
                        location.iceCreams.append(iceCream)
                    }
                }
            } catch{
            }

        } else if let locationText = tfLocation.text, locationText != "", addNewLocationPress == true || locationsCount == 0 {
            print("addLocation3")
            let location = Location()
            location.name = locationText
            location.iceCreams.append(iceCream)
            do{
                try realm.write {
                    if let location = iceCream.location.first{
                        if let index = location.iceCreams.index(of: iceCream){
                            location.iceCreams.remove(at: index)
                        }
                    }
                    let realm = try Realm()
                    print("addLocation3.3")
                    realm.add(location)
                }
            } catch{
                
            }
        }
    }
    
    func checkIfLocations(){
        let locations = realm.objects(Location.self)
        if locations.count > 0 {
            locationsCount = locations.count
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
        heightStars.constant = widthOfCell
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
        if textField == tfLocation && hasLocations && shouldAddNewLocation == false{
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
        shouldAddNewLocation = false
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
        selectedLocation = location
        addNewLocationPress = false
    }
    func addNewLocation(){
        selectedLocation = nil
        shouldAddNewLocation = true
        tfLocation.text = ""
        addNewLocationPress = true
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
            self.tfLocation.becomeFirstResponder()
        }
        
        print("add new location")
    }
}

extension AddVC: CameraVCDelegate{
    func getImage(img: UIImage){
        print("get image called")
        imgView.image = img
        imgToSave = img
    }
}

extension AddVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let img = info[.originalImage] as? UIImage else{
            print("no image")
            return
        }
        imgView.image = img
        btnAddImg.titleLabel?.text = "Edit"
        imgToSave = img
        imgView.alpha = 1
        print("did finish")
        dismiss(animated: true, completion: nil)
    }
}

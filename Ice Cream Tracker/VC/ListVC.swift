
//
//  ListVC.swift
//  Ice Cream Tracker
//
//  Created by Christopher Hovey on 4/13/19.
//  Copyright © 2019 Chris Hovey. All rights reserved.
//

import UIKit
import RealmSwift

class ListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var iceCreams: Results<IceCream>?
    let realm = try! Realm()

    override func viewDidLoad() {
        print("listVC")
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 130
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    //MARK: -IBActions
    
    
    //MARK: -Functions
    
    func getData(){
        
        do{
            let realm2 = try Realm()
            iceCreams = realm2.objects(IceCream.self)
            iceCreams = iceCreams?.sorted(byKeyPath: "date", ascending: false)
            tableView.reloadData()
            if iceCreams?.count == 0{
                addFirstItem()
            } else{
                tableView.backgroundView = nil
            }
        } catch{
            print("error getting realm", error.localizedDescription)
        }
    }
    
    func addFirstItem(){
        print("enter here", tableView.frame.width)
        print("enter here2", UIScreen.main.bounds.width)
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: tableView.frame.height))
        let addBtn = UIButton(type: .system)
        addBtn.frame = CGRect(x: 0, y: bgView.frame.height / 4, width: bgView.frame.width, height: 120)
        addBtn.setTitle("Add First Item", for: .normal)
        addBtn.setTitleColor(UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1), for: .normal)
        addBtn.titleLabel?.font = UIFont(name: "Menlo", size: 24)
        addBtn.addTarget(self, action: #selector(addItemPress), for: .touchUpInside)
        bgView.addSubview(addBtn)
        tableView.backgroundView = bgView
        
        addBtn.transform = CGAffineTransform(translationX: 0, y: 20)
        addBtn.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseOut, animations: {
            print("transform")
            addBtn.transform = .identity
            addBtn.alpha = 1
        }, completion: nil)
    }
    
    @objc func addItemPress(){
        if let addVC = storyboard?.instantiateViewController(withIdentifier: "AddVC") as? AddVC{
            self.navigationController?.pushViewController(addVC, animated: true)
        }
    }
    
    func deleteIceCream(indexPath: IndexPath){
        
        do{
            let iceCream = iceCreams![indexPath.row]
            try realm.write {
                realm.delete(iceCream)
                print("trying to delete", indexPath)
                tableView.deleteRows(at: [indexPath], with: .bottom)
                print("trying to delete2")
            }
        } catch{
            print("error deleting item", error)
        }
    }
    

}

//MARK: - TableViewDelegate/DataSource

extension ListVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? IceCreamCell, let iceCreams = iceCreams{
            print("configure that")
            cell.configure(item: iceCreams[indexPath.row])
            let lightBG = UIView()
            lightBG.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
            cell.selectedBackgroundView = lightBG
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("configure count", iceCreams?.count)
        return iceCreams?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if iceCreams != nil{
                deleteIceCream(indexPath: indexPath)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
//        return 130
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddVC") as? AddVC{
            vc.editingIceCream = iceCreams?[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

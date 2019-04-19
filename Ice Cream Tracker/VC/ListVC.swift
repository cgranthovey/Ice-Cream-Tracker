
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
        } catch{
            print("error getting realm", error.localizedDescription)
        }
    }
    
    func deleteIceCream(iceCream: IceCream){
        do{
            try realm.write {
                realm.delete(iceCream)
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
                tableView.deleteRows(at: [indexPath], with: .bottom)
                deleteIceCream(iceCream: iceCreams![indexPath.row])
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
    
}

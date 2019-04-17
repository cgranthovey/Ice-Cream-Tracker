
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
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
            tableView.reloadData()
        } catch{
            print("error getting realm", error.localizedDescription)
        }
        
//        iceCreams = realm.objects(IceCream.self)
//        tableView.reloadData()
        print("get iceCreams", iceCreams?.count)

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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}

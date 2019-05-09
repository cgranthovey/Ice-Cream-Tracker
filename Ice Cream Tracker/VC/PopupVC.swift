//
//  PopupVC.swift
//  Ice Cream Tracker
//
//  Created by Christopher Hovey on 4/25/19.
//  Copyright © 2019 Chris Hovey. All rights reserved.
//

import UIKit
import RealmSwift

protocol PopupVCDelegate{
    func locationPress(location: Location)
    func addNewLocation()
}

class PopupVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var locations: Results<Location>?
    var delegate: PopupVCDelegate?
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getData()
    }
    
    @IBAction func newPress(_ sender: AnyObject){
        if let delegate = delegate{
            delegate.addNewLocation()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func getData(){
        locations = realm.objects(Location.self)
        locations = locations?.sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }

}

extension PopupVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let locations = locations{
            do{
                try realm.write {
                    realm.delete(locations[indexPath.row])
                }
                tableView.deleteRows(at: [indexPath], with: .bottom)
            } catch{
                print("error deleting", error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate, let locations = locations{
            delegate.locationPress(location: locations[indexPath.row])
            dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? PopUpCell, let locations = locations{
            cell.configureLocations(location: locations[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations?.count ?? 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

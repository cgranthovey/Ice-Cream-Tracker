//
//  IceCream.swift
//  Ice Cream Tracker
//
//  Created by Christopher Hovey on 4/13/19.
//  Copyright © 2019 Chris Hovey. All rights reserved.
//

import Foundation
import RealmSwift

class IceCream: Object{
    @objc dynamic var flavor: String = ""
    @objc dynamic var rating: Double = -1
    var location = LinkingObjects(fromType: Location.self, property: "iceCreams")
    @objc dynamic var date: Date!
    @objc dynamic var imagePath: String?
    
}

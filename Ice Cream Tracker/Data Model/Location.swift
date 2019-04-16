//
//  Location.swift
//  Ice Cream Tracker
//
//  Created by Christopher Hovey on 4/13/19.
//  Copyright © 2019 Chris Hovey. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object{
    @objc dynamic var name: String = ""
    var iceCreams = List<IceCream>()
}

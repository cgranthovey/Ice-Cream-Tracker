//
//  Data.swift
//  Ice Cream Tracker
//
//  Created by Christopher Hovey on 4/9/19.
//  Copyright © 2019 Chris Hovey. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}

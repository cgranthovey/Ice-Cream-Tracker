//
//  PopUpCell.swift
//  Ice Cream Tracker
//
//  Created by Christopher Hovey on 4/25/19.
//  Copyright © 2019 Chris Hovey. All rights reserved.
//

import UIKit

class PopUpCell: UITableViewCell {
    
    @IBOutlet weak var lbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureLocations(location: Location){
        lbl.text = location.name
        let bgView = UIView()
        bgView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        selectedBackgroundView = bgView
    }

}

//
//  IceCreamCell.swift
//  Ice Cream Tracker
//
//  Created by Christopher Hovey on 4/13/19.
//  Copyright © 2019 Chris Hovey. All rights reserved.
//

import UIKit

class IceCreamCell: UITableViewCell {
    
    @IBOutlet weak var lblFlavor: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(item: IceCream){
        lblFlavor.text = item.flavor
        if let location = item.location.first{
            lblLocation.text = location.name
        }
        if item.rating != -1{
            lblRating.text = String(item.rating)
        }
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        lblDate.text = dateFormat.string(from: item.date)
        
        if let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, let path = item.imagePath{
            let imgURL = docURL.appendingPathComponent(path)
            imgView.image = UIImage(contentsOfFile: imgURL.path)
        }
        
        
        
    }


}

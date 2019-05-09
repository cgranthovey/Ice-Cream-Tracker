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
    @IBOutlet weak var viewRating: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(item: IceCream){
        if item.flavor != ""{
            lblFlavor.text = item.flavor
            lblFlavor.isHidden = false
        } else{
            lblFlavor.isHidden = true
        }

        if let location = item.location.first?.name{
            lblLocation.text = location
        }
        
        if let location = item.location.first{
            lblLocation.text = location.name
            lblLocation.isHidden = false
        } else{
            lblLocation.isHidden = true
        }
        if item.rating != -1{
            addRatings(count: Int(item.rating))
//            lblRating.text = String(item.rating)
//            lblRating.isHidden = false
            viewRating.isHidden = false
        } else{
            viewRating.isHidden = true
//            lblRating.isHidden = true
        }
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        lblDate.text = dateFormat.string(from: item.date)
        
        if let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, let path = item.imagePath{
            let imgURL = docURL.appendingPathComponent(path)
            imgView.image = UIImage(contentsOfFile: imgURL.path)
            imgView.isHidden = false
        } else{
            imgView.isHidden = true
        }
    }
    
    func addRatings(count: Int){
        print("check count", count)
        viewRating.subviews.forEach({ $0.removeFromSuperview() })
        for i in 0 ..< count{
            print("check i", i)
            let xValue = i == 0 ? 20 * i : (20 + 3) * i
            print("check xValue", xValue)
            
            let ratingImgView = UIImageView(frame: CGRect(x: xValue, y: 0, width: 20, height: 20))
            ratingImgView.image = UIImage(named: "starSmall")
            viewRating.addSubview(ratingImgView)
        }
    }
}

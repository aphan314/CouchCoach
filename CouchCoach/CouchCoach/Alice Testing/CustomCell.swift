//
//  CustomCell.swift
//  CouchCoach
//
//  Created by Alice Phan on 2/3/21.
//  Copyright © 2021 GetFit. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var isClosedLabel: UILabel!
    @IBOutlet weak var businessImage: UIImageView!
    
    var isClosed: Bool = false {
        didSet {
            if isClosed {
                isClosedLabel.text = "Closed"
            } else {
                isClosedLabel.text = "Open Now"
            }
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
    }

}

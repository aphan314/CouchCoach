//
//  RecCell.swift
//  CouchCoach
//
//  Created by Alice Phan on 3/10/21.
//  Copyright © 2021 GetFit. All rights reserved.
//

import UIKit

class RecCell: UITableViewCell {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var urlTextView: UITextView!
    @IBOutlet weak var scheduleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}

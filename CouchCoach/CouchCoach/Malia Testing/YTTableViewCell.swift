//
//  YTTableViewCell.swift
//  CouchCoach
//
//  Created by Malia German on 2/8/21.
//  Copyright © 2021 GetFit. All rights reserved.
//

import UIKit

class YTTableViewCell: UITableViewCell {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var publishedLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

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
    //@IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var publishedLabel: UILabel!
    // buttons
    @IBOutlet weak var notInterested: UIButton!
    @IBOutlet weak var watchLater: UIButton!
    @IBOutlet weak var watchNow: UIButton!
    // adding
    var cellDelegate: cellDelegate?
    var videoInfo: Video?
    
    @IBAction func notIntPressed(_ sender: UIButton) {
        cellDelegate?.didPressButton(self, butt: sender, value: 1)
    }
    @IBAction func watchLaterPressed(_ sender: UIButton) {
        cellDelegate?.didPressButton(self, butt: sender, value: 2)
    }
    
    @IBAction func watchNowPressed(_ sender: UIButton) {
        cellDelegate?.didPressButton(self, butt: sender, value: 3)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

// button pressed protocol
protocol cellDelegate : class {
    func didPressButton(_ sender: YTTableViewCell, butt: UIButton, value: Int)
}


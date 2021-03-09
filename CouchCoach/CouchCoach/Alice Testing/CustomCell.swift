//
//  CustomCell.swift
//  CouchCoach
//
//  Created by Alice Phan on 2/3/21.
//  Copyright © 2021 GetFit. All rights reserved.
//
import Foundation
import UIKit

class CustomCell: UITableViewCell {

    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var websiteTextView: UITextView!
    @IBOutlet weak var isClosedLabel: UILabel!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    var cDelegate: cDelegate?
    var index: IndexPath?

    var isClosed: Bool = false {
        didSet {
            if isClosed {
                isClosedLabel.text = "Closed"
            } else {
                isClosedLabel.text = "Open Now"
            }
        }
    }

    @IBAction func didClickSave(_ sender: UIButton) {
        cDelegate?.didClickButton(index: (index?.row)!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
    }

}

protocol cDelegate : class {
    func didClickButton(index: Int)

}

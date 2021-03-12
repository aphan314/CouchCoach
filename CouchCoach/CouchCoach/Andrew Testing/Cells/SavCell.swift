//
//  SavCell.swift
//  CouchCoach
//
//  Created by Andrew Pham on 3/12/21.
//  Copyright © 2021 GetFit. All rights reserved.
//

import UIKit

class SavCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var contentLayer: UIView!
    @IBOutlet weak var parentView: UIView!
    
    weak var delegate:
        SavedViewControllerDelegate?
        
    var recommendation: Recommendation?
    
    func configureWith(_ recommendation: Recommendation, delegate: SavedViewControllerDelegate) {
        self.recommendation = recommendation
        self.delegate = delegate
        self.contentLayer.layer.cornerRadius = 10
        nameLabel.text = recommendation.name
        infoLabel.text = recommendation.info
        detailLabel.text = recommendation.detail
        let image_url = recommendation.thumbnail ?? ""
        let attributedString = NSMutableAttributedString(string: "Link to Website")

        websiteButton.isHidden = (recommendation.url ?? "") == ""

        thumbnailImage.loadImage(from: image_url)
    }
    
    @IBAction func visitWebsiteButtonTapped(_ sender: Any) {
        guard let link = recommendation?.url else {
            return
        }
        delegate?.visitWebsite(link)
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
        
//        guard let recommendation = recommendation else {
//            return
//        }
        delegate?.deleteButtonPressed(with: sender)
    }
    
}


protocol SavedViewControllerDelegate: class {
    func deleteButtonPressed(with: Any)
    func visitWebsite(_ link: String)
}

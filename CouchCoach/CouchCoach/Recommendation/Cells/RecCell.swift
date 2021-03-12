import UIKit

class RecCell: UITableViewCell {

    @IBOutlet weak var contentLayer: UIView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var scheduleButton: UIButton!

    weak var delegate: RecommendationViewControllerDelegate?
    var recommendation: Recommendation?

    func configureWith(_ recommendation: Recommendation, delegate: RecommendationViewControllerDelegate) {
        self.recommendation = recommendation
        self.delegate = delegate
        self.contentLayer.layer.cornerRadius = 10
        nameLabel.text = recommendation.name
        infoLabel.text = recommendation.info
        detailLabel.text = recommendation.detail ?? ""
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

    @IBAction func scheduleButtonTapped(_ sender: Any) {
        guard let recommendation = recommendation else {
            return
        }
        delegate?.scheduleButtonPressed(with: recommendation)
    }
}


protocol RecommendationViewControllerDelegate: class {
    func scheduleButtonPressed(with: Recommendation)
    func visitWebsite(_ link: String)
}

import UIKit
import EventKit

class FeedTableViewCell: UITableViewCell {


    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var moreInfoButton: UIButton!

    weak var delegate: FeedViewControllerDelegate?

    var event: EKEvent?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.autoresizingMask = .flexibleHeight
    }

    func configureWith(event: EKEvent, delegate: FeedViewControllerDelegate) {
        self.event = event
        self.delegate = delegate
        self.cardView.layer.cornerRadius = 10
        moreInfoButton.layer.cornerRadius = 10
        nameLabel.text = event.title
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let startTime = formatter.string(from: event.startDate)
        let endTime = formatter.string(from: event.endDate)
        startLabel.text = "From: \(startTime)"
        endLabel.text = "To: \(endTime)"
        nameLabel.superview?.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }

    @IBAction func moreInfoButtonTapped(_ sender: Any) {
        guard let link = event?.url else {
            return
        }
        delegate?.viewMoreInfo(link)
    }

}

protocol FeedViewControllerDelegate: class {
    func viewMoreInfo(_ url: URL)
}

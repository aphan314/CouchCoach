import EventKit
import UIKit

class HourlyEventsTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var moreInfoButton: UIButton!

    var event: EKEvent?
    weak var delegate: CalendarHourlyEventsDelegate?

    func configureWith(event: EKEvent, delegate: CalendarHourlyEventsDelegate) {
        self.event = event
        self.delegate = delegate
        moreInfoButton.layer.cornerRadius = 10
        cardView.layer.cornerRadius = 10
        nameLabel.text = event.title
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let startTime = formatter.string(from: event.startDate)
        let endTime = formatter.string(from: event.endDate)
        startLabel.text = "From: \(startTime)"
        endLabel.text = "To: \(endTime)"
    }

    @IBAction func viewMoreInfoTapped(_ sender: Any) {
        guard let link = event?.url else {
            return
        }
        delegate?.viewMoreInfo(link)
    }
}

protocol CalendarHourlyEventsDelegate: class {
    func viewMoreInfo(_ url: URL)
}

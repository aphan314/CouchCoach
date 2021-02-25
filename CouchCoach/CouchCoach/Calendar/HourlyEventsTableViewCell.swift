import EventKit
import EventKitUI
import UIKit

class HourlyEventsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!


    func configureWith(event: EKEvent) {
        nameLabel.text = event.title
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let startTime = formatter.string(from: event.startDate)
        let endTime = formatter.string(from: event.endDate)
        startLabel.text = startTime
        endLabel.text = endTime
    }
}

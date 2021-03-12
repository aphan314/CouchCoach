import UIKit

class HeaderEventTableViewCell: UITableViewCell {

    @IBOutlet weak var dateTextLabel: UILabel!

    func configureWith(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-YYYY"
        let string = formatter.string(from: date)
        dateTextLabel.text = "Events for: \(string)"
    }
}

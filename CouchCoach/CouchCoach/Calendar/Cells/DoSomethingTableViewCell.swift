import UIKit

class DoSomethingTableViewCell: UITableViewCell {

    weak var delegate: CalendarDoSomethingDelegate?

    @IBAction func doSomethingButtonTapped(_ sender: Any) {
        delegate?.navigateToExplore()
    }
}

protocol CalendarDoSomethingDelegate: class {
    func navigateToExplore()
}

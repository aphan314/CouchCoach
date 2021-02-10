import UIKit
import EventKit
import EventKitUI

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleEventsTableView()
        self.eventsTableView.reloadData()
    }
    
    private func handleEventsTableView() {
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
    }
}

extension CalendarViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CalendarManager.shared.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = CalendarManager.shared.events[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = "Titles: \(event.title) \nStarts: \(event.startDate) \nEnds: \(event.endDate)"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

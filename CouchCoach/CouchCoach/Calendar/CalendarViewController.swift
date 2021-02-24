import UIKit
import EventKit
import EventKitUI
import FSCalendar

class CalendarViewController: UIViewController {

    @IBOutlet var calendar: FSCalendar!
    @IBOutlet weak var eventsTableView: UITableView!

    let headerEventCell = "HeaderEventCell"
    let hourlyEventCell = "HourlyEventsTableViewCell"

    var selectedDate = Date()
    var hourlyEvents: [Int: [EKEvent]]?

    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        updateSelectedDate(with: selectedDate)
    }

    func updateSelectedDate(with date: Date) {
        selectedDate = date
        hourlyEvents = CalendarManager.shared.fetchEvents(for: selectedDate)
        eventsTableView.reloadData()
    }

    @IBAction func createEventButtonPressed(_ sender: Any) {
        let eventVC = EKEventEditViewController()
        eventVC.editViewDelegate = self
        eventVC.eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventVC.eventStore)
        event.title = "Free Time"
        event.startDate = selectedDate
        eventVC.event = event
        present(eventVC, animated: true)
    }
}

//MARK: - FSCalendarDelegate
extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let string = formatter.string(from: date)
        print("\(string)")
        updateSelectedDate(with: date)
    }
}

//MARK: - FSCalendarDataSource
extension CalendarViewController: FSCalendarDataSource {

}

//MARK: - UITableViewDataSource
extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section != 0, let hourlyEvents = hourlyEvents, let events = hourlyEvents[section - 1] {
            return events.count
        }
        if section == 0 {
            return 1
        }
        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 25
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let hourlySections = ["12PM", "1AM","2AM","3AM","4AM","5AM","6AM","7AM","8AM","9AM","10AM","11AM","12AM","1PM",
                                "2PM","3PM","4PM","5PM","6PM","7PM","8PM","9PM","10PM","11PM"]
        switch section {
        case 1...25:
            return hourlySections[section-1]
        default:
            return ""
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: headerEventCell) as? HeaderEventTableViewCell  {
                    cell.configureWith(selectedDate)
                    return cell
                }
            case 1...25:
                if let hourlyEvents = hourlyEvents,
                    let events = hourlyEvents[indexPath.section - 1],
                    let cell = tableView.dequeueReusableCell(withIdentifier: hourlyEventCell) as? HourlyEventsTableViewCell {
                    let event = events[indexPath.row]
                    cell.configureWith(event: event)
                    return cell
                }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}

//MARK: - UITableViewDelegate
extension CalendarViewController: UITableViewDelegate {

}

//MARK: - EKEventEditViewDelegate
extension CalendarViewController: EKEventEditViewDelegate {
    // This is the function called when the event edit page is dismissed
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        switch action {
        case .canceled, .deleted:
            dismiss(animated: true, completion: nil)
        case .saved:
            guard let event = controller.event else {
                dismiss(animated: true, completion: nil)
                return
            }
            CalendarManager.shared.insertEvent(event)
            dismiss(animated: true, completion: nil)
        @unknown default:
            dismiss(animated: true, completion: nil)
        }
    }
}

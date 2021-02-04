import UIKit
import EventKit
import EventKitUI

class CalendarViewController: UIViewController {

    // Get the appropriate calendar.
    var calendar = Calendar.current
    var titles : [String] = []
    var startDates : [NSDate] = []
    var endDates : [NSDate] = []
    var events : [EKEvent] = []

    let eventStore = EKEventStore()    
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleEventsTableView()
        
    }
    
    func displayEvents() {
    
        let calendars = eventStore.calendars(for: .event)
        for calendar in calendars {
            print("calendar name: \(calendar.title)")
            let today = NSDate(timeIntervalSinceNow: 0)
            let oneWeekAfter = NSDate(timeIntervalSinceNow: +7*24*3600)
            let predicate = eventStore.predicateForEvents(withStart: today as Date, end: oneWeekAfter as Date, calendars: [calendar])

            events = eventStore.events(matching: predicate)

            for event in events {
                titles.append(event.title)
                startDates.append(event.startDate! as NSDate)
                endDates.append(event.endDate! as NSDate)
            }
        }
        
        // Reloading table view reqiures us to be on the main thread, currently this is in a closure (not main thread)
        DispatchQueue.main.async {
            // In here we are on the main thread. So we can now make UI changes
            self.eventsTableView.reloadData()
        }
    }
    
    private func handleEventsTableView() {
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        
        eventStore.requestAccess(to: .event) { granted, error in
            // Handle the response to the request.
            if granted {
                self.displayEvents()
            }
        }
    }
}

extension CalendarViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Titles: \(titles[indexPath.row]) \nStarts: \(startDates[indexPath.row]) \nEnds: \(endDates[indexPath.row])"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

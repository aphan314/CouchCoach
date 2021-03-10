import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    let logoutSegueIdentifier = "logoutSegue"
    let upcomingEventCellIdentifier = "UpcomingEventsTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.startUpdatingLocation()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        AuthenticationManager.shared.logout { result in
            switch result {
            case true:
                self.performSegue(withIdentifier: self.logoutSegueIdentifier, sender: nil)
            case false:
                self.displayAlert(title: "Error", message: "Try Logging out again")
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CalendarManager.shared.events.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Today"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: upcomingEventCellIdentifier) as? HourlyEventsTableViewCell {
            cell.configureWith(event: CalendarManager.shared.events[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {

}

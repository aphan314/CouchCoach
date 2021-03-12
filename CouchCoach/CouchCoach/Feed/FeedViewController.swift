import UIKit
import Firebase

class FeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    let logoutSegueIdentifier = "logoutSegue"
    let feedCellIdentifier = "FeedCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.startUpdatingLocation()
        tableView.dataSource = self
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableView.automaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
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
extension FeedViewController: UITableViewDataSource {
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: feedCellIdentifier) as? FeedTableViewCell {
            cell.configureWith(event: CalendarManager.shared.events[indexPath.row], delegate: self)
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: - FeedViewControllerDelegate
extension FeedViewController: FeedViewControllerDelegate {
    func viewMoreInfo(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

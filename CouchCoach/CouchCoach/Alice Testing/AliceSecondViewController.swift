import UIKit
import Foundation

class AliceSecondViewController: UIViewController {
        @IBOutlet weak var businessTableView: UITableView!
    
        let Latitude: Double = Double(LocationManager.shared.lastLocation?.coordinate.latitude ?? 0)
        let Longitude: Double = Double(LocationManager.shared.lastLocation?.coordinate.longitude ?? 0)

        var businesses: [Business] = []
        var term = ""

        override func viewDidLoad() {
            super.viewDidLoad()
            businessTableView.delegate = self
            businessTableView.dataSource = self
            businessTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
            businessTableView.separatorStyle = .none

            YelpManager.shared.retrieveBusinesses(latitude: Latitude, longitude: Longitude, term: term,
                           limit: 20, sortBy: "distance", locale: "en_US") { (response, error) in

                            if let response = response {
                                self.businesses = response
                                DispatchQueue.main.async {
                                    self.businessTableView.reloadData()
                                }
                            }
            }
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AliceSecondViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell

        cell.nameLabel.text = businesses[indexPath.row].name
        cell.ratingLabel.text = String(businesses[indexPath.row].rating ?? 0.0)
        cell.priceLabel.text = businesses[indexPath.row].price ?? "-"
        cell.isClosed = businesses[indexPath.row].is_closed ?? false
        cell.addressLabel.text = businesses[indexPath.row].address

        return cell
    }
}
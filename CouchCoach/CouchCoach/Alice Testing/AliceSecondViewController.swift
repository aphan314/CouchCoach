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
        return 250
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell

        cell.nameLabel.text = businesses[indexPath.row].name
        cell.addressLabel.text = businesses[indexPath.row].address
        cell.phoneLabel.text = businesses[indexPath.row].display_phone ?? "Phone Number Not Available"
        cell.categoriesLabel.text = businesses[indexPath.row].categories
        cell.ratingLabel.text = String(businesses[indexPath.row].rating ?? 0.0) + "/5.0 rating"
        cell.priceLabel.text = businesses[indexPath.row].price ?? "-"
        let attributedString = NSMutableAttributedString(string: "Link to Website")
        let link = businesses[indexPath.row].website
        let url = URL(string: link ?? "")!

        attributedString.setAttributes([.link: url], range: NSMakeRange(0, 15))
        cell.websiteTextView.attributedText = attributedString
    
        cell.isClosed = businesses[indexPath.row].is_closed ?? false
        let image_url = businesses[indexPath.row].image_url ?? ""
        cell.businessImage.loadImage(from: image_url)

        return cell
    }
    
}

extension UIImageView {
    func loadImage(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { d, r, e in
            guard
                let httpResponse = r as? HTTPURLResponse, httpResponse.statusCode == 200,
                let type = r?.mimeType, type.hasPrefix("image"),
                let d = d, e == nil,
                let img = UIImage(data: d)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = img
            }
        }.resume()
    }
    func loadImage(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        loadImage(from: url, contentMode: mode)
    }
}

import UIKit
import Foundation
import FirebaseFirestore
import FirebaseAuth


class AliceSecondViewController: UIViewController {
        @IBOutlet weak var businessTableView: UITableView!
    
        let Latitude: Double = Double(LocationManager.shared.lastLocation?.coordinate.latitude ?? 0)
        let Longitude: Double = Double(LocationManager.shared.lastLocation?.coordinate.longitude ?? 0)

        var businesses: [Business] = []
        var term = ""
        var save: [Int] = []
        var not: [Int] = []
        var saved_arr: [NSDictionary] = []
        var not_arr: [NSDictionary] = []

        override func viewDidLoad() {
            super.viewDidLoad()
            businessTableView.delegate = self
            businessTableView.dataSource = self
            businessTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
            businessTableView.separatorStyle = .none
            
            let db = Firestore.firestore()
            
            let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    self.not_arr = document.data()?["yelp_not"] as! [NSDictionary]
                }
            }
            YelpManager.shared.retrieveBusinesses(latitude: Latitude, longitude: Longitude, term: term,
                           limit: 20, sortBy: "distance", locale: "en_US") { (response, error) in

                            if let response = response {
                                var temp = response
                                var count = 0
                                var indices: [Int] = []
                                for b in temp {
                                    let dictionary: NSDictionary = [
                                        "id" : b.id,
                                        "name" : b.name,
                                        "address" : b.address,
                                        "display_phone" : b.display_phone,
                                        "categories" : b.categories,
                                        "rating" : b.rating,
                                        "price" : b.price,
                                        "is_closed" : b.is_closed,
                                        "website" : b.website,
                                        "image_url" : b.image_url
                                    ]
                                    if(self.not_arr.contains(dictionary)){
                                        indices.append(count)
                                    }
                                    count = count + 1
                                }
                                for(ind, t) in temp.enumerated(){
                                    if(!indices.contains(ind)){
                                        self.businesses.append(t)
                                    }
                                }
                                DispatchQueue.main.async {
                                    self.businessTableView.reloadData()
                                }
                            }
            }
        }
    
        override func viewWillAppear(_ animated: Bool) {
            let db = Firestore.firestore()
            
            let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    self.saved_arr = document.data()?["yelp_saved"] as! [NSDictionary]
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

extension AliceSecondViewController: UITableViewDelegate, UITableViewDataSource, cDelegate {
    func didClickButton(index: Int, value: Int) {
        let db = Firestore.firestore()
        if(value == 1){
            save.append(index)
            let uarr = Array(Set(save))
            var barr: [NSDictionary] = []
            for ind in uarr {
                let dictionary: NSDictionary = [
                    "id" : businesses[ind].id,
                    "name" : businesses[ind].name,
                    "address" : businesses[ind].address,
                    "display_phone" : businesses[ind].display_phone,
                    "categories" : businesses[ind].categories,
                    "rating" : businesses[ind].rating,
                    "price" : businesses[ind].price,
                    "is_closed" : businesses[ind].is_closed,
                    "website" : businesses[ind].website,
                    "image_url" : businesses[ind].image_url
                ]
                barr.append(dictionary)
            }
            let fin_arr = Array(Set(barr + self.saved_arr))
            db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["yelp_saved":fin_arr as! [NSDictionary]])
        }
        else if(value == 2){
            not.append(index)
            let uarr = Array(Set(not))
            var barr: [NSDictionary] = []
            for ind in uarr {
                let dictionary: NSDictionary = [
                    "id" : businesses[ind].id,
                    "name" : businesses[ind].name,
                    "address" : businesses[ind].address,
                    "display_phone" : businesses[ind].display_phone,
                    "categories" : businesses[ind].categories,
                    "rating" : businesses[ind].rating,
                    "price" : businesses[ind].price,
                    "is_closed" : businesses[ind].is_closed,
                    "website" : businesses[ind].website,
                    "image_url" : businesses[ind].image_url
                ]
                barr.append(dictionary)
            }
            let fin_arr = Array(Set(barr + self.not_arr))
            db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["yelp_not":fin_arr as! [NSDictionary]])
            businesses.remove(at: index)
            businessTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        cell.cDelegate = self
        cell.index = indexPath
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



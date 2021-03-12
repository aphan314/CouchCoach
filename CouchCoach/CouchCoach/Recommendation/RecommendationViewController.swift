import UIKit
import FirebaseFirestore
import FirebaseAuth

class RecommendationViewController: UIViewController {

    @IBOutlet weak var recommendationsTableView: UITableView!
    var recommendations: [NSDictionary] = []
    var recommendationList: [Recommendation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recommendationsTableView.delegate = self
        recommendationsTableView.dataSource = self
        recommendationsTableView.register(UINib(nibName: "RecCell", bundle: nil), forCellReuseIdentifier: "recCell")
        recommendationsTableView.separatorStyle = .none

    }
    override func viewWillAppear(_ animated: Bool) {
        let badConditions = ["Thunderstorm", "Drizzle", "Rain", "Snow"]
        let Lat: Double = Double(LocationManager.shared.lastLocation?.coordinate.latitude ?? 0)
        let Long: Double = Double(LocationManager.shared.lastLocation?.coordinate.longitude ?? 0)
        WeatherManager.shared.retrieveWeather(lat: Lat, lon: Long) { (response, error) in
            if let response = response {
                let weather = response
                let db = Firestore.firestore()
                
                let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
                self.recommendationList = []
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        self.recommendations = document.data()?["watchLater"] as! [NSDictionary]
                        for recommend in self.recommendations {
                            var recommendation = Recommendation()
                            recommendation.id = recommend.value(forKey: "videoId") as? String
                            recommendation.name = recommend.value(forKey: "videoTitle") as? String
                            recommendation.info = recommend.value(forKey: "channelTitle") as? String
                            recommendation.detail = recommend.value(forKey: "published") as? String
                            recommendation.url = recommend.value(forKey: "url") as? String
                            recommendation.thumbnail = recommend.value(forKey: "thumbnail") as? String
                            self.recommendationList.append(recommendation)
                        }
                        self.recommendationsTableView.reloadData()
                    }
                }
                let cond = weather.condition ?? ""
                if(!badConditions.contains(cond)){
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            self.recommendations = document.data()?["yelp_saved"] as! [NSDictionary]
                            for recommend in self.recommendations {
                                var recommendation = Recommendation()
                                recommendation.id = recommend.value(forKey: "id") as? String
                                recommendation.name = recommend.value(forKey: "name") as? String
                                recommendation.info = recommend.value(forKey: "address") as? String
                                recommendation.detail = recommend.value(forKey: "rating") as? String
                                recommendation.url = recommend.value(forKey: "website") as? String
                                recommendation.thumbnail = recommend.value(forKey: "image_url") as? String
                                self.recommendationList.append(recommendation)
                            }
                            self.recommendationsTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

extension RecommendationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendationList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recCell", for: indexPath) as! RecCell
        cell.nameLabel.text = recommendationList[indexPath.row].name
        cell.infoLabel.text = recommendationList[indexPath.row].info
        cell.detailLabel.text = recommendationList[indexPath.row].detail
        let image_url = recommendationList[indexPath.row].thumbnail ?? ""
        let attributedString = NSMutableAttributedString(string: "Link to Website")
        let link = recommendationList[indexPath.row].url
        let url = URL(string: link ?? "")!

        attributedString.setAttributes([.link: url], range: NSMakeRange(0, 15))
        cell.urlTextView.attributedText = attributedString
    
        cell.thumbnailImage.loadImage(from: image_url)
        return cell
    }
}


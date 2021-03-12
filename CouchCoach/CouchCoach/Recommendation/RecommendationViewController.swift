import UIKit
import FirebaseFirestore
import FirebaseAuth
import EventKit
import EventKitUI

class RecommendationViewController: UIViewController {

    @IBOutlet weak var recommendationsTableView: UITableView!

    let recCellIdentifier = "recCell"

    var recommendations: [NSDictionary] = []
    var recommendationList: [Recommendation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recommendationsTableView.delegate = self
        recommendationsTableView.dataSource = self
        
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
                                recommendation.detail = "\(recommend.value(forKey: "rating") ?? "")/5.0"
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "recCell", for: indexPath) as? RecCell {

            cell.configureWith(recommendationList[indexPath.row], delegate: self)
            return cell
        }
        return UITableViewCell()
    }
}

extension RecommendationViewController: RecommendationViewControllerDelegate {

    func visitWebsite(_ link: String) {
        guard var url = URL(string: link) else {
            return
        }
        if(link.contains("youtube")){
            let index = link.index(link.startIndex, offsetBy: 35)
            let mySubstring = link[..<index]
            url = URL(string: "http://" + String(mySubstring ?? ""))!
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    func scheduleButtonPressed(with recommendation: Recommendation) {
        let eventVC = EKEventEditViewController()
        eventVC.editViewDelegate = self
        eventVC.eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventVC.eventStore)
        event.title = recommendation.name ?? ""
        let temp = recommendation.url ?? ""
        var url = URL(string: recommendation.url ?? "")
        if(temp.contains("youtube")){
            let index = temp.index(temp.startIndex, offsetBy: 35)
            let mySubstring = temp[..<index]
            url = URL(string: "http://" + String(mySubstring ?? ""))!
        }
        event.url = url
        event.notes = recommendation.info ?? ""

        eventVC.event = event
        present(eventVC, animated: true)
    }
}

//MARK: - EKEventEditViewDelegate
extension RecommendationViewController: EKEventEditViewDelegate {
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
            //TODO: Record in the database that this event was used
            dismiss(animated: true, completion: nil)
        @unknown default:
            dismiss(animated: true, completion: nil)
        }
    }
}

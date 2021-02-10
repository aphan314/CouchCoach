import Foundation

class YelpManager {
    static let shared = YelpManager()

    func retrieveBusinesses(latitude: Double,
                        longitude: Double,
                        term: String,
                        limit: Int,
                        sortBy: String,
                        locale: String,
                        completionHandler: @escaping ([Business]?, Error?) -> Void) {

        let apikey = "FekDR_-_AQV6bC-LBBbHilb-qVQmqlGeaYkF41zEQy_iih6nFxhxnbX49R01mAQHSO-wypMHhMUASh3REEGjfK5yPtpOuSlyxJ4vQmGZVWPWxyPdiDDEcmlgo-IeYHYx"

        let baseURL = "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)&term=\(term)&limit=\(limit)&sort_by=\(sortBy)&locale=\(locale)"

        let url = URL(string: baseURL)

        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            do {

                let json = try JSONSerialization.jsonObject(with: data!, options: [])

                guard let resp = json as? NSDictionary else { return }

                guard let places = resp.value(forKey: "businesses") as? [NSDictionary] else { return }

                var businessesList: [Business] = []

                for place in places {
                    var business = Business()
                    business.name = place.value(forKey: "name") as? String
                    business.id = place.value(forKey: "id") as? String
                    business.rating = place.value(forKey: "rating") as? Float
                    business.price = place.value(forKey: "price") as? String
                    business.is_closed = place.value(forKey: "is_closed") as? Bool
                    business.distance = place.value(forKey: "distance") as? Double
                    let address = place.value(forKeyPath: "location.display_address") as? [String]
                    business.address = address?.joined(separator: "\n")

                    businessesList.append(business)
                }

                completionHandler(businessesList, nil)

            } catch {
                print("Caught error")
                completionHandler(nil, error)
            }
            }.resume()

    }
}

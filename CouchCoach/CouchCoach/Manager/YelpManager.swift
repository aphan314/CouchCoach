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

        let apikey = "dDJP1t-j5RxGcbWvnzRnqlm11imVhIO4k8x8_hstJ8D9_eSjh5D_1Mi0DoymOABdl0uqWYXScd9SfXtlvF49iH5Z041AAk2YWBywAR1vU4hnUC8A6teh_HQXMzwSYHYx"

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
                    business.id = place.value(forKey: "id") as? String
                    business.name = place.value(forKey: "name") as? String
                    let address = place.value(forKeyPath: "location.display_address") as? [String]
                    business.address = address?.joined(separator: "\n")
                    business.display_phone = place.value(forKey: "display_phone") as? String
                    let categories = place.value(forKeyPath: "categories") as! [NSDictionary]
                    var c = [String]()
                    for item in categories {
                        let obj = item as NSDictionary
                        c.append(obj.value(forKey: "title") as! String)
                    }
                    business.categories = c.joined(separator: ", ")
                    business.rating = place.value(forKey: "rating") as? Float
                    business.price = place.value(forKey: "price") as? String
                    business.is_closed = place.value(forKey: "is_closed") as? Bool
                    business.website = place.value(forKey: "url") as? String
                    business.distance = place.value(forKey: "distance") as? Float
                    business.image_url = place.value(forKey: "image_url") as? String
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

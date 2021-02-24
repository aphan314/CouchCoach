import UIKit
import Foundation

class AliceFirstViewController: UIViewController {

    @IBOutlet weak var tagsSearchBar: UISearchBar!
    @IBOutlet weak var tagsTableView: UITableView!

        let tags = ["Archery", "Art", "Badminton", "Bartending", "Baseball", "Basketball", "Bicycle", "Bowling", "Boxing", "Climbing", "Cooking", "Cosmetology", "Crochet", "Dance", "Driving", "Fencing", "Fishing", "Golf", "Gymnastics", "Hiking", "Karate", "Kickboxing", "Knitting", "Meditation", "Music", "Nursing", "Photography", "Skating", "Soccer", "Swimming", "Taekwondo", "Tennis", "Tutoring", "Volleyball", "Yoga"]
        var searchTag = [String]()
        var searching = false

        override func viewDidLoad() {
            super.viewDidLoad()

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

extension AliceFirstViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchTag.count
        } else {
            return tags.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if searching {
            cell?.textLabel?.text = searchTag[indexPath.row]
        } else {
            cell?.textLabel?.text = tags[indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let vc = storyboard?.instantiateViewController(identifier: "AliceSecondViewController") as? AliceSecondViewController
        if searching {
            vc?.term = searchTag[indexPath.row]
        } else {
            vc?.term = tags[indexPath.row]
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

extension AliceFirstViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTag = tags.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tagsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tagsTableView.reloadData()
    }
}

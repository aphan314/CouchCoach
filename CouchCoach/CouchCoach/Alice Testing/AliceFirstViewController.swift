import UIKit
import Foundation
import FirebaseFirestore
import FirebaseAuth
import TTGTagCollectionView

class AliceFirstViewController: UIViewController {

    @IBOutlet weak var tagsSearchBar: UISearchBar!
    @IBOutlet weak var tagsTableView: UITableView!

        var tags = [String]()
        var searchTag = [String]()
        var searching = false

        override func viewDidLoad() {
            super.viewDidLoad()
            let db = Firestore.firestore()
            
            let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let arr = document.data()?["tags"] ?? []
                    self.tags = arr as! [String]
                    self.tagsTableView.reloadData()
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

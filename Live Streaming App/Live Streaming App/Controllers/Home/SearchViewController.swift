//
//  SearchViewController.swift
//  Live Streaming App
//
//  Created by Sudayn on 10/5/2024.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var debounceTimer: DispatchWorkItem?
    
    @IBOutlet weak var tableView: UITableView!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    

    func search(query: String) {
        print(query)
        AppModel.shared.searchProfile(query: query, completion: {users in
            self.users = users
            self.tableView.reloadData()
        })
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Cancel previous debounce timer if exists
        debounceTimer?.cancel()
        
        // Create a new debounce timer
        debounceTimer = DispatchWorkItem { [weak self] in
            self?.search(query: searchText)
        }
        
        // Schedule the debounce timer
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: debounceTimer!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(query: "")
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell {
            let user = users[indexPath.row]
            cell.lbl1.text = "\(user.firstname) \(user.lastname)"
            cell.lbl2.text = user.email
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        if let vc = Storyboards.instantiateViewController(from: "Main", withIdentifier: "UserProfileController") as? UserProfileController {
            vc.id = user.uid
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//
//  FirstViewController.swift
//  FreshWorks iOS Giphy Sample App
//
//  Created by Sam on 2017-12-20.
//  Copyright © 2017 Sam Kheirandish. All rights reserved.
//

import UIKit

struct TableViewCellIdentifiers {
    static let searchResultCell = "SearchResultCell"
    static let nothingFoundCell = "NothingFoundCell"
    static let loadingCell = "LoadingCell"
}

class SearchViewController: UIViewController {

    let search = Search(state: .notSearchedYet)
    var isFetchingNewResults = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search"

        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
        
        tableView.rowHeight = 320
        tableView.contentInset = UIEdgeInsetsMake(56, 0, 0, 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch search.state {
        case .notSearchedYet:
            fallthrough
        case .noResults:
            fallthrough
        case .loading:
            return 1
        case .results(let list):
            return list.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch search.state
        {
            case .notSearchedYet: fallthrough
            case .noResults:
                return tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
            case .loading:
                let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.loadingCell, for: indexPath)
                let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
                spinner.startAnimating()
                return cell
            case .results(let list):
                let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
                let searchResult = list[indexPath.row]
                cell.configure(with: searchResult)
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch search.state {
        case .results(let list):
            if indexPath.row == list.count - 10, !isFetchingNewResults { //you might decide to load sooner than last item
                print(indexPath.row, list.count - 10)
                isFetchingNewResults = true
                search.performSearch(for: searchBar.text!, offset: list.count,to: list,  completion: { (success) in
                    if !success {
                        self.showErrorMessage()
                    }
                    
                    // UI changes always get triggered on main queue
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.isFetchingNewResults =  false
                })
            }
        default:
            break
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
        searchBar.showsCancelButton = false
    }
    
    func performSearch() {
        search.performSearch(for: searchBar.text!) { (success) in
            if !success {
                self.showErrorMessage()
            }
            
            // UI changes always get triggered on main queue
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func showErrorMessage() {
        
        let alertController = UIAlertController(title: "Network Error!", message: "You are experiencing connectivity intruptions.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

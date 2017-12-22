//
//  FavouritesViewController.swift
//  FreshWorks
//
//  Created by Sam on 2017-12-22.
//  Copyright © 2017 Sam Kheirandish. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var favourites = [GIF]() {
        didSet {
            // Required to update table in case we delete an item
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        tableView.register(FavouriteCell.self, forCellReuseIdentifier: String(describing: FavouriteCell.self))
        
        tableView.rowHeight = 320
        favourites = Database.getAllGIFs()
    }

    override func viewDidAppear(_ animated: Bool) {
        // Need to fetch any updates in the database
        favourites = Database.getAllGIFs()
        
        // Table view reload on table vew apearing is required for cells to resize
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch favourites.count {
        case 0:
            // We want to be able to show the Nothing found cell
            return 1
        default:
            return favourites.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch favourites.count {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FavouriteCell.self), for: indexPath) as! FavouriteCell
            cell.configure(with: favourites[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Database.delete(by: favourites[indexPath.row].id)
            favourites.remove(at: indexPath.row)
            // No need to manually delete rows. TableView will refresh on favourites change
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
}

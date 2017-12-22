//
//  SavedViewController.swift
//  FreshWorks
//
//  Created by Sam on 2017-12-22.
//  Copyright © 2017 Sam Kheirandish. All rights reserved.
//

import UIKit

class SavedViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var favourites = [GIF]() {
        didSet {
            // Required to update table in case we delete an item
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: String(describing: SavedViewCell.self), bundle: Bundle.main)
        collectionView.register(cellNib, forCellWithReuseIdentifier: String(describing: SavedViewCell.self))
        
        favourites = Database.getAllGIFs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Need to fetch any updates in the database
        favourites = Database.getAllGIFs()
        
        // Table view reload on table vew apearing is required for cells to resize
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SavedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK CollectionViewDataSource Mathods
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return favourites.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SavedViewCell.self), for: indexPath) as? SavedViewCell {
            let gif = favourites[indexPath.row]
            cell.deleteButton.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)
            cell.deleteButton.tag = indexPath.item
            cell.configure(with: gif)
            return cell
        }
        return SavedViewCell()
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width / 1.29)
    }
    
    
    @objc func deleteImage(_ sender: UIButton)
    {
        Database.delete(by: favourites[sender.tag].id)
        favourites.remove(at: sender.tag)
    }
}

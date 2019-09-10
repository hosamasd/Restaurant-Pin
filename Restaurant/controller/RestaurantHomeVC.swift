//
//  ViewController.swift
//  Restaurant
//
//  Created by hosam on 9/8/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import CoreData


let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

class RestaurantHomeVC: BaseVC {

    let cellID = "cellID"
    
    var restaurantsArray:[Restaurant] = []
      var filterRestaurantsArray:[Restaurant] = []
     let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
        
        fetchData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchController.isActive ? filterRestaurantsArray.count : restaurantsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! RestaurantCell
        let rest =  searchController.isActive ? filterRestaurantsArray[indexPath.item] : restaurantsArray[indexPath.item]
        
        cell.rest = rest
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 120)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let res = restaurantsArray[indexPath.item]
        
        let detail = RestaurantDetailsVC(rest: res)
//        detail.restaurant = res
        navigationController?.pushViewController(detail, animated: true)
    }

    
    override func setupNavigastionItem() {
        self.definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.placeholder = "Search for Restaurants"
        
        navigationItem.title = "Restaurant Pin"

        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white,.font: UIFont.boldSystemFont(ofSize: 25)]

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
    }
    
    override func setupCollectionViews()  {
        collectionView.backgroundColor = .white
        collectionView.register(RestaurantCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func fetchData()  {
        let request:NSFetchRequest = Restaurant.fetchRequest()
        
        do {
           restaurantsArray =  try context.fetch(request)
            collectionView.reloadData()
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
  @objc  func handleAdd()  {
        let create = CreateRestaurantVC()
        navigationController?.pushViewController(create, animated: true)
    }
}


extension RestaurantHomeVC: UISearchBarDelegate{
    
    
}

extension RestaurantHomeVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text == nil || searchController.searchBar.text!.isEmpty{
            view.endEditing(true)
            filterRestaurantsArray.removeAll()
        }else {
            let text = searchController.searchBar.text!.lowercased()
            filterUsers(text:text)
        }
        collectionView.reloadData()


    }

    func filterUsers(text:String)  {
        filterRestaurantsArray = restaurantsArray.filter({$0.name?.lowercased().range(of: text )  != nil})
    }
    
}

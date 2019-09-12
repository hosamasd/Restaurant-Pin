//
//  ViewController.swift
//  Restaurant
//
//  Created by hosam on 9/8/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import CoreData
import MOLH
import UserNotifications

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

class RestaurantHomeVC: BaseVC {
    
    let cellID = "cellID"
    
    var restaurantsArray:[Restaurant] = []
    var filterRestaurantsArray:[Restaurant] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        prepareNotification()
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
        
        createAlert(index: indexPath.item)
    }
    
    // MARK: -user methods
    
    override func setupNavigastionItem() {
        self.definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.barTintColor = UIColor(r: 218, g: 100, b: 70)
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "Search for Restaurants".localized
        
        navigationItem.title = "Restaurant Pin".localized
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white,.font: UIFont.boldSystemFont(ofSize: 25)]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
    }
    
    override  func setupCollectionViews()  {
        
        collectionView.backgroundColor = .white
        collectionView.register(RestaurantCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    
    
    fileprivate  func fetchData()  {
        
        CoreDataServices.shared.loadDataFromCoreData {[weak self] (rests, err) in
            if let err = err{
                self?.showAlert(title: "Error", message: err.localizedDescription);return
            }
            guard let rests = rests else {return}
            self?.restaurantsArray = rests
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
    }
    
    // TODO: -handle methods
    
    @objc fileprivate func handleAdd()  {
        let create = CreateRestaurantVC()
        navigationController?.pushViewController(create, animated: true)
    }
}

// MARK: -Extensions

extension RestaurantHomeVC: UISearchResultsUpdating, UISearchBarDelegate{
    
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
    
    fileprivate  func filterUsers(text:String)  {
        filterRestaurantsArray = restaurantsArray.filter({$0.name?.lowercased().range(of: text )  != nil || $0.location?.lowercased().range(of: text )  != nil})
    }
    
     
        
    func createAlert(index:Int)  {
         let rests = restaurantsArray[index]
        let alert = UIAlertController(title: "Restaurant Pin".localized, message: "choose action".localized, preferredStyle: .actionSheet)
        let display = UIAlertAction(title: "Display".localized, style: .default) { [weak self] (_) in
//            guard let res = self?.restaurantsArray[index] else {return}
            
            let detail = RestaurantDetailsVC(rest: rests)
            self?.navigationController?.pushViewController(detail, animated: true)
        }
        
        let share = UIAlertAction(title: "Share", style: .default) {[weak self] (_) in
            // Social Sharing Button
                
            let defaultText = "Just checking in at " + rests.name!
                
                if let imageToShare = UIImage(data: rests.image ?? Data()) {
                    let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                    self?.present(activityController, animated: true, completion: nil)
                }
            }
        
        
        
        let delete = UIAlertAction(title: "Delete".localized, style: .destructive) {  (_) in
            let res = self.restaurantsArray[index]
            print(self.restaurantsArray.count)
            CoreDataServices.shared.deleteDataFromCoreData(index: index, rest: res, restArray: &self.restaurantsArray, completion: {[weak self] (err) in
                if let err = err{
                    self?.showAlert(title: "Error", message: err.localizedDescription);return
                }
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            })
        }
        
        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel) { (_) in
            alert.dismiss(animated: true)
        }
        
        [display,share,delete,cancel].forEach({alert.addAction($0)})
        
        present(alert, animated: true)
    }
    
    
   
    
    
    
   
    
    fileprivate func prepareNotification()  {
        
        NotificationServices.notificationServices.scheduleNotification(restaurants: restaurantsArray) {[weak self] (err) in
            if let err = err {
                self?.showAlert(title: "Error", message: "This app is not allowed to query for scheme tel \n \(err.localizedDescription)");return
            }
        }
    }
}

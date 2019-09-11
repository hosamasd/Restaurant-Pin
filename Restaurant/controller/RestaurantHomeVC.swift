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
        
//        fetchData()
    }
    
    func prepareNotification()  {
        
        if restaurantsArray.count <= 0 {
            return
        }
        
        // Pick a restaurant randomly
        
        let randomNum = Int.random(in: 0 ..< restaurantsArray.count)
        let suggestedRestaurant = restaurantsArray[randomNum]
        
        // Create the user notification
        let content = UNMutableNotificationContent()
        content.title = "Restaurant Recommendation"
        content.subtitle = "Try new food today"
        content.body = "I recommend you to check out \(suggestedRestaurant.name!). The restaurant is one of your favorites. It is located at \(suggestedRestaurant.location!). Would you like to give it a try?"
        content.sound = UNNotificationSound.default
        
        
        
        
        
        // Add an image to the notification
        let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let tempFileURL = tempDirURL.appendingPathComponent("suggested-restaurant.jpg")
        
         guard let imageData = suggestedRestaurant.image else { return  }
       guard let image = UIImage(data: imageData) else { return  }
        
            do {
                try image.jpegData(compressionQuality: 1.0)?.write(to: tempFileURL)
                 let restaurantImage = try UNNotificationAttachment(identifier: "restaurantImage", url: tempFileURL, options: nil)
                    content.attachments = [restaurantImage]
                
            }catch let err{
             print(err.localizedDescription)
            }
           
        
      
        // Add custom action
        let categoryIdentifer = "foodpin.restaurantaction"
        let makeReservationAction = UNNotificationAction(identifier: "foodpin.makeReservation", title: "Reserve a table", options: [.foreground])
        let cancelAction = UNNotificationAction(identifier: "foodpin.cancel", title: "Later", options: [])
        let category = UNNotificationCategory(identifier: categoryIdentifer, actions: [makeReservationAction, cancelAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        content.categoryIdentifier = categoryIdentifer

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "rests", content: content, trigger: trigger)
        
        //schedule notifications
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
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
    
    override func setupCollectionViews()  {
        
        collectionView.backgroundColor = .white
        collectionView.register(RestaurantCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func saveData()  {
        do {
            try context.save()
            print("saved")
        } catch let err {
            print(err.localizedDescription)
        }
//        collectionView.reloadData()
    }
    
    func fetchData()  {
        let request:NSFetchRequest = Restaurant.fetchRequest()
        
        do {
           restaurantsArray =  try context.fetch(request)
            collectionView.reloadData()
        } catch let err {
            print(err.localizedDescription)
        }
        collectionView.reloadData()
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
        filterRestaurantsArray = restaurantsArray.filter({$0.name?.lowercased().range(of: text )  != nil || $0.location?.lowercased().range(of: text )  != nil})
    }
    
    func createAlert(index:Int)  {
        
        let alert = UIAlertController(title: "Restaurant Pin".localized, message: "choose action".localized, preferredStyle: .actionSheet)
        let display = UIAlertAction(title: "Display".localized, style: .default) { [weak self] (_) in
            guard let res = self?.restaurantsArray[index] else {return}
            
            let detail = RestaurantDetailsVC(rest: res)
            //        detail.restaurant = res
            self?.navigationController?.pushViewController(detail, animated: true)
        }
        let delete = UIAlertAction(title: "Delete".localized, style: .destructive) { [weak self] (_) in
            guard let res = self?.restaurantsArray[index] else {return}
            
            context.delete(res)
            self?.restaurantsArray.remove(at: index)
            self?.saveData()
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel) { (_) in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(display)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

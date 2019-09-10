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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
        fetchData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! RestaurantCell
        let rest = restaurantsArray[indexPath.item]
        
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
        navigationItem.title = "Restaurant Pin"
//        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8509803922, green: 0.3960784314, blue: 0.2745098039, alpha: 1)

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
//       restaurantsArray = [
//        RestaurantModel(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "G/F, 72 Po Hing Fong, Sheung Wan, Hong Kong", phone: "232-923423", isVisited: false, image: #imageLiteral(resourceName: "wafflewolf")),
//        .init(name: "Homei", type: "Cafe", location: "Shop B, G/F, 22-24A Tai Ping San Street SOHO, Sheung Wan, Hong Kong", phone: "348-233423",  isVisited: false, image: #imageLiteral(resourceName: "bourkestreetbakery")),
//        .init(name: "Teakha", type: "Tea House", location: "Shop B, 18 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", phone: "354-243523",  isVisited: false, image: #imageLiteral(resourceName: "forkeerestaurant")),
//        .init(name: "Cafe loisl", type: "Austrian / Causual Drink", location: "Shop B, 20 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", phone: "453-333423",  isVisited: false, image: #imageLiteral(resourceName: "petiteoyster")),
//        .init(name: "Petite Oyster", type: "French", location: "24 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", phone: "983-284334", isVisited: false, image: #imageLiteral(resourceName: "cafelore")),
//            .init(name: "For Kee Restaurant", type: "Bakery", location: "Shop J-K., 200 Hollywood Road, SOHO, Sheung Wan, Hong Kong", phone: "232-434222", isVisited: false, image: #imageLiteral(resourceName: "homei")),
//            .init(name: "Po's Atelier", type: "Bakery", location: "G/F, 62 Po Hing Fong, Sheung Wan, Hong Kong", phone: "234-834322", isVisited: false, image: #imageLiteral(resourceName: "confessional")),
//            .init(name: "Bourke Street Backery", type: "Chocolate", location: "633 Bourke St Sydney New South Wales 2010 Surry Hills", phone: "982-434343", isVisited: false, image: #imageLiteral(resourceName: "cafeloisl")),
//            .init(name: "Haigh's Chocolate", type: "Cafe", location: "412-414 George St Sydney New South Wales", phone: "734-232323", isVisited: false, image: #imageLiteral(resourceName: "wafflewolf")),
//            .init(name: "Palomino Espresso", type: "American / Seafood", location: "Shop 1 61 York St Sydney New South Wales", phone: "872-734343", isVisited: false, image: #imageLiteral(resourceName: "wafflewolf")),
//            .init(name: "Upstate", type: "American", location: "95 1st Ave New York, NY 10003", phone: "343-233221", isVisited: false, image: #imageLiteral(resourceName: "wafflewolf")),
//            .init(name: "Traif", type: "American", location: "229 S 4th St Brooklyn, NY 11211", phone: "985-723623", isVisited: false, image: #imageLiteral(resourceName: "wafflewolf")),
//            .init(name: "Graham Avenue Meats", type: "Breakfast & Brunch", location: "445 Graham Ave Brooklyn, NY 11211", phone: "455-232345", isVisited: false, image: #imageLiteral(resourceName: "wafflewolf")),
//            .init(name: "Waffle & Wolf", type: "Coffee & Tea", location: "413 Graham Ave Brooklyn, NY 11211", phone: "434-232322", isVisited: false, image: #imageLiteral(resourceName: "wafflewolf")),
//            .init(name: "Five Leaves", type: "Coffee & Tea", location: "18 Bedford Ave Brooklyn, NY 11222", phone: "343-234553", isVisited: false, image: #imageLiteral(resourceName: "wafflewolf")),
//            .init(name: "Cafe Lore", type: "Latin American", location: "Sunset Park 4601 4th Ave Brooklyn, NY 11220", phone: "342-455433", isVisited: false, image: #imageLiteral(resourceName: "wafflewolf")),
//            .init(name: "Confessional", type: "Spanish", location: "308 E 6th St New York, NY 10003", phone: "643-332323", isVisited: false, image: #imageLiteral(resourceName: "wafflewolf")),
//            .init(name: "Barrafina", type: "Spanish", location: "54 Frith Street London W1D 4SL United Kingdom", phone: "542-343434",  isVisited: false, image: #imageLiteral(resourceName: "wafflewolf")),
//            .init(name: "Donostia", type: "Spanish", location: "10 Seymour Place London W1H 7ND United Kingdom", phone: "722-232323",  isVisited: false, image: #imageLiteral(resourceName: "wafflewolf")),
//            .init(name: "Royal Oak", type: "British", location: "2 Regency Street London SW1P 4BZ United Kingdom", phone: "343-988834",  isVisited: false, image: #imageLiteral(resourceName: "wafflewolf")),
//            .init(name: "CASK Pub and Kitchen", type: "Thai", location: "22 Charlwood Street London SW1V 2DY Pimlico", phone: "432-344050", isVisited: false, image: #imageLiteral(resourceName: "wafflewolf"))
//        ]
    }
    
  @objc  func handleAdd()  {
        let create = CreateRestaurantVC()
        navigationController?.pushViewController(create, animated: true)
    }
}


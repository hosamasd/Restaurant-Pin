//
//  RestaurantDetailsVC.swift
//  Restaurant
//
//  Created by hosam on 9/8/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailsVC: UITableViewController {
    
    let detailView = DetailStackView()
    
    lazy var mapView:MKMapView = {
       let mp = MKMapView()
        mp.delegate = self
        mp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFullMap)))
        return mp
    }()
    let restaurantImageView:UIImageView = {
        let im = UIImageView(backgroundColor: .gray)
        im.clipsToBounds = true
        im.contentMode = .scaleAspectFill
        return im
    }()
    lazy var checkedButton:UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "check").withRenderingMode(.alwaysOriginal), for: .normal)
        bt.constrainHeight(constant: 28)
        bt.constrainWidth(constant: 28)
        bt.addTarget(self, action: #selector(handleSelectItem), for: .touchUpInside)
        return bt
    }()
     let cellID = "cellID"
    let restaurant:Restaurant
    
    
    init(rest:Restaurant){
        self.restaurant = rest
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeAnnotation()
        setupTableView()
        setupNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
         tabBarController?.tabBar.isHidden = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let data = restaurant.image {
        let subView = UIView()
        subView.addSubViews(views: restaurantImageView,checkedButton)
        
        restaurantImageView.fillSuperview()
        checkedButton.anchor(top: subView.topAnchor, leading: nil, bottom: nil, trailing: subView.trailingAnchor,padding: .init(top: 8, left: 0, bottom: 0, right: 8))
       restaurantImageView.image = UIImage(data: data)
        return subView
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return mapView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 250
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 250 : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! RestaurantDetailsCell
      
        // Configure the cell...
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurant.name
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurant.type
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurant.location
        case 3:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = restaurant.phone
        case 4:
            cell.fieldLabel.text = "Been here"
            cell.valueLabel.text = (restaurant.isVisited) ? "Yes, I've been here before \(restaurant.rating ?? "")" : "No"
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func makeAnnotation()  {
        let gecoder = CLGeocoder()
        let annotation = MKPointAnnotation()
        
        gecoder.geocodeAddressString(restaurant.location ?? "" ) { (placemarks, err) in
            guard  let place = placemarks?.first?.location else {return}
           annotation.coordinate = place.coordinate
            self.mapView.addAnnotation(annotation)
            
            let region = MKCoordinateRegion(center: place.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func setupNavigationItem()  {
        navigationItem.title = restaurant.name
    }
    
    func setupTableView()  {
        tableView.backgroundColor = .white
        tableView.register(RestaurantDetailsCell.self, forCellReuseIdentifier: cellID)
//        tableView.tableFooterView = UIView()
    }
    
   @objc func handleFullMap()  {
        let fullMap = FullyFunctionalMapVC(rest: restaurant)
        
        navigationController?.pushViewController(fullMap, animated: true)
    }
    
    func saveData(rest:Restaurant)  {
        do {
            try context.save()
        } catch let err {
            print(err.localizedDescription)
        }
        tableView.reloadData()
    }
    
    @objc func handleSelectItem()  {
        let review = ReviewVC(rest: restaurant)
        review.delgate = self
        present(review, animated: true)
    
    }
}

extension RestaurantDetailsVC: MKMapViewDelegate,ReviewVCProtocol{
    func getRating(rate: String) {
        restaurant.rating = rate
       saveData(rest: restaurant)
    }
    
    
}

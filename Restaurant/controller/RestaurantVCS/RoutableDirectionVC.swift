//
//  RoutableDirectionVC.swift
//  Restaurant
//
//  Created by hosam on 9/14/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import MapKit

class RoutableDirectionVC: BaseTableVC {
    
    
    let cellID = "cellID"
    
    
    var routeSetps = [MKRoute.Step]()
    init(routes:[MKRoute.Step]) {
        self.routeSetps = routes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return routeSetps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        
        // Configure the cell...
        cell.textLabel?.text = routeSetps[indexPath.row].instructions
        
        return cell
    }
    
    override func setupNavigationItems()  {
        navigationItem.title = "Route Details"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDismiss))
    }
    
    override func setuptableViews()  {
        
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
  @objc  func handleDismiss()  {
        dismiss(animated: true)
    }
}

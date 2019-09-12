//
//  Extensions.swift
//  Restaurant
//
//  Created by hosam on 9/12/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlertFields()  {
        let alert = UIAlertController(title: "Alert", message: "all fields are required to be filled in", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
     func showAlert(title:String, message: String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
   
}

//
//  CreateRestaurantVC.swift
//  Restaurant
//
//  Created by hosam on 9/9/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import Photos


class CreateRestaurantVC: UITableViewController {
    let cellID = "cellID"
    let secondCelllID = "secondCelllID"
    let thirdCelllID = "CelllID"
    
    var name,typle,location,phone:String?
    var isBeenVisited:Bool?
    
    var images:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationItems()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 250 : 120
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PickedPhototCell
            cell.handleImageChoosed = {
                self.setupImagePicker()
            }
            return cell
        }else if indexPath.row == 5  {
           let cell = tableView.dequeueReusableCell(withIdentifier: thirdCelllID, for: indexPath) as! CreatQuestCell
            cell.fieldLabel.text = "Have Youy Been Here?"
            cell.beenVisited = { v in
                self.isBeenVisited = v
            }
            return cell
        }else {
          let  cell = tableView.dequeueReusableCell(withIdentifier: secondCelllID, for: indexPath) as! CreateFieldsCell
          
//            cell.valueLabel.addTarget(self, action: #selector(handelText), for: .editingChanged)
            // Configure the cell...
            switch indexPath.row {
            case 1:
                cell.fieldLabel.text = "Name"
                 cell.valueLabel.placeholder = " enter your Name"
            case 2:
                cell.fieldLabel.text = "Type"
                cell.valueLabel.placeholder = " enter your Type"
            case 3:
                cell.fieldLabel.text = "Location"
                 cell.valueLabel.placeholder = " enter your Location"
            case 4:
                cell.fieldLabel.text = "Phone"
                 cell.valueLabel.placeholder = " enter your Phone"
            
            default:
                cell.fieldLabel.text = ""
                cell.valueLabel.text = ""
            }
            return cell
        }
        
    }
    
    func setupNavigationItems()  {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handelCancel))
         navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handelSave))
    }
    
    func setupImagePicker()  {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func setupTableView()  {
         tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        tableView.backgroundColor = .gray
        tableView.register(PickedPhototCell.self, forCellReuseIdentifier: cellID)
        tableView.register(CreateFieldsCell.self, forCellReuseIdentifier: secondCelllID)
        tableView.register(CreatQuestCell.self, forCellReuseIdentifier: thirdCelllID)
    }
    
    func checkData()  {
        let indexpathForName = IndexPath(row: 1, section: 0); let indexpathForType = IndexPath(row: 2, section: 0); let indexpathForLocation = IndexPath(row: 3, section: 0)
        let indexpathForPhone = IndexPath(row: 4, section: 0)
        
        let nameCell = tableView.cellForRow(at: indexpathForName) as! CreateFieldsCell
        let locationCell = tableView.cellForRow(at: indexpathForLocation) as! CreateFieldsCell
        
        let phoneCell =  tableView.cellForRow(at: indexpathForPhone) as! CreateFieldsCell
        let typeCell =  tableView.cellForRow(at: indexpathForType) as! CreateFieldsCell
        
       guard let names = nameCell.valueLabel.text,
        let phones = phoneCell.valueLabel.text,
        let types = typeCell.valueLabel.text,  let locations = locationCell.valueLabel.text
        else {showAlert()  ; return }
       
        
            name = names; phone = phones ; location = locations ; typle = types
        print(isBeenVisited)
    }
    
   @objc func handelCancel()  {
        navigationController?.popViewController(animated: true)
    }
    
   @objc func handelSave()  {
        checkData()
    }
}

extension CreateRestaurantVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0) ) as! PickedPhototCell
        if let img = info[.originalImage] as? UIImage {
            
                cell.restaurantImageView.image = img
            self.images = img
//             cell.restaurantImageView.fillSuperview()
            
        }
        if let img = info[.editedImage] as? UIImage {
            cell.restaurantImageView.image = img
            self.images = img
//            cell.restaurantImageView.fillSuperview()
        }
        
        dismiss(animated: true)
    }

    func showAlert()  {
        let alert = UIAlertController(title: "Alert", message: "all fields are required to be filled in", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension CreateRestaurantVC: UITextFieldDelegate {
    
    
    
  
}

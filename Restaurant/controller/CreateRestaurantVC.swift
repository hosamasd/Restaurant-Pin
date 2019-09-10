//
//  CreateRestaurantVC.swift
//  Restaurant
//
//  Created by hosam on 9/9/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import CoreData

class CreateRestaurantVC: UITableViewController {
    let cellID = "cellID"
    let secondCelllID = "secondCelllID"
    let thirdCelllID = "CelllID"
    
    var name,typle,location,phone:String?
    var isBeenVisited:Bool = false
    
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
                cell.valueLabel.keyboardType = .phonePad
                 cell.valueLabel.placeholder = " enter your Phone"
            
            default:
                cell.fieldLabel.text = ""
                cell.valueLabel.text = ""
            }
            return cell
        }
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dismissKeyboard()
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
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
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        tableView.keyboardDismissMode = .interactive
         tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        tableView.backgroundColor = .gray
        tableView.register(PickedPhototCell.self, forCellReuseIdentifier: cellID)
        tableView.register(CreateFieldsCell.self, forCellReuseIdentifier: secondCelllID)
        tableView.register(CreatQuestCell.self, forCellReuseIdentifier: thirdCelllID)
    }
    
    func checkData()  {
        var indexs:[String] = [String]()
        
        for x in 1...4 {
            let index = IndexPath(row: x, section: 0)
            let cell = tableView.cellForRow(at: index) as! CreateFieldsCell
           guard let val = cell.valueLabel.text, !val.isEmpty  else {showAlert()  ; return }
            indexs.append(val)
        }
        
        saveInDatabase(index: indexs, visited: isBeenVisited, image: self.images ?? #imageLiteral(resourceName: "photoalbum"))
        print(indexs)
    }
    
    func saveInDatabase(index: [String],visited:Bool,image:UIImage)  {
        let rest = Restaurant(context: context)
        rest.name = index[0]
        rest.type = index[1]
        rest.location = index[2]
        rest.phone = index[3]
        rest.isVisited = visited
        let data = image.pngData()
        rest.image = data
        
        do {
            try context.save()
            print("saved")
        } catch let err {
            print(err.localizedDescription)
        }
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

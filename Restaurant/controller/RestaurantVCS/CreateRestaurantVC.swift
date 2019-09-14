//
//  CreateRestaurantVC.swift
//  Restaurant
//
//  Created by hosam on 9/9/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import CoreData

class CreateRestaurantVC: BaseTableVC {
    let cellID = "cellID"
    let secondCelllID = "secondCelllID"
    let thirdCelllID = "CelllID"
    
    let placeholdersText = [" enter your Name"," enter your Type"," enter your Location"," enter your Phone"]
    
    var name,typle,location,phone:String?
    var isBeenVisited:Bool = false
    
    var images:UIImage?
    
    
    
    
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
            cell.fieldLabel.text = "Have You Been Here?"
            cell.beenVisited = { v in
                self.isBeenVisited = v
            }
            return cell
        }else {
            let  cell = tableView.dequeueReusableCell(withIdentifier: secondCelllID, for: indexPath) as! CreateFieldsCell
            
            // Configure the cell...
            switch indexPath.row {
            case 1:
                cell.fieldLabel.text = "Name"
                cell.valueLabel.placeholder = placeholdersText[0]
            case 2:
                cell.fieldLabel.text = "Type"
                cell.valueLabel.placeholder = placeholdersText[1]
            case 3:
                cell.fieldLabel.text = "Location"
                cell.valueLabel.placeholder = placeholdersText[2]
            case 4:
                cell.fieldLabel.text = "Phone"
                cell.valueLabel.keyboardType = .phonePad
                cell.valueLabel.placeholder = placeholdersText[3]
                
            default:
                cell.fieldLabel.text = ""
                cell.valueLabel.text = ""
            }
            return cell
        }
        
    }
    
    //MARK: User methods
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dismissKeyboard()
    }
    
    
    
    override func setupNavigationItems()  {
        navigationItem.title = "New Restaurant"
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
    
    override func setuptableViews() {
        
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
            guard let val = cell.valueLabel.text, !val.isEmpty  else {showAlertFields()  ; return }
            indexs.append(val)
        }
        
        saveInDatabase(index: indexs, visited: isBeenVisited, image: self.images ?? #imageLiteral(resourceName: "photoalbum"))
    }
    
    func saveInDatabase(index: [String],visited:Bool,image:UIImage)  {
        
        CoreDataServices.shared.createNewRestaruant(index: index, visited: visited, image: image) { (err) in
            if let err = err {
                print(err.localizedDescription);return
            }
        }
    }
    
    func makeDefaultValues()  {
        
        view.endEditing(true)
        isBeenVisited = false
        for x in 1...4 {
            let index = IndexPath(row: x, section: 0)
            let cell = tableView.cellForRow(at: index) as! CreateFieldsCell
            cell.valueLabel.text = ""
            cell.valueLabel.placeholder = placeholdersText[x - 1]
        }
        let index = IndexPath(row: 5, section: 0)
        let cell = tableView.cellForRow(at: index) as! CreatQuestCell
        cell.handleNoTapped()
        
        let indexx = IndexPath(row: 0, section: 0)
        let cells = tableView.cellForRow(at: indexx) as! PickedPhototCell
        cells.restaurantImageView.image = #imageLiteral(resourceName: "photoalbum")
    }
    
    //TODO: -handle methods
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func handelCancel()  {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handelSave()  {
        checkData()
        makeDefaultValues()
    }
}

//MARK: -extensions

extension CreateRestaurantVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0) ) as! PickedPhototCell
        if let img = info[.originalImage] as? UIImage {
            
            cell.restaurantImageView.image = img
            self.images = img
            
        }
        if let img = info[.editedImage] as? UIImage { //for image editing
            cell.restaurantImageView.image = img
            self.images = img
        }
        
        dismiss(animated: true)
    }
    
    
}

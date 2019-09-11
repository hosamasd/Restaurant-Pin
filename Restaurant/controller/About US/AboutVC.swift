//
//  MoreVC.swift
//  Restaurant
//
//  Created by hosam on 9/11/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import SafariServices
import MOLH

class AboutVC: UITableViewController {
    let cellID = "cellID"
    
    let img:UIImageView =  {
        let img =  UIImageView(image: #imageLiteral(resourceName: "pict"))
    img.constrainWidth(constant: 60)
    img.constrainHeight(constant: 60)
    img.layer.cornerRadius = 30
    img.contentMode = .scaleAspectFill
    img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
       return img
    }()
     let label = UILabel(text: "Built By \n HOSAM".localized, font: .systemFont(ofSize: 18), textColor: .black,textAlignment: .left,numberOfLines: 2)
    var sectionTitles = ["","Leave Feedback", "Follow Us"," Language"]
    var sectionContent = [["",""],["Rate us on App Store", "Tell us your feedback"],
                          ["GitHub", "Facebook", "LinkedIn"],["change Language"]]
    var links = ["https://github.com/hosamasd?tab=repositories", "https://www.facebook.com/hosammohamedasd", "https://www.linkedin.com/in/hosam-mohamed-425a83119/"]
    
    lazy var headerView:UIView = {
       let v = UIView(backgroundColor: .white)
        v.addSubViews(views: img, label)
        
        img.centerInSuperview()
        label.anchor(top: img.topAnchor, leading: img.trailingAnchor, bottom: nil, trailing: nil,padding: .init(top: 8, left: 8, bottom: 0, right: 0))
       return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    
   
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        return section == 0 ? headerView : nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
           return
        case 1 :
                if indexPath.row == 0 {
                    if let url = URL(string: "http://www.apple.com/itunes/charts/paid-apps/") {
                        UIApplication.shared.open(url)
                    }
                }else  {
                    let feed = FeedbackVC()
                    navigationController?.pushViewController(feed, animated: true)
            }
            
        case 2 :
            if let url = URL(string: links[indexPath.row]){
                let safari = SFSafariViewController(url: url)
                present(safari, animated: true)
            }
            
        case 3 :
            //reset language
            MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
            MOLH.reset()
        default:
        return
        }
    
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : sectionTitles[section]
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 250 : 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 :  sectionContent[section ].count
//        return section == 0 ? 0 : section == 1  ? 2 :  3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AboutCell
        
        if MOLHLanguage.isRTLLanguage() {
            cell.fieldLabel.textAlignment = .right
        }
        
        if indexPath.section == 0 {
            return UITableViewCell()
        }else  if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.fieldLabel.text = "Rate Us On App Store".localized
            }else {
                cell.fieldLabel.text = "Tell Us On Your Feedback".localized
            }
        }else if indexPath.section == 3 {
             cell.fieldLabel.text = "English".localized
        } else  {
            if indexPath.row == 0 {
                cell.fieldLabel.text = "GitHub".localized
            }else if indexPath.row == 1 {
                cell.fieldLabel.text = "Facebook".localized
            } else {
                cell.fieldLabel.text = "LinkedIn".localized
            }
//
            
        }
        
        print(cell.fieldLabel.text)
//        cell.backgroundColor = .red
        return cell
    }
    
    func setupViews()  {
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
//       tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        tableView.register(AboutCell.self, forCellReuseIdentifier: cellID)
    }
}

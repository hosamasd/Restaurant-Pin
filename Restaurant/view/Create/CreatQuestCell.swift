//
//  CreatQuestCell.swift
//  Restaurant
//
//  Created by hosam on 9/9/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class CreatQuestCell: BaseCell {
    
    let fieldLabel:UILabel = {
        let la = UILabel(text: "name", font: .systemFont(ofSize: 25), textColor: .black)
        la.constrainHeight(constant: 40)
        //        la.constrainWidth(constant: 150)
        return la
    }()
    lazy var yesButton :UIButton = {
        let bt = UIButton(title: "Yes", titleColor: .white, font: .systemFont(ofSize: 30), backgroundColor: .gray, target: self, action: #selector(handleYesTapped))
        //        bt.constrainHeight(constant: 40)
        bt.constrainWidth(constant: 80)
        return bt
    }()
    lazy var noButton : UIButton = {
        let bt = UIButton(title: "No", titleColor: .white, font: .systemFont(ofSize: 30), backgroundColor: .red, target: self, action: #selector(handleNoTapped))
        //        bt.constrainHeight(constant: 40)
        bt.constrainWidth(constant: 80)
        return bt
    }()
    var beenVisited:((Bool)->())?
    
    
    override func setupViews()  {
        backgroundColor = .white
        
        stack(fieldLabel,hstack(yesButton,noButton,UIView(), spacing: 10), spacing: 8).withMargins(.init(top: 8, left: 16, bottom: 8, right: 16))
    }
    
    
    @objc  func handleYesTapped()  {
       beenVisited?(true)
        yesButton.backgroundColor = .red
        noButton.backgroundColor = .gray
    }
    
    @objc  func handleNoTapped()  {
        beenVisited?(false)
        yesButton.backgroundColor = .gray
        noButton.backgroundColor = .red
    }
}

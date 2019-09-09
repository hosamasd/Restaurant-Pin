//
//  CreateFieldsCell.swift
//  Restaurant
//
//  Created by hosam on 9/9/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class CreateFieldsCell: BaseCell {
    
    
    let fieldLabel:UILabel = {
        let la = UILabel(text: "name", font: .systemFont(ofSize: 25), textColor: .black)
        la.constrainHeight(constant: 40)
        
//        la.constrainWidth(constant: 150)
        return la
    }()
    let valueLabel:UITextField = {
        let la = UITextField()
//        la.constrainHeight(constant: 40)
//        la.constrainWidth(constant: 150)
        return la
    }()
    
    override func setupViews()  {
        backgroundColor = .white
            stack(fieldLabel,valueLabel, spacing: 8).withMargins(.init(top: 8, left: 16, bottom: 8, right: 16))
       
    }
    
    
}

//
//  AboutCell.swift
//  Restaurant
//
//  Created by hosam on 9/11/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class AboutCell: BaseCell {
    
    let fieldLabel:UILabel = {
        let la = UILabel(text: "", font: .systemFont(ofSize: 16), textColor: .black)
//        la.constrainHeight(constant: 6)
        
        //        la.constrainWidth(constant: 150)
        return la
    }()
    
    override func setupViews()  {
        backgroundColor = .white
       stack(fieldLabel).withMargins(.init(top: 0, left: 20, bottom: 0, right: 16))
        
    }
}

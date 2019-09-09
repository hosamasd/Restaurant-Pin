//
//  RestaurantDetailsCell.swift
//  Restaurant
//
//  Created by hosam on 9/8/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class RestaurantDetailsCell: BaseCell {
    
    let fieldLabel:UILabel = {
       let la = UILabel(text: "name", font: .systemFont(ofSize: 25), textColor: .black)
        la.constrainHeight(constant: 60)
        la.constrainWidth(constant: 150)
        return la
    }()
    let valueLabel = UILabel(text: "location", font: .systemFont(ofSize: 16), textColor: .gray,textAlignment: .left,numberOfLines: 2)
 
   
    
    let seperatorView:UIView = {
        let vi = UIView(backgroundColor: UIColor(white: 0.8, alpha: 1))
        vi.constrainHeight(constant: 0.5)
        return vi
    }()
    
   
    
    override func setupViews()  {
        backgroundColor = .white
        addSubview(seperatorView)
        hstack(fieldLabel,valueLabel, spacing: 8).withMargins(.init(top: 0, left: 16, bottom: 0, right: 8))
        
        seperatorView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
  
}

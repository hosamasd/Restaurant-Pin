//
//  PickedPhototCell.swift
//  Restaurant
//
//  Created by hosam on 9/9/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class PickedPhototCell: BaseCell {
    
    lazy var restaurantImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "photoalbum"))
        im.layer.cornerRadius = 60
        im.constrainWidth(constant: 120)
        im.constrainHeight(constant: 120)
        im.clipsToBounds = true
        im.contentMode = .scaleAspectFill
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePickedImage)))
        im.isUserInteractionEnabled = true
        return im
    }()
    var handleImageChoosed:(()->())?
    
    
    override func setupViews()  {
        backgroundColor = .lightGray
        addSubview(restaurantImageView)
        
        restaurantImageView.centerInSuperview()
    }
    
  @objc  func handlePickedImage()  {
    handleImageChoosed?()
    }
}

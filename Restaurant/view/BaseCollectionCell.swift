//
//  BaseCollectionCell.swift
//  Restaurant
//
//  Created by hosam on 9/12/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class BaseCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
       
    }
}

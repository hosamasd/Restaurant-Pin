//
//  PageCell.swift
//  Restaurant
//
//  Created by hosam on 9/10/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    var page:PageModel! {
        didSet{
            pageImageView.image = UIImage(named: page.imageName)
            pageTitleLabel.text = page.title
            pageDescriptionLabel.text = page.message
        }
    }
    
    
    let pageImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "royaloak"))
        im.layer.cornerRadius = 12
        im.constrainWidth(constant: 120)
        im.constrainHeight(constant: 200)
        im.clipsToBounds = true
        im.contentMode = .scaleAspectFill
        return im
    }()
    
    let pageTitleLabel:UILabel = {
       let la = UILabel(text: "name", font: .systemFont(ofSize: 25), textColor: .black,textAlignment: .center)
        la.constrainHeight(constant: 40)
        return la
    }()
    let pageDescriptionLabel = UILabel(text: "location \n fdgfd \n dfgdf", font: .systemFont(ofSize: 16), textColor: .gray,textAlignment: .center,numberOfLines: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        backgroundColor = #colorLiteral(red: 0.7411764706, green: 0.2274509804, blue: 0.1882352941, alpha: 1)
        
        let stacks = verticalStackView(arragedSubViews: pageTitleLabel,pageImageView,pageDescriptionLabel, spacing: 8, distribution: .fillProportionally, alignment: .center, axis: .vertical)
        addSubview(stacks)
        
        stacks.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 60, left: 64, bottom: 0, right: 64),size: .init(width: 0, height: 300))
        
    }
}

//
//  ReviewVC.swift
//  Restaurant
//
//  Created by hosam on 9/10/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

protocol ReviewVCProtocol {
    func getRating(rate:String)
}
class ReviewVC: UIViewController {
    
    var delgate:ReviewVCProtocol?
    
    lazy var backgroundImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "cafeloisl"))
        im.clipsToBounds = true
        im.contentMode = .scaleAspectFill
        return im
    }()
    lazy var closedButton:UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        bt.constrainHeight(constant: 28)
        bt.constrainWidth(constant: 32)
        bt.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return bt
    }()
    lazy var restaurantImageView:UIImageView = {
        let data = restarant.image
        let im = UIImageView(image: UIImage(data: data ?? Data()))
        im.constrainHeight(constant: 180)
        im.clipsToBounds = true
        im.contentMode = .scaleAspectFill
        return im
    }()
    let reviewLabel = UILabel(text: "You've dined here. What do you think?", font: .systemFont(ofSize: 24), textColor: .black,textAlignment: .center,numberOfLines: 2)
    
    lazy var reviewButton1 = createButtons(title: "Absolutely love it!", tag: 1)
    lazy var reviewButton2 = createButtons(title: "Good", tag: 2)
    lazy var reviewButton3 = createButtons(title: "I don't like it", tag: 3)
    var grouped:UIStackView?
    
    let restarant:Restaurant
    
    init(rest:Restaurant) {
        self.restarant = rest
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBlur()
        setupAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1, animations: {
            self.grouped?.transform = CGAffineTransform.identity
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            
            self.closedButton.transform = CGAffineTransform.identity
            
        })
        
    }
    
    //MARK: -user methods
    
    fileprivate func setupViews()  {
        reviewLabel.constrainHeight(constant: 60)
        reviewLabel.backgroundColor = .gray
        grouped =   view.verticalStackView(arragedSubViews: restaurantImageView,reviewLabel,reviewButton1,reviewButton2,reviewButton3, spacing: 8, distribution: .fillProportionally, axis: .vertical)
        view.backgroundColor = .white
        view.addSubViews(views: backgroundImageView,grouped ?? UIStackView() ,closedButton)
        
        backgroundImageView.fillSuperview()
        grouped?.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 60, left: 32, bottom: 0, right: 32))
        closedButton.anchor(top: grouped?.topAnchor, leading: grouped?.trailingAnchor, bottom: nil, trailing: nil,padding: .init(top: -24, left: -8, bottom: 0, right: 0))
    }
    
    
    
    fileprivate  func createButtons(title:String,tag:Int) -> UIButton {
        let  bt = UIButton(title: title, titleColor: .white, font: .systemFont(ofSize: 16), backgroundColor: .orange, target: self, action: #selector(handleChossen))
        bt.tag = tag
        bt.layer.cornerRadius = 8
        bt.constrainHeight(constant: 40)
        return bt
    }
    
    fileprivate  func setupBlur()  {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
    }
    
    fileprivate  func setupAnimation()  {
        let scaleTransform = CGAffineTransform.init(scaleX: 0, y: 0)
        let translateTransform = CGAffineTransform.init(translationX: 0, y: -1000)
        let combineTransform = scaleTransform.concatenating(translateTransform)
        grouped?.transform = combineTransform
        
        // Solution to Exercise #2 - Start here
        closedButton.transform = CGAffineTransform.init(translationX: 1000, y: 0)
    }
    
    //TODO: -handle methods
    
    @objc fileprivate func handleClose()  {
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleChossen(sender:UIButton)  {
        guard let text = sender.titleLabel?.text  else { return  }
        switch sender.tag {
        case 1,2,3:
            delgate?.getRating(rate:text )
        default:
            return
        }
        dismiss(animated: true, completion: nil)
    }
}

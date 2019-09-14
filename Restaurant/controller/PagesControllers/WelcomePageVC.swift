//
//  WelcomePageVC.swift
//  Restaurant
//
//  Created by hosam on 9/10/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class WelcomePageVC: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
  
    
    let cellId = "cellId"
    var currentPage:Int = 0
    
    let pages: [PageModel] = {
        
        
        let firstPage = PageModel(title: "Personalize", message: "Pin your favorite restaurants and create your own food guide", imageName: "foodpin-intro-1")
        
        let secondPage = PageModel(title: "Locate", message: "Search and locate your favourite restaurant on Maps", imageName: "foodpin-intro-2")
        
        let thirdPage = PageModel(title: "Discover", message: "Find restaurants pinned by your friends and other foodies around the world", imageName: "foodpin-intro-3")
        
        return [firstPage, secondPage, thirdPage]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = currentPage
        pc.pageIndicatorTintColor = #colorLiteral(red: 0.7764705882, green: 0.3921568627, blue: 0.3490196078, alpha: 1)
        pc.currentPageIndicatorTintColor = .white
        pc.numberOfPages = self.pages.count
        return pc
    }()
    
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.constrainHeight(constant: 50)
        button.constrainWidth(constant: 60)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupBottomControls()
       
//        observeKeyboardNotifications()
        
        view.addSubViews(views: collectionView,pageControl,nextButton)
       pageControl.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 40))
       nextButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 16))
        
         setupCollectionView()
    
        collectionView.fillSuperview()
        
       
    }
    
    
     var z:CGFloat = 0.0
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
       
        let x = targetContentOffset.pointee.x
        if z > x {
            currentPage = max(pageControl.currentPage - 1, 0)
             nextButton.setTitle("NEXT", for: .normal)
        }else {
       currentPage += 1
        if currentPage >= 2 {
            nextButton.setTitle("DONE", for: .normal)
            nextButton.addTarget(self, action: #selector(handleNextVC), for: .touchUpInside)
        }else {
            nextButton.setTitle("NEXT", for: .normal)
            
        }
        
        }
        
        pageControl.currentPage = Int(x / view.frame.width)
        z = x
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count 
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PageCell
       
        let page = pages[indexPath.row]
        
        cell.page = page
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    fileprivate func setupBottomControls() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [pageControl, nextButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        
        view.addSubview(bottomControlsStackView)
        
        bottomControlsStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 50))
    }
    
    func setupCollectionView()  {
        collectionView?.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    @objc func handleNext(sender:UIButton)  {
        currentPage += 1
        if currentPage >= 2 {
            sender.setTitle("DONE", for: .normal)
            sender.addTarget(self, action: #selector(handleNextVC), for: .touchUpInside)
        }else {
sender.setTitle("NEXT", for: .normal)
        
        
        }
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
   @objc func handleNextVC()  {
    UserDefaults.standard.set(true, forKey: "passIntro")
    
        let main = MainTabBarVC()
   
    present(main, animated: true)
    
    }
}


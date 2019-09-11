//
//  FeedbackVC.swift
//  Restaurant
//
//  Created by hosam on 9/11/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import WebKit
class FeedbackVC: UIViewController {
    
    lazy var webView:WKWebView = {
       let w = WKWebView()
        
        return w
    }()
    
    override func loadView() {
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "http://www.appcoda.com/contact".toSecrueHttps()) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

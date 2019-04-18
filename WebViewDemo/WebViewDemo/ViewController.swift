//
//  ViewController.swift
//  WebViewDemo
//
//  Created by Tran Van Hung on 4/17/19.
//  Copyright © 2019 hungtv. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webViewDemo: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let url = URL(string: "http://app.dovietdung.com/")
        let request = URLRequest(url: url!)
        webViewDemo.load(request)
    }
}


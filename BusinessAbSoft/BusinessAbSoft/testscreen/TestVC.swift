//
//  TestVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 10/9/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit

class TestVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var navigationItemTest: UINavigationItem!
    
    var menuNameArray:Array = [String]()
    var imageIconArray:Array = [UIImage]()
 
    @IBOutlet weak var tbView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuNameArray = ["Home",
                         "Thông tin phiên bản",
                         "Button Bar",
                         "Charts",
                         "Test"
        ]
        
        imageIconArray = [UIImage(named:"ic_account_circle")!,
                          UIImage(named:"ic_settings")!,
                          UIImage(named:"ic_settings")!,
                          UIImage(named:"ic_settings")!,
                          UIImage(named:"ic_power_settings_new")!
        ]
        
        tbView.tableFooterView = UIView()
        tbView.delegate = self
        tbView.dataSource = self
        tbView.register(UINib(nibName: "PostCell", bundle: Bundle.main), forCellReuseIdentifier: "PostCell")
    }
    
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell,
            let data = DataProvider.sharedInstance.postsData.object(at: indexPath.row) as? NSDictionary else { return PostCell() }
        
        cell.configureWithData(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNameArray.count
    }
}

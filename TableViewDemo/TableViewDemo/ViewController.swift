//
//  ViewController.swift
//  TableViewDemo
//
//  Created by Vtsoft2 on 11/30/18.
//  Copyright © 2018 hungtv64. All rights reserved.
//

import UIKit

let AUTO_ROW_HEIGHT = "Auto row height"
let EXTEND_HEADER_VIEW = "Extend header view"

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuTableView: UITableView!
    
    var menus:[String] = [AUTO_ROW_HEIGHT,
                          EXTEND_HEADER_VIEW,
                          "Test 1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        menuTableView.dataSource = self
        menuTableView.delegate = self
        
        self.navigationItem.title = "Main menu"
        menuTableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! SimpleCell
        cell.nameLB.text = menus[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //no code
        let menuContent = menus[indexPath.row]
        switch menuContent {
        case AUTO_ROW_HEIGHT:
            let vc = AutoHeightRowVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case EXTEND_HEADER_VIEW:
            let vc = AutoHeightRowVC()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}


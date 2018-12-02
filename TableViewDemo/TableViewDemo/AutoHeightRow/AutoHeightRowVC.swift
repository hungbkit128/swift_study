//
//  AutoHeightRowVC.swift
//  TableViewDemo
//
//  Created by Vtsoft2 on 12/1/18.
//  Copyright © 2018 hungtv64. All rights reserved.
//

import UIKit

class AutoHeightRowVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var names:[String] = ["tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung ",
                          "tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung ",
                          "tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung ",
                          "tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung ",
                          "tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung ",
                          "tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung ",
                          "tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung ",
                          "tran van hung tran van hung tran van hung tran van hung tran van hung tran van hung "]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: "AutoHeightCell", bundle: Bundle.main), forCellReuseIdentifier: "AutoHeightCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 600
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutoHeightCell", for: indexPath) as! AutoHeightCell
        cell.nameLB.text = names[indexPath.row]
        return cell
    }
}

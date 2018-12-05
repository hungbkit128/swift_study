//
//  HisTransListVC.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 12/1/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit

class HisTransListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var listHisTrans = [ApproveHistoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "HisTransCell", bundle: Bundle.main), forCellReuseIdentifier: "HisTransCell")
        self.tableView.allowsSelection = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listHisTrans.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = listHisTrans[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HisTransCell") as! HisTransCell
        cell.binData(model)
        return cell
    }
}

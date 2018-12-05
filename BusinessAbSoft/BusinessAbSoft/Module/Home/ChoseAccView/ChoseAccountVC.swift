//
//  ChoseAccountVC.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/21/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit

class ChoseAccountVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var selectAllBT: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var accTableView: UITableView!
    
    var listFilter:[AccountApproveModel] = []
    var listSelected:[AccountApproveModel] = []
    var listAcc:[AccountApproveModel] = []
    
    var homeService:HomeService = HomeService()
    var searchActive : Bool = false
    var isSelectAll : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.accTableView.register(UINib(nibName: "AccountCell", bundle: Bundle.main), forCellReuseIdentifier: "AccountCell")
        
        homeService.getUserApprove() {
            (listResult: [AccountApproveModel], error: NSError?) in
            
            if error == nil {
                self.listAcc = listResult
                self.listFilter = listResult
                self.accTableView.reloadData()
            } else {
                UiUtils.showAlert(title: (error?.localizedDescription)!, viewController: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func allBTAction(_ sender: Any) {
        isSelectAll = !isSelectAll
        if isSelectAll {
            for item in listAcc {
                item.isSelected = true
            }
            selectAllBT.setTitle("BỎ CHỌN", for: .normal)
        } else {
            for item in listAcc {
                item.isSelected = false
            }
            selectAllBT.setTitle("TẤT CẢ", for: .normal)
        }
        self.accTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        listFilter = listAcc.filter({ (item) -> Bool in
            let tmp: AccountApproveModel = item as AccountApproveModel
            let name = tmp.userName?.lowercased() ?? ""
            return name.contains(searchText.lowercased())
        })
        
        if searchText.isEmpty {
            searchActive = false
        } else {
            searchActive = true
        }
        
        self.accTableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return listFilter.count
        }
        return listAcc.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = accTableView.dequeueReusableCell(withIdentifier: "AccountCell") as! AccountCell;
        if(searchActive) {
            cell.bindModelData(listFilter[indexPath.row])
        } else {
            cell.bindModelData(listAcc[indexPath.row])
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cellSelect = tableView.cellForRow(at:indexPath) as! AccountCell
        var modelSelect:AccountApproveModel
        if(searchActive) {
            modelSelect = listFilter[indexPath.row]
        } else {
            modelSelect = listAcc[indexPath.row]
        }
        modelSelect.isSelected = !modelSelect.isSelected
            
        accTableView.reloadData()
    }
}

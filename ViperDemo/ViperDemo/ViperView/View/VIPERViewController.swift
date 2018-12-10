//
// Created by AUTHOR
// Copyright (c) YEAR AUTHOR. All rights reserved.
//

import Foundation
import UIKit

class VIPERViewController: UIViewController {
    
    var presenter: VIPERViewControllerOutput?
    weak var viewModel: VIPERViewModelOutput?
    
    @IBOutlet weak var listTableIView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    func setUpView() {
        self.navigationItem.title = viewModel?.getTitle()
        let rightbtn = UIBarButtonItem(barButtonSystemItem: .add,target: self, action: #selector(self.showFormAddInfo))
        self.navigationItem.rightBarButtonItem = rightbtn
        
        self.listTableIView.delegate = self
        self.listTableIView.dataSource = self
        self.listTableIView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc func showFormAddInfo() {
        // TO DO
        presenter?.addActionOutput()
    }
}

extension VIPERViewController: VIPERViewControllerInput {
    func doRefreshView() {
        self.listTableIView.reloadData()
    }
}

extension VIPERViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension VIPERViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel?.getNumberOfSection() {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell"), let item = viewModel?.getItemAtIndexPath(indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = "\(item.value)"
        return cell
    }
    
}

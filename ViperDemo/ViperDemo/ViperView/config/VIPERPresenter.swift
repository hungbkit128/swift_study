//
// Created by AUTHOR
// Copyright (c) YEAR AUTHOR. All rights reserved.
//

import Foundation
import UIKit

// Presenter: Nhận kết quả từ interactor và nhận user input hoặc request tới interactor
class VIPERPresenter: NSObject
{
    weak var view: VIPERViewControllerInput?
    var viewModel: VIPERViewModel?
    var interactor: VIPERInteractorInput?
    var wireFrame: VIPERWireFrameInput?
}

// MARK:
// MARK: VIEW
extension VIPERPresenter: VIPERViewControllerOutput {
    
    func viewDidLoad() {
        interactor?.getData()
    }
    
    func viewWillAppear() {
        
    }
    
    func addActionOutput() {
        wireFrame?.showFormAdd()
    }
    
}

// MARK:
// MARK: INTERACTOR
extension VIPERPresenter: VIPERInteractorOutput {
    
    func didGetData(_ list: [ItemModel]) {
        viewModel?.updateListItem(list)
        view?.doRefreshView()
    }
}

// MARK:
// MARK: WIRE FRAME
extension VIPERPresenter: VIPERWireFrameOutput {
    func didGetText(_ text:String) {
        // TO DO
    }
}

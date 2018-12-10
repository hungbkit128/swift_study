//
// Created by AUTHOR
// Copyright (c) YEAR AUTHOR. All rights reserved.
//

import Foundation

class VIPERWireFrame: NSObject {
    weak var viewController: VIPERViewController?
    weak var presenter: VIPERWireFrameOutput?
}

extension VIPERWireFrame: VIPERWireFrameInput {
    func showFormAdd() {
        if let viewAdd = viewController?.storyboard?.instantiateViewController(withIdentifier: "viewController2") as? AddViewController {
            viewAdd.completionHandler = { ( result: String) in
                print(result)
            }
            viewAdd.delegate = self
            viewController?.present(viewAdd, animated: true)
        }
    }
}

extension VIPERWireFrame: AddViewControllerDelegate {
    func didButtonPress(_ text: String) {
        presenter?.didGetText(text)
    }
}


//
// Created by AUTHOR
// Copyright (c) YEAR AUTHOR. All rights reserved.
//

import UIKit

/*
 Lớp này định nghĩa hàm khởi tạo view và các protocol
 */
class VIPERConfigure: NSObject {

    class func viewController() -> VIPERViewController {

        let storyboard = UIStoryboard(name: "VIPERViewController", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "VIPERViewController") as! VIPERViewController
        
        let presenter = VIPERPresenter()
        let viewModel = VIPERViewModel()
        let wireFrame = VIPERWireFrame()
        let interactor = VIPERInteractor()

        presenter.viewModel = viewModel
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        presenter.view = view

        wireFrame.viewController = view
        view.presenter = presenter
        view.viewModel = viewModel

        interactor.presenter = presenter
        wireFrame.presenter = presenter
        return view
    }
}

//===================== INPUT ============================
protocol VIPERViewModelInput: class {
    func updateListItem(_ list: [ItemModel])
}
protocol VIPERViewModelOutput: class {
    func getTitle() -> String?
    func getNumberOfSection() -> Int
    func getItemAtIndexPath(_ index: Int) -> ItemModel
}

//===================== INPUT ============================
protocol VIPERViewControllerInput: class {
    func doRefreshView()
}
protocol VIPERViewControllerOutput: class {
    func viewDidLoad()
    func viewWillAppear()
    func addActionOutput()
}

//==================== INTERACTOR =======================
// 2 protocol input, output làm nhiệm vụ liên lạc giữa presenter và interactor
/*
 Interactor chứa bussiness logic ,
 công việc thực hiện trên Interactor hoàn toàn không liên quan gì tới UI,
 và chỉ tương tác với dữ liệu. Do đó, chúng ta cũng có thể dễ dàng áp dụng
 TDD ( Test Driven Development) đối với việc sử dụng VIPER.
 */
protocol VIPERInteractorInput: class {
    func getData()
}
protocol VIPERInteractorOutput: class {
    func didGetData(_ list: [ItemModel])
}

//==================== WIRE FRAME =======================
protocol VIPERWireFrameInput: class {
    func showFormAdd()
}
protocol VIPERWireFrameOutput: class {
    func didGetText(_ text:String)
}

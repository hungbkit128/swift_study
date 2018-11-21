//
//  ProductHeaderView.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/20/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit

class ProductHeaderView: UIView {
    
    @IBOutlet weak var detailLB: UILabel!
    @IBOutlet weak var productCodeLB: UILabel!
    @IBOutlet weak var productNameLB: UILabel!
    @IBOutlet weak var priceLB: UILabel!
    @IBOutlet weak var priceDetailLB: UILabel!
    @IBOutlet weak var vatLB: UILabel!
    @IBOutlet weak var discountLB: UILabel!
    
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var lineImg: UIImageView!
    
    var actionCollapse: ActionBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    func setupView() {
        self.lineImg.isHidden = true
        if isIphoneApp() {
            self.backgroundColor = UIColor(hexString: "#F1F1F1")
            self.lineImg.backgroundColor = UIColor.white
        } else {
            self.backgroundColor = UIColor.white
            self.lineImg.backgroundColor = UIColor(hexString: "#F1F1F1")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewShadow.layer.cornerRadius = 5
        viewShadow.layer.masksToBounds = true
        let shadowSize : CGFloat = 2.0
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: self.viewShadow.frame.size.width + shadowSize,
                                                   height: self.viewShadow.frame.size.height + shadowSize))
        self.viewShadow.layer.masksToBounds = false
        self.viewShadow.layer.shadowColor = UIColor.black.cgColor
        self.viewShadow.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        self.viewShadow.layer.shadowOpacity = 0.25
        self.viewShadow.layer.shadowPath = shadowPath.cgPath
    }
    
    @IBAction func onColapse(_ sender: UIButton) {
        if let action = actionCollapse {
            action()
        }
    }
    
    func binddingCellWithModel(_ model: ProductModel, _ section: Int, _ isShow: Bool) {
        self.productCodeLB.text = model.productCode
        self.productNameLB.text = model.productName
        if model.isCollapse {
            
        } else {
            
        }
        self.priceLB.text = "Gia \(model.price)"
        self.priceDetailLB.text = "Gia \(model.price)"
    }
}

extension ProductHeaderView {
    
    class func initWithDefaultNib() -> ProductHeaderView {
        let list = Bundle.main.loadNibNamed(self.classString(), owner: self, options: nil)
        let view = list?.first as? ProductHeaderView
        return view!
    }
}

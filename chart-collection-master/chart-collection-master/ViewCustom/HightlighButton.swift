//
//  HightlighButton.swift
//  CBCT-Viettel
//
//  Created by Admin on 7/5/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class HightlighButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    private func setUpView() {
        let backgroundImage = UIImage.imageFromColor(color: .black)
        self.setBackgroundImage(backgroundImage, for: .highlighted)
        self.clipsToBounds = true
        let image = self.image(for: .normal)?.imageWithColor(color: UIColor.white)
        self.setImage(image, for: .highlighted)
        self.tintColor = UIColor.white
    }
}

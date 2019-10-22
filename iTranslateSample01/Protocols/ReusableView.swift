//
//  ReusableView.swift
//  iTranslateSample01
//
//  Created by Moataz Afifi on 22/10/2019.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import UIKit

protocol ReusableView: class {}

extension ReusableView where Self:UIView{
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

protocol NibLoadableView:class {}

extension NibLoadableView where Self: UIView{
    static var nibName: String {
        return String(describing: self)
    }
}

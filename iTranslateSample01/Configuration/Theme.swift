//
//  Theme.swift
//  iTranslateSample01
//
//  Created by Moataz Afifi on 21/10/2019.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import Foundation
import UIKit

open class Theme {
    static var current = Theme()
    
    var color = Color()
    var font: Font = Font()
    
    init() {}
    
    
    // MARK: - Theme definitions
    open class Color {
        let alertBackgroundColor = #colorLiteral(red: 0.4784313725, green: 0.5490196078, blue: 0.6, alpha: 1)
        let backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 0.968627451, alpha: 1)
        let borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        let greyTextColor = #colorLiteral(red: 0.631372549, green: 0.6666666667, blue: 0.7019607843, alpha: 1)
        let primaryColor = #colorLiteral(red: 0.09803921569, green: 0.5960784314, blue: 1, alpha: 1)
    }
    
    open class Font {
        init() {}
        let bigTitle: UIFont = .systemFont(ofSize: 28)
        let title: UIFont = .systemFont(ofSize: 19)
        let titleBold: UIFont = .boldSystemFont(ofSize: 19)
        let text: UIFont = .systemFont(ofSize: 17)
        let textBold: UIFont = .boldSystemFont(ofSize: 17)
        let subText: UIFont = .systemFont(ofSize: 13)
        let subTextBold: UIFont = .boldSystemFont(ofSize: 13)
        let smallText: UIFont = .systemFont(ofSize: 10)
        let smallTextBold: UIFont = .boldSystemFont(ofSize: 10)
    }
    
    
    // MARK: - Appearance
    open func setupAppearance() {
        UINavigationBar.appearance().barTintColor = color.primaryColor
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

public extension UIFont {
    static var theme: Theme.Font {
        return Theme.current.font
    }
}

public extension UIColor {
    static var theme: Theme.Color {
        return Theme.current.color
    }
}

public protocol Themeable {
    func setupUI(with theme: Theme)
}

/*
 Inspired by https://github.com/yeahdongcn/UIColor-Hex-Swift
 */

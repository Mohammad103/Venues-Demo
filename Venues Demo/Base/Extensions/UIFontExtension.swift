//
//  UIFontExtension.swift
//  Venues Demo
//
//  Created by Mohammad Shaker on 7/12/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import UIKit

enum FontWeight {
    case regular
    case medium
    case bold
    case semiBold
    case light
}

extension UIFont {
    class func appFont(withSize size: CGFloat, andWeight weight: FontWeight) -> UIFont {
        let fontName: String = "SFProDisplay-"
        switch weight {
        case .regular:
            return UIFont(name: fontName + "Regular", size: size) ?? UIFont.systemFont(ofSize: size)
        case .medium:
            return UIFont(name: fontName + "Medium", size: size) ?? UIFont.systemFont(ofSize: size)
        case .bold:
            return UIFont(name: fontName + "Bold", size: size) ?? UIFont.systemFont(ofSize: size)
        case.semiBold:
            return UIFont(name: fontName + "Semibold", size: size) ?? UIFont.systemFont(ofSize: size)
        case .light:
            return UIFont(name: fontName + "Light", size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }
}

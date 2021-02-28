//
//  UIFont+Extension.swift
//  OMDbApp
//
//  Created by Mikolaj Kmita on 25/08/2021.
//

import UIKit

extension UIFont {
    enum FontType: String {
        case regular = "AvenirNext-Regular"
        case semiBold = "AvenirNext-DemiBold"
        case bold = "AvenirNext-Bold"
    }
    
    static func appFont(fontType: FontType, size: CGFloat) -> UIFont {
        UIFont(name: fontType.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

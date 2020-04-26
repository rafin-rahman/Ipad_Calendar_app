//
//  HexToUIColor.swift
//  Calendars
//
//  Created by Rafin Rahman on 23/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import Foundation
import UIKit

class HexToUIColor{
    static func hexStringToUIColor (hex:String, alpha:CGFloat) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
    
        if ((cString.count) != 6) {
            return UIColor.gray
        }
    
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
    
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}

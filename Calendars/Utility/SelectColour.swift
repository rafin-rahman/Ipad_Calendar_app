//
//  SelectColour.swift
//  Calendars
//
//  Created by Rafin Rahman on 25/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

public class SelectColor{
    
    static func getColor(color:String) -> UIColor{
        var newColor = UIColor.black
        
        switch color {
        case "Red":
            newColor = HexToUIColor.hexStringToUIColor(hex: "FF020E", alpha: 0.15)
        case "Orange":
            newColor = HexToUIColor.hexStringToUIColor(hex: "FF8E01", alpha: 0.35)
        case "Yellow":
            newColor = HexToUIColor.hexStringToUIColor(hex: "FFF500", alpha: 0.24)
        case "Green":
            newColor = HexToUIColor.hexStringToUIColor(hex: "54FF00", alpha: 0.13)
        case "Aqua":
            newColor = HexToUIColor.hexStringToUIColor(hex: "00FFCE", alpha: 0.13)
        case "Blue":
            newColor = HexToUIColor.hexStringToUIColor(hex: "0065FF", alpha: 0.21)
        default:
            print("Color doesnt match")
        }
        
        return newColor
    }
    
}

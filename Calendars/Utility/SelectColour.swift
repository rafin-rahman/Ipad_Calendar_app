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
            newColor = HexToUIColor.hexStringToUIColor(hex: "c0392b", alpha: 1)
        case "Orange":
            newColor = HexToUIColor.hexStringToUIColor(hex: "f39c12", alpha: 1)
        case "Yellow":
            newColor = HexToUIColor.hexStringToUIColor(hex: "fed330", alpha: 1)
        case "Green":
            newColor = HexToUIColor.hexStringToUIColor(hex: "20bf6b", alpha: 1)
        case "Aqua":
            newColor = HexToUIColor.hexStringToUIColor(hex: "0fb9b1", alpha: 1)
        case "Blue":
            newColor = HexToUIColor.hexStringToUIColor(hex: "2980b9", alpha: 1)
        default:
            newColor = HexToUIColor.hexStringToUIColor(hex: "636e72", alpha: 1)
        }
        
        return newColor
    }
    
}

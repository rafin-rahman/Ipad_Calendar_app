import UIKit

public class PriorityColorSelector{
    
    static func getColor(priority:String) -> UIColor{
        var newColor = UIColor.black
        
        switch priority {
        case "High":
            newColor = HexToUIColor.hexStringToUIColor(hex: "FF020E", alpha: 1)
        case "Medium":
            newColor = HexToUIColor.hexStringToUIColor(hex: "FFF500", alpha: 1)
        case "Low":
            newColor = HexToUIColor.hexStringToUIColor(hex: "0065FF", alpha: 1)
        default:
            print("Color doesnt match")
        }

        return newColor
    }
    
}

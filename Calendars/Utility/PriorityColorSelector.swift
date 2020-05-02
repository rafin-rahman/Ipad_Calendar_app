import UIKit

public class PriorityColorSelector{
    
    static func getColor(priority:String) -> UIColor{
        var newColor = UIColor.black
        
        switch priority {
        case "High":
            newColor = HexToUIColor.hexStringToUIColor(hex: "b33939", alpha: 1)
        case "Medium":
            newColor = HexToUIColor.hexStringToUIColor(hex: "fbc531", alpha: 1)
        case "Low":
            newColor = HexToUIColor.hexStringToUIColor(hex: "ffffff", alpha: 1)//f7f1e3
        default:
            print("Color doesnt match")
        }

        return newColor
    }
    
}

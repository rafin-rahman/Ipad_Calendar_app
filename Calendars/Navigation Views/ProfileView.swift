import UIKit

class ProfileView: UIView, NavigationProtocol {

    var dynamicView: CalendarProtocol!
    
    @IBOutlet weak var addProfileButton: UIButton!
          
    func onLoad() {
        ButtonDesign.roundedCorner(button: addProfileButton)
    }
    
}

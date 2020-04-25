import UIKit

class ProfileView: UIView, NavigationProtocol {

    var dynamicView: CalendarProtocol!
    @IBOutlet weak var addProfileView: UIView!
    
    
    @IBOutlet weak var addProfileButton: UIButton!
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var acquaButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    
    @IBOutlet weak var addProfileHeight: NSLayoutConstraint!
    
    
    func onLoad() {
        ButtonDesign.roundedCorner(button: addProfileButton)
        
        highlightSelectedBorder(selectedButton: redButton)
    }
    
    @IBAction func showAddProfileClick(_ sender: UIButton) {
        if addProfileHeight.constant == 150 {
        addProfileHeight.constant = 0
        }
        else {
          addProfileHeight.constant = 150
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        })
    }
    
    
    @IBAction func colourSelected(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            addProfileView.backgroundColor = .red
            highlightSelectedBorder(selectedButton: redButton)
        case 2:
            addProfileView.backgroundColor = .orange
            highlightSelectedBorder(selectedButton: orangeButton)
        case 3:
            addProfileView.backgroundColor = .yellow
            highlightSelectedBorder(selectedButton: yellowButton)
        case 4:
            addProfileView.backgroundColor = .green
            highlightSelectedBorder(selectedButton: greenButton)
        case 5:
            addProfileView.backgroundColor = .gray
            highlightSelectedBorder(selectedButton: acquaButton)
        case 6:
            addProfileView.backgroundColor = .blue
            highlightSelectedBorder(selectedButton: blueButton)
        default:
            print("Tag had some issues")
        }
    }
    
    func highlightSelectedBorder(selectedButton:UIButton){
        redButton.layer.borderWidth = 0
        orangeButton.layer.borderWidth = 0
        yellowButton.layer.borderWidth = 0
        greenButton.layer.borderWidth = 0
        acquaButton.layer.borderWidth = 0
        blueButton.layer.borderWidth = 0
        
        selectedButton.layer.borderWidth = 3
        selectedButton.layer.borderColor = UIColor.darkGray.cgColor
        selectedButton.clipsToBounds = true
    }
}

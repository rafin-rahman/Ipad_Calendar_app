import UIKit

class ProfileView: UIView, NavigationProtocol {

    var dynamicView: CalendarProtocol!
    @IBOutlet weak var addProfileView: UIView!
    @IBOutlet weak var profileStackView: UIStackView!
    @IBOutlet weak var firstStackView: UIView!
    
    
    
    @IBOutlet weak var addProfileButton: UIButton!
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var acquaButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var profileNameText: UITextField!
    @IBOutlet weak var addProfileHeight: NSLayoutConstraint!
    
    var listOfProfile : Array<Profile> = Array()
    var selectedProfileColor : String = ""
    
    func onLoad() {
        addProfileHeight.constant = 0
        errorLabel.isHidden = true
        addProfileView.backgroundColor = SelectColor.getColor(color: "Red")
        ButtonDesign.roundedCorner(button: addProfileButton)
        highlightSelectedBorder(selectedButton: redButton)
    
        let profileDAO = ProfileDAO()
        profileDAO.getProfileList()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.listOfProfile = profileDAO.profileList
            self.displayDetailsOfProfile(profileList: self.listOfProfile)
        }
    }
    
    @IBAction func showAddProfileClick(_ sender: UIButton) {
        if addProfileHeight.constant == 165 {
            addProfileHeight.constant = 0
        }
        else {
          addProfileHeight.constant = 165
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        })
    }
    
    @IBAction func colourSelected(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            selectedProfileColor = "Red"
            highlightSelectedBorder(selectedButton: redButton)
        case 2:
            selectedProfileColor = "Orange"
            highlightSelectedBorder(selectedButton: orangeButton)
        case 3:
            selectedProfileColor = "Yellow"
            highlightSelectedBorder(selectedButton: yellowButton)
        case 4:
            selectedProfileColor = "Green"
            highlightSelectedBorder(selectedButton: greenButton)
        case 5:
            selectedProfileColor = "Aqua"
            highlightSelectedBorder(selectedButton: acquaButton)
        case 6:
            selectedProfileColor = "Blue"
            highlightSelectedBorder(selectedButton: blueButton)
        default:
            print("Tag had some issues")
        }
         addProfileView.backgroundColor = SelectColor.getColor(color: selectedProfileColor)
    }
    
    
    @IBAction func addProfileClick(_ sender: UIButton) {
        errorLabel.isHidden = true
        TextfieldAnimation.convertToNormal(textField: profileNameText)
        let profileName = profileNameText.text
        if profileName == "" {
            TextfieldAnimation.errorAnimation(textField: profileNameText)
            errorLabel.text = "Profile Name is Empty"
            errorLabel.isHidden = false
            return
        }
        
        print(profileName!)
        
        for profile in listOfProfile{
            print("Name", profile.profileName)
            if profileName! == profile.profileName{
                TextfieldAnimation.errorAnimation(textField: profileNameText)
                errorLabel.text = "Profile with this name Already Created"
                errorLabel.isHidden = false
                return
            }
        }
        
        let profileDic: [String: Any] = [
            "Name" : profileName!,
            "Color" : selectedProfileColor
        ]
        
        ProfileDAO().addProfile(profileDic: profileDic)
        clearAddForm()
    }
    
    func clearAddForm(){
        profileNameText.text = ""
        selectedProfileColor = "Red"
        addProfileView.backgroundColor = SelectColor.getColor(color: selectedProfileColor)
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
    
    func displayDetailsOfProfile(profileList:Array<Profile>){
        let sortedProfileList = profileList.sorted(by: { $0.profileName < $1.profileName })
        firstStackView.removeFromSuperview()
        for profileDetail in sortedProfileList{

            let profile = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
            profileStackView.addArrangedSubview(profile)
            
            let profileNameLabel = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
            profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
            profileNameLabel.text = profileDetail.profileName
            profileNameLabel.textColor = UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1)
            profileNameLabel.font = UIFont.systemFont(ofSize: 20)
            
            
            profile.addSubview(profileNameLabel)
            
            profileNameLabel.topAnchor.constraint(equalTo: profile.topAnchor, constant: 10).isActive = true
            profileNameLabel.leadingAnchor.constraint(equalTo: profile.leadingAnchor, constant: 60).isActive = true
            
            profileNameLabel.numberOfLines = 0
            profileNameLabel.sizeToFit()
            
            profile.translatesAutoresizingMaskIntoConstraints = false
            profile.backgroundColor = SelectColor.getColor(color: profileDetail.profileColor)
            profile.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
        }
    }
    
}

import UIKit

class ProfileView: UIView, NavigationProtocol, UITextFieldDelegate {
    
    var dynamicView: CalendarProtocol!
    @IBOutlet weak var addProfileView: UIView!
    @IBOutlet weak var profileStackView: UIStackView!
    @IBOutlet weak var firstStackView: UIView!
    
    @IBOutlet weak var addEditProfileButton: UIButton!
    @IBOutlet weak var showAddViewButton: UIButton!
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var acquaButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var profileNameText: UITextField!
    @IBOutlet weak var addProfileHeight: NSLayoutConstraint!
    
    var listOfProfile : Array<Profile> = Array()
    var updateProfile : Profile!
    
    var selectedProfileColor : String = ""
    var closeFormStatus = false
    var editStatus = false
    
    func onLoad() {
        addProfileHeight.constant = 0
        errorLabel.isHidden = true
        addProfileView.backgroundColor = SelectColor.getColor(color: "Red")
        ButtonDesign.roundedCorner(button: addEditProfileButton)
        highlightSelectedBorder(selectedButton: redButton)
        selectedProfileColor = "Red"
        profileNameText.delegate = self
        
        let profileDAO = ProfileDAO()
        profileDAO.getProfileList()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.listOfProfile = profileDAO.profileList
            self.displayDetailsOfProfile(profileList: self.listOfProfile)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 16
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func displayForm(){
        if addProfileHeight.constant == 165 {
            addProfileHeight.constant = 0
        }
        else {
            addProfileHeight.constant = 165
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        })
        
        addProfileAnimation()
    }
    
    @IBAction func showAddProfileClick(_ sender: UIButton) {
        displayForm()
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
        
        
        
        if !editStatus || updateProfile.profileName != profileName
        {
            for profile in listOfProfile{
                print("Name", profile.profileName)
                if profileName! == profile.profileName{
                    TextfieldAnimation.errorAnimation(textField: profileNameText)
                    errorLabel.text = "Profile with this name Already Created"
                    errorLabel.isHidden = false
                    return
                }
            }
        }
        
               
        if !editStatus{
            let profileDic: [String: Any] = [
                "Name" : profileName!.capitalizingFirstLetter(),
                "Color" : selectedProfileColor
            ]
            ProfileDAO().addProfile(profileDic: profileDic)
        }
        else{
            updateProfile.profileName = profileName!.capitalizingFirstLetter()
            updateProfile.profileColor = selectedProfileColor
            EventAndTask.editEventAndTask(profile: updateProfile, profileName: updateProfile.profileName, profileColor: updateProfile.profileColor)
            ProfileDAO().editProfile(profile: updateProfile)
        }
        
        clearAddForm()
        closeAnimation()
        onLoad()
        
    }
    
    func addAnimation(){
        UIView.transition(with: showAddViewButton, duration: 0.2, options: .transitionFlipFromRight, animations: {
            self.showAddViewButton.setImage(UIImage(named: "Show profile red"), for: .normal)
        }, completion: nil)
        UIView.animate(withDuration: 0.5, animations:  {
            self.layoutIfNeeded()
            self.showAddViewButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
        }, completion: { _ in
            
        })
        closeFormStatus = true
    }
    
    func closeAnimation(){
        UIView.transition(with: showAddViewButton, duration: 0.2, options: .transitionFlipFromLeft, animations: {
            self.showAddViewButton.setImage(UIImage(named: "Show profile green"), for: .normal)
        }, completion: nil)
        UIView.animate(withDuration: 0.5, animations:  {
            self.showAddViewButton.transform = .identity
            self.layoutIfNeeded()
        }, completion: { _ in
            self.editStatus = false
            self.clearAddForm()
            
        })
        closeFormStatus = false
    }
    
    func addProfileAnimation (){
        if !closeFormStatus {
            addAnimation()
        }
        else {
            closeAnimation()
        }
    }
    
    func clearAddForm(){
        if !editStatus{
            profileNameText.text = ""
            selectedProfileColor = "Red"
            titleText.text = "ADD NEW PROFILE"
            addProfileView.backgroundColor = SelectColor.getColor(color: selectedProfileColor)
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
        selectedButton.layer.borderColor = UIColor.white.cgColor
        selectedButton.clipsToBounds = true
    }
    
    func displayDetailsOfProfile(profileList:Array<Profile>){
        let sortedProfileList = profileList.sorted(by: { $0.profileName < $1.profileName })
        
        for subview in profileStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        for profileDetail in sortedProfileList{
            
            let profileView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
            
            profileStackView.addArrangedSubview(profileView)
            
            let profileNameLabel = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
            profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
            profileNameLabel.text = profileDetail.profileName
            profileNameLabel.textColor = .white //UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1)
            profileNameLabel.font = UIFont.systemFont(ofSize: 20)
            profileNameLabel.numberOfLines = 0
            profileNameLabel.sizeToFit()
            
            let editButton: InfoButton = InfoButton(type: .custom)
            editButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            let editIcon = UIImage(named: "Edit icon") as UIImage?
            editButton.translatesAutoresizingMaskIntoConstraints = false
            editButton.setImage(editIcon, for: .normal)
            editButton.profile = profileDetail
            editButton.addTarget(self, action: #selector(editButtonClick(_:)), for: .touchUpInside)
            
            let binButton:InfoButton = InfoButton(type: .custom)
            binButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            let binIcon = UIImage(named: "Bin button") as UIImage?
            binButton.translatesAutoresizingMaskIntoConstraints = false
            binButton.setImage(binIcon, for: .normal)
            binButton.profile = profileDetail
            binButton.addTarget(self, action: #selector(deleteButtonClick(_:)), for: .touchUpInside)
            
            profileView.addSubview(profileNameLabel)
            profileView.addSubview(editButton)
            profileView.addSubview(binButton)
            
            profileNameLabel.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 20).isActive = true
            profileNameLabel.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 60).isActive = true
            
            editButton.leadingAnchor.constraint(equalTo: binButton.leadingAnchor, constant: -40).isActive = true
            editButton.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 20).isActive = true
            editButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            editButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            
            
            binButton.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 20).isActive = true
            binButton.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -55).isActive = true
            binButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            binButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            
            profileView.translatesAutoresizingMaskIntoConstraints = false
            profileView.backgroundColor = SelectColor.getColor(color: profileDetail.profileColor)
            profileView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
        }
    }
    
    @objc func editButtonClick(_ sender:InfoButton){
       popAnimation(sender)
        
        if !closeFormStatus {
            displayForm()
        }
        editStatus = true
        titleText.text = "EDIT PROFILE"
        updateProfile = sender.profile
        profileNameText.text = sender.profile?.profileName
        highlightSelectedColorBox(color: (sender.profile?.profileColor)!)
    }
    
    func highlightSelectedColorBox(color:String){
        switch color {
        case "Red":
            selectedProfileColor = "Red"
            highlightSelectedBorder(selectedButton: redButton)
        case "Orange":
            selectedProfileColor = "Orange"
            highlightSelectedBorder(selectedButton: orangeButton)
        case "Yellow":
            selectedProfileColor = "Yellow"
            highlightSelectedBorder(selectedButton: yellowButton)
        case "Green":
            selectedProfileColor = "Green"
            highlightSelectedBorder(selectedButton: greenButton)
        case "Aqua":
            selectedProfileColor = "Aqua"
            highlightSelectedBorder(selectedButton: acquaButton)
        case "Blue":
            selectedProfileColor = "Blue"
            highlightSelectedBorder(selectedButton: blueButton)
        default:
            print("Tag had some issues")
        }
        addProfileView.backgroundColor = SelectColor.getColor(color: selectedProfileColor)
    }
        
    @objc func deleteButtonClick(_ sender: InfoButton) {
        
        if let viewController = self.getOwningViewController() as? MainViewController {
            let refreshAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this profile?", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
                EventAndTask.editEventAndTask(profile: sender.profile!, profileName: "Default", profileColor: "Grey")
                ProfileDAO().deleteProfile(profileId: sender.profile!.id)
                self.onLoad()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            viewController.present(refreshAlert, animated: true, completion: nil)
        }
        
    }
    
    func popAnimation (_ sender: UIButton){
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
               
               UIView.animate(withDuration: 2.0,
                              delay: 0,
                              usingSpringWithDamping: CGFloat(0.20),
                              initialSpringVelocity: CGFloat(6.0),
                              options: UIView.AnimationOptions.allowUserInteraction,
                              animations: {
                               sender.transform = CGAffineTransform.identity
               },
                              completion: nil
               )
    }
}

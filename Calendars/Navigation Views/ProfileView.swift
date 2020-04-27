import UIKit

class ProfileView: UIView, NavigationProtocol {

    var dynamicView: CalendarProtocol!
    @IBOutlet weak var addProfileView: UIView!
    @IBOutlet weak var profileStackView: UIStackView!
    @IBOutlet weak var firstStackView: UIView!
    @IBOutlet weak var deleteDynamicView: UIView!
    
    
    
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
        deleteDynamicView.isHidden = true
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

            let profileView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
              
            profileStackView.addArrangedSubview(profileView)
            
            let profileNameLabel = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
            profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
            profileNameLabel.text = profileDetail.profileName
            profileNameLabel.textColor = UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1)
            profileNameLabel.font = UIFont.systemFont(ofSize: 20)
            profileNameLabel.numberOfLines = 0
            profileNameLabel.sizeToFit()
            
            let binButton:UIButton = UIButton(type: .custom)
            binButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            let binIcon = UIImage(named: "Bin button") as UIImage?
            let binIconSelected = UIImage(named: "Bin icon selected") as UIImage?
            binButton.translatesAutoresizingMaskIntoConstraints = false
//            binButton.setTitle("Delete", for: .normal)
            
            binButton.setImage(binIconSelected, for: .highlighted)
            binButton.setImage(binIcon, for: .normal)
            
            	
            binButton.addTarget(self, action: #selector(deleteButtonClick), for: .touchUpInside)
            
            profileView.addSubview(profileNameLabel)
            profileView.addSubview(binButton)
            
            profileNameLabel.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 10).isActive = true
            profileNameLabel.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 60).isActive = true
            
            binButton.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 20).isActive = true
            binButton.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -30).isActive = true
            binButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
            binButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
                        
            profileView.translatesAutoresizingMaskIntoConstraints = false
            profileView.backgroundColor = SelectColor.getColor(color: profileDetail.profileColor)
            profileView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
        }
    }
    
    
    @objc func deleteButtonClick(_ sender: UIButton) {
           deleteDynamicView.isHidden = false
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
        if let deleteView = UINib(nibName: "DeleteView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            DeleteView {
                setDeleteView(newView: deleteView)
        }
       
    }
    
    func setDeleteView(newView: UIView){
        if deleteDynamicView != nil {
            deleteDynamicView.removeFromSuperview()
        }
        deleteDynamicView = newView
        deleteDynamicView.translatesAutoresizingMaskIntoConstraints = false
        deleteDynamicView.frame = CGRect(x: 0, y: 0, width: deleteDynamicView.frame.width, height: deleteDynamicView.frame.height)
        self.addSubview(deleteDynamicView)
        deleteDynamicView.widthAnchor.constraint(equalToConstant: 500).isActive = true
        deleteDynamicView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        deleteDynamicView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        deleteDynamicView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        
//        deleteDynamicView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        deleteDynamicView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        deleteDynamicView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        deleteDynamicView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
}

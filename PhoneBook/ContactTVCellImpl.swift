//
//  ContactTVCellImpl.swift
//  PhoneBook
//

import UIKit

class ContactTVCellImpl: UITableViewCell{
    fileprivate var contactID : String!
    
    @IBOutlet weak var constrainSwitchButton: NSLayoutConstraint!
    
    @IBOutlet weak var buttonOnOff: UIButton!
    
    @IBOutlet weak var constraintPhone: NSLayoutConstraint!
    
    @IBOutlet weak var labelFirstName: UILabel!
    
    @IBOutlet weak var labelLastName: UILabel!
    
    @IBOutlet weak var labelPhone: UILabel!
    
    @IBOutlet weak var labelEmail: UILabel!
    
    @IBOutlet weak var constrainTopPhoneToFirstName: NSLayoutConstraint!
    var expanded :Bool!
    var fullName = ""
    private var firstName : String?
    var currentID: String{
        set{contactID = newValue}
        get{return contactID}
    }
    
    func setFirstName(firstName : String){
        labelFirstName.text = firstName
    }
    
    func setLastName(lastName : String){
        labelLastName.text = lastName
    }
    
    func setPhone(phone : String){
        labelPhone.text = phone
    }
    
    func setEmail(email : String?){
        labelEmail.text = email
    }
    
    func setVisibleLastName(isVisible : Bool){
        labelLastName.isHidden = !isVisible
    }
    
    func setVisibleEmail(isVisible : Bool){
        labelEmail.isHidden = !isVisible
    }

    
    func expand(){
        
    }   
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func tapedOnOff(_ sender: Any) {
        expanded = !expanded
        refreshViews()
    }
    
    fileprivate func refreshViews(){
        
        labelEmail.isHidden = expanded
        labelLastName.isHidden = expanded
        if expanded{
            firstName = labelFirstName.text
            labelFirstName.text = fullName
            constraintPhone.priority = 10
            constrainTopPhoneToFirstName.priority = 999
        }else{
            labelFirstName.text = firstName
            constraintPhone.priority = 999
            constrainTopPhoneToFirstName.priority = 10
        }
        (self.superview?.superview as! UITableView).beginUpdates()
         (self.superview?.superview as! UITableView).endUpdates()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            constrainSwitchButton.constant = 100
        }else{
            constrainSwitchButton.constant = 0
        }
    }
}

extension ContactTVCellImpl{
    func configure(with currentContact: Contact){
        labelFirstName.text = currentContact.firstName
        labelLastName.text = currentContact.lastName
        labelPhone.text = currentContact.phone
        labelEmail.text = currentContact.email
        contactID = currentContact.id
        fullName = currentContact.fullName
        expanded = false
    }
}

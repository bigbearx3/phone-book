//
//  ContactTVCellImpl.swift
//  PhoneBook
//

import UIKit

class ContactTVCellImpl: UITableViewCell, ContactTVCell{
    var presenter : ContactTVCellPresenter!
    var currentID : String!
    @IBOutlet weak var constrainSwitchButton: NSLayoutConstraint!
    @IBOutlet weak var buttonOnOff: UIButton!
    @IBOutlet weak var constraintPhone: NSLayoutConstraint!
    @IBOutlet weak var labelFirstName: UILabel!
    @IBOutlet weak var labelLastName: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var constrainTopPhoneToFirstName: NSLayoutConstraint!
    
    func setCurrentId(currentId : String){
        self.currentID = currentId
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
    
    func expand(expanded : Bool){        
        constraintPhone.priority = expanded ? 999 : 10
        constrainTopPhoneToFirstName.priority = expanded ? 10 : 999
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func tapedOnOff(_ sender: Any) {
        presenter.expandView()
    }
    
    func refresh(){
        if let superview = self.superview,
            let ssuperview = superview.superview,
            let tableView = ssuperview as? UITableView{
            tableView.beginUpdates()
            tableView.endUpdates()
        }        
        //(self.superview?.superview as! UITableView).beginUpdates()
        //(self.superview?.superview as! UITableView).endUpdates()
    }
    
    /*fileprivate func refreshViews(){
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
    }
    */
    
}

extension ContactTVCellImpl{
    func configure(with currentContact: Contact){
        labelFirstName.text = currentContact.firstName
        labelLastName.text = currentContact.lastName
        labelPhone.text = currentContact.phone
        labelEmail.text = currentContact.email
    }
}

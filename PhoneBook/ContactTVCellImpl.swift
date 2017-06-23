//
//  ContactTVCellImpl.swift
//  PhoneBook
//

import UIKit

class ContactTVCellImpl: UITableViewCell, ContactTVCell{
    var presenter : ContactTVCellPresenter!
    var currentID : String!    
    
    @IBOutlet weak var phoneBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonOnOff: UIButton!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var labelFirstName: UILabel!
    @IBOutlet weak var labelLastName: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    
    func setCurrentId(currentId : String){
        self.currentID = currentId
    }
    
    func setFirstName(firstName : String){
        labelFirstName.text = firstName
    }
    
    func setLastName(lastName : String){
        labelLastName.text = lastName
    }
    
    func setPhone(phone : String?){
        labelPhone.text = phone
    }
    
    func setEmail(email : String){
        labelEmail.text = email
    }
    
    func setVisibleLastName(isVisible : Bool){
        labelLastName.isHidden = !isVisible
    }
    
    func setVisibleEmail(isVisible : Bool){
        labelEmail.isHidden = !isVisible
    }
    
    func setImage(imageData : Data?){
        if let iData = imageData,
            let image = UIImage(data : iData){
            contactImage.image = image
        }else{
            contactImage.image =  #imageLiteral(resourceName: "nophoto")        }
    }
    
    func expand(expanded : Bool){        
        phoneTopConstraint.priority = expanded ?  250 : 750
        phoneBottomConstraint.priority = expanded ?  250 : 750
        buttonOnOff.setTitle(expanded ? "-" : "+", for: UIControlState.normal)
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
    }
    
}

extension ContactTVCellImpl{
    func configure(with currentContact: Contact){
        labelFirstName.text = currentContact.firstName
        labelLastName.text = currentContact.lastName
        labelPhone.text = currentContact.phone
        labelEmail.text = currentContact.email
    }
}

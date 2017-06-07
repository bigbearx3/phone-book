//
//  ContactTVCell.swift
//  PhoneBook
//

import UIKit

class ContactTVCell: UITableViewCell {
    private var contactID : String!
    @IBOutlet weak var constrainSwitchButton: NSLayoutConstraint!
    @IBOutlet weak var buttonOnOff: UIButton!
    @IBOutlet weak var constraintPhone: NSLayoutConstraint!
    @IBOutlet weak var labelFirstName: UILabel!
    @IBOutlet weak var labelLastName: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    var fullName = ""
    private var firstName : String?
    var currentID: String{
        set{contactID = newValue}
        get{return contactID}
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func tapedOnOff(_ sender: Any) {
        labelEmail.isHidden = !labelEmail.isHidden
        labelLastName.isHidden = !labelLastName.isHidden
        if labelLastName.isHidden{
            firstName = labelFirstName.text
                    }else{
            labelFirstName.text = firstName
        }
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

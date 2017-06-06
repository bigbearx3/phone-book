//
//  ContactTVCell.swift
//  PhoneBook
//

import UIKit

class ContactTVCell: UITableViewCell {
    private var contactID : String!
    @IBOutlet weak var constraintPhone: NSLayoutConstraint!
    @IBOutlet weak var labelFirstName: UILabel!    
    @IBOutlet weak var labelLastName: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    var currentID: String{
        set{contactID = newValue}
        get{return contactID}
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
}

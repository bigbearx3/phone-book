//
//  ContactTVCell.swift
//  PhoneBook
//

import UIKit

class ContactTVCell: UITableViewCell {
    private var contactID : String!
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

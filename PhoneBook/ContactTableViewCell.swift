//
//  ContactTableViewCell.swift
//  PhoneBook
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    var myContact : Contact?    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  ContactVCViewController.swift
//  PhoneBook
//

import UIKit

class ContactVC: UIViewController {
    private var contactID : String!
    private var myContactList : ContactList!
    var contactList: ContactList{
        set{myContactList = newValue}
        get{return myContactList}
    }
    var currentID: String{
        set{contactID = newValue}
        get{return contactID}
    }
    
    @IBOutlet weak var labelForFirstName: UILabel!
    @IBOutlet weak var labelForLastName: UILabel!
    @IBOutlet weak var labelForPhone: UILabel!
    @IBOutlet weak var labelForEmail: UILabel!
    func contactEditVC(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let contactAddVC = storyBoard.instantiateViewController(withIdentifier: "ContactAddVC") as? ContactAddVC{
            contactAddVC.contactList = contactList
            contactAddVC.currentID = contactID
            if let navC = self.navigationController{
                navC.pushViewController(contactAddVC, animated: false)
            }
        }
    }
    
    @objc private  func reload(){
        if let contact = myContactList.get(byID: contactID){
            labelForFirstName.text = contact.firstName
            labelForLastName.text = contact.lastName
            labelForPhone.text = contact.phone
            labelForEmail.text = contact.email
            title = contact.firstName + " " + contact.lastName
        }
    }
    
    private func initNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(ContactVC.reload), name: Notification.Name(PBNotification.ContactChanged), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNotification()
        reload()        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(contactEditVC(_:)))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }    
}

//
//  ContactAddVC.swift
//  PhoneBook
//

import UIKit

class ContactAddVC: UIViewController {
    private var contactID : String?
    private var isEditingMode = false
    private var myContactList : ContactList!
    var contactList: ContactList{
        set{myContactList = newValue}
        get{return myContactList}
    }
    var currentID: String?{
        set{contactID = newValue}
        get{return contactID}
    }
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        closeView()
    }
    
    @IBAction func saveContact(_ sender: UIBarButtonItem) {
        let contact : Contact
        let firstName = textFieldFirstName.text!
        let lastName = textFieldLastName.text!
        let phone = textFieldPhone.text!
        let email = textFieldEmail.text
        if !isEditingMode {
            contact = Contact(firstName: firstName, lastName: lastName, phone: phone, email: email)
        }else{
            contact = Contact(id : contactID!, firstName: firstName, lastName: lastName, phone: phone, email: email)
        }
        myContactList.update(contact: contact)
        closeView()
    }
    
    private func closeView(){
        if isEditingMode {
            self.navigationController?.popViewController(animated: false)
        }else{
            self.dismiss(animated: true, completion: nil)
        }        
    }
    
    private func load(){
        if let id = contactID, let myContact = myContactList.get(byID: id){        
        textFieldFirstName.text = myContact.firstName
        textFieldLastName.text = myContact.lastName
        textFieldPhone.text = myContact.phone
        textFieldEmail.text = myContact.email
        self.navigationItem.title = myContact.firstName +  " " + myContact.lastName
        isEditingMode = true
        }else{
            self.navigationItem.title = "New contact"
            isEditingMode = false
        }
    }    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       /* if segue.identifier == "SendDataFromContacAddtVC" {
            if let firstName = textFieldFirstName.text,
                let lastName = textFieldLastName.text,
                let phone = textFieldPhone.text,
                let email = textFieldEmail.text, let tableVC = segue.destination as? ContacListTVC {
                tableVC.contactList.update(contact: Contact(firstName: firstName, lastName: lastName, phone: phone, email: email))
            }

        }
         */
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}

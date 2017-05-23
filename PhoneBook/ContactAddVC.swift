//
//  ContactAddVC.swift
//  PhoneBook
//

import UIKit

class ContactAddVC: UIViewController, UITextFieldDelegate {
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
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var barButtonSave: UIBarButtonItem!
    
    @IBAction func changeValues(_ sender: UITextField) {
        barButtonSave.isEnabled =
            !((textFieldFirstName.text?.isEmpty ?? true) ||
            (textFieldLastName.text?.isEmpty ?? true)  ||
            (textFieldPhone.text?.isEmpty ?? true))
    }
    
    @IBAction func buttonDeleteContact(_ sender: UIButton) {
        if let id = contactID{
            myContactList.remove(contactID: id)
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
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
            buttonDelete.isHidden = false
        }else{
            self.navigationItem.title = "New contact"
            isEditingMode = false
            buttonDelete.isHidden = true
            barButtonSave.isEnabled = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textFieldPhone{
            let aSet = CharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined()
            return string == numberFiltered && (textField.text?.characters.count ?? 0) <= 10
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldPhone.delegate = self
        load()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }    
}

//
//  ContactAddEditViewImpl.swift
//  PhoneBook
//

import UIKit

class ContactAddEditViewImpl: UIViewController, UITextFieldDelegate, ContactAddEditView {
    var presenter: ContactAddEditPresenter!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var barButtonSave: UIBarButtonItem!
    
    func setEnableSaveButton(enable : Bool){
        barButtonSave.isEnabled =  enable
    }
    
    func setVisibleDeleteButton(visible : Bool){
        buttonDelete.isHidden = visible
    }
    
    func setTitle(title : String){
        navigationItem.title = title
    }
    
    func setFirstName(firstName : String){
        textFieldFirstName.text = firstName
    }
    
    func setLastName(lastName : String){
        textFieldLastName.text = lastName
    }
    
    func setPhone(phone : String){
        textFieldPhone.text = phone
    }
    
    func setEmail(email : String?){
        textFieldEmail.text = email
    }
    
    func close(){        
        if let navC = self.navigationController{
            navC.popViewController(animated: false)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func changeValues(_ sender: UITextField) {
        barButtonSave.isEnabled =
            !((textFieldFirstName.text?.isEmpty ?? true) ||
                (textFieldLastName.text?.isEmpty ?? true)  ||
                (textFieldPhone.text?.isEmpty ?? true))
    }
    
    @IBAction func buttonDeleteContact(_ sender: UIButton) {
        presenter.deleteContact()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        close()
    }
    
    @IBAction func saveContact(_ sender: UIBarButtonItem) {
        if let firstName = textFieldFirstName.text,
           let lastName = textFieldLastName.text,
           let phone = textFieldPhone.text{
           let email = textFieldEmail.text
           presenter.saveContact(firstName: firstName, lastName: lastName, phone: phone, email: email)
        }
        presenter.closeView()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textFieldPhone{
            return presenter.checkPhone(shouldChangeCharactersIn : range, replacementString : string, size : textField.text?.characters.count ?? 0)
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldPhone.delegate = self
        presenter.initView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

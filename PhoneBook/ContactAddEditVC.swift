//
//  Contact.swift
//  PhoneBook
//

import UIKit

class ContactAddEditVC: UIViewController {
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveContact(_ sender: UIBarButtonItem) {
        let contactInfo : [AnyHashable : Any] = ["firstName":textFieldFirstName.text ?? "",
                                                 "lastName":textFieldLastName.text ?? "",
                                                 "phone":textFieldPhone.text ?? "",
                                                 "email":textFieldEmail.text ?? ""]
        NotificationCenter.default.post(name: Notification.Name("AddNewContact"), object: nil , userInfo: contactInfo)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendDataFromContacAddtVC" {
            if let firstName = textFieldFirstName.text,
                let lastName = textFieldLastName.text,
                let phone = textFieldPhone.text,
                let email = textFieldEmail.text, let tableVC = segue.destination as? ContacListTableVC {
                tableVC.getPhoneBook().update(contact: Contact(firstName: firstName, lastName: lastName, phone: phone, email: email))
            }
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}

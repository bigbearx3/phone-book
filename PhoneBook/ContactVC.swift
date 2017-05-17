//
//  ContactVCViewController.swift
//  PhoneBook
//

import UIKit

class ContactVC: UIViewController {
    
    var currentContact : Contact?
    @IBOutlet weak var labelForFirstName: UILabel!
    @IBOutlet weak var labelForLastName: UILabel!
    @IBOutlet weak var labelForPhone: UILabel!
    @IBOutlet weak var labelForEmail: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let contact = currentContact{
            labelForFirstName.text = contact.firstName
            labelForLastName.text = contact.lastName
            labelForPhone.text = contact.phone
            labelForEmail.text = contact.email
            title = contact.firstName + " " + contact.lastName
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

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
            //contactAddVC.navigationItem.
            //self.presentViewController(nextViewController, animated:true, completion:nil)
           
            
        
            if let navC = self.navigationController{
                navC.pushViewController(contactAddVC, animated: false)
                //navC.popToViewController(contactEditVC, animated: false)
                //navC.presentedViewController = contactEditVC
            }
            //self.presentViewController(contactEditVC, animated:false, completion:nil)
        }        
        
    }
    private func load(){
        if let contact = myContactList.get(byID: contactID){
            labelForFirstName.text = contact.firstName
            labelForLastName.text = contact.lastName
            labelForPhone.text = contact.phone
            labelForEmail.text = contact.email
            title = contact.firstName + " " + contact.lastName
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(contactEditVC(_:)))
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        load()
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

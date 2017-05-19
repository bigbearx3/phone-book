//
//  ContactEditVC.swift
//  PhoneBook
//
//  Created by Andrii Makukha on 5/19/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit

class ContactEditVC: UIViewController {
    private var editingContactID : String!
    private var myContactList : ContactList!
    @IBOutlet weak var textFielFirstName : UITextField!
    @IBOutlet weak var textFielLastName : UITextField!
    @IBOutlet weak var textFielPhone : UITextField!
    @IBOutlet weak var textFielEmail : UITextField!
    var contactList: ContactList{
        set{myContactList = newValue}
        get{return myContactList}
    }
    
    var currentID: String{
        set{editingContactID = newValue}
        get{return editingContactID}
    }
    
    private func load(){
        let myContact = myContactList.get(byID: editingContactID)
        textFielFirstName.text = myContact?.firstName
        textFielLastName.text = myContact?.lastName
        textFielPhone.text = myContact?.phone
        textFielEmail.text = myContact?.email
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

//
//  ContactVCImpl.swift
//  PhoneBook
//

import UIKit

class ContactVCImpl: UIViewController, ContactVC{
    var presenter: ContactVCPresenter!
    @IBOutlet weak var labelForFirstName: UILabel!
    @IBOutlet weak var labelForLastName: UILabel!
    @IBOutlet weak var labelForPhone: UILabel!
    @IBOutlet weak var labelForEmail: UILabel!
    @IBAction func contactEditVC(_ sender: UIBarButtonItem) {
        presenter.showNextView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.initView()
    }
    
    func setTitle(title : String){
        self.title = title
    }
    
    func setFirstName(firstName : String){
        labelForFirstName.text = firstName
    }
    
    func setLastName(lastName : String){
        labelForLastName.text = lastName
    }
    
    func setEmail(email : String?){
        labelForEmail.text = email
    }
    
    func setPhone(phone : String){
        labelForPhone.text = phone
    }
    
    func showEditView(editViewName : String, model : ContactList, currentID : String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let ContactAddEditView = storyBoard.instantiateViewController(withIdentifier: editViewName) as? ContactAddEditViewImpl{
            let presenter = ContactAddEditPresenterImpl(view : ContactAddEditView, contactList : model, currentId : currentID)
            ContactAddEditView.presenter = presenter
            if let navC = self.navigationController{
                navC.pushViewController(ContactAddEditView, animated: false)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

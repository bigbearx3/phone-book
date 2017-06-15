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
    @IBOutlet weak var contactImage: UIImageView!    
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
    
    func setImage(imageData : Data?){
        if let iData = imageData,
            let image = UIImage(data : iData){
            contactImage.image = image
        }else{
            contactImage.image =  #imageLiteral(resourceName: "nophoto")
        }
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
        if let ContactAddEdit = storyBoard.instantiateViewController(withIdentifier: editViewName) as? ContactAddEditImpl{
            let presenter = ContactAddEditPresenterImpl(view : ContactAddEdit , contactList : model, currentId : currentID)
            ContactAddEdit.presenter = presenter
            if let navC = self.navigationController{
                navC.pushViewController(ContactAddEdit, animated: false)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

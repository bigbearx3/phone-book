//
//  ContactAddEditImpl.swift
//  PhoneBook
//

import UIKit

class ContactAddEditImpl: UIViewController, UITextFieldDelegate, ContactAddEdit, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var presenter: ContactAddEditPresenter!
    var ac: UIAlertController?
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var barButtonSave: UIBarButtonItem!
    @IBOutlet weak var contactImage: UIImageView!
    let picker = UIImagePickerController()
    
    @IBAction func addImage(_ sender: Any) {
        presenter.openGallery()
    }
    
    func presentGallery(){
        picker.delegate = self
        if UIImagePickerController.availableMediaTypes(for: .photoLibrary) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            present(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, Gallery is not accessible.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //contactImage.contentMode = .scaleAspectFill
            let imageData = UIImagePNGRepresentation(pickedImage)
            presenter.setImage(imageData : imageData)
        }
        presenter.closeGallery()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presenter.closeGallery()
    }
    
    func hideGallery(){
        self.dismiss(animated: true, completion: nil)
    }   
   
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
    
    func setImage(imageData : Data?){
        if let iData = imageData,
            let image = UIImage(data : iData){
            contactImage.image = image
        }else{
            setDefaultImage()
        }
    }
    
    private func setDefaultImage(){
        contactImage.image =  #imageLiteral(resourceName: "nophoto")
    }
    
    func close(isEditingMode : Bool){        
        if isEditingMode {
            if let navC = self.navigationController{
                navC.popToRootViewController(animated: true)
                debugPrint(navC)
            }
        }else{
            self.dismiss(animated: true, completion: nil)
            debugPrint(self)
        }
    }
    @IBAction func clearImage(_ sender: Any) {
        presenter.setImage(imageData: nil)
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
        presenter.closeView()
    }
    
    @IBAction func saveContact(_ sender: UIBarButtonItem) {
        if let firstName = textFieldFirstName.text,
            let lastName = textFieldLastName.text,
            let phone = textFieldPhone.text{
            let email = textFieldEmail.text
            let imageData = contactImage.image ==  #imageLiteral(resourceName: "nophoto")  ? nil : UIImagePNGRepresentation(contactImage.image!)
            presenter.saveContact(firstName: firstName, lastName: lastName, phone: phone, email: email, imageData: imageData)
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
    
    func fake(_ action: UIAlertAction) {
        
    }
    
    @IBAction func showAlert() {
        
        ac = UIAlertController(title: "My Alert", message: "Hi there!", preferredStyle: .alert)
        //ac?.addTextField()
        
        ac?.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        
        ac?.addAction(UIAlertAction(title: "Increment", style: .destructive) { _ in
            //self.counter += 1
            //self.updateLabel()
            self.ac = nil
        })
        
        ac?.addTextField(configurationHandler: { (textField : UITextField) -> Void in
            textField.borderStyle = UITextBorderStyle.bezel
            textField.placeholder = "Firstname"
            let myColor = UIColor.red
            textField.layer.borderColor = myColor.cgColor
            textField.layer.borderWidth = 1.0
            
        })
        
        ac?.addAction(UIAlertAction(title: "Fake", style: .default, handler: fake))
        
        self.present(ac!, animated: true, completion:nil)
    }

}

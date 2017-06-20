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
    @IBOutlet weak var buttonContactImage: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var constraintPhotoHeight: NSLayoutConstraint!
    
    let picker = UIImagePickerController()
    
    @IBAction func imageTap(_ sender: Any) {
        presenter.presentSoursesPhotoAS()
    }
    
    func isAvailablePhotoLibrary()->Bool{
        return UIImagePickerController.availableMediaTypes(for: .photoLibrary) != nil
    }
    
    func isAvailableSavedPhotosAlbum()->Bool{
        return UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) != nil
    }
    
    func isAvailableCamera()->Bool{
        return UIImagePickerController.availableMediaTypes(for: .camera) != nil
    }
    
    
    func showSoursesPhotoAS(params  : [String : ()->Void]){
        ac = UIAlertController(title: "Choise photo", message: "Please, select photo from", preferredStyle: .actionSheet)
        for param in params{
            ac?.addAction(UIAlertAction(title: param.key, style: .default){ _ in param.value()})
        }
        ac?.addAction(UIAlertAction(title: "Clear", style: .default){ _ in self.presenter.setImage(imageData: nil) })
        ac?.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        picker.delegate = self
        self.present(ac!, animated: true, completion:nil)
    }
    
    func showPhotoLibrary(){
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func showSavedPhotosAlbum(){
        picker.allowsEditing = false
        picker.sourceType = .savedPhotosAlbum
        present(picker, animated: true, completion: nil)
    }
    
    func showCamera(){
        picker.allowsEditing = false
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageData = UIImagePNGRepresentation(pickedImage)
            presenter.setImage(imageData : imageData)
        }
        presenter.closeSourcePhoto()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presenter.closeSourcePhoto()
    }
    
    func hideSourcePhoto(){
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
            buttonContactImage.setImage(image, for: .normal)
        }else{
            setDefaultImage()
        }
        buttonContactImage.imageView?.contentMode = .scaleAspectFit
    }
    
    private func setDefaultImage(){
        buttonContactImage.setImage(#imageLiteral(resourceName: "nophoto"), for: .normal)
        
    }
    
    func close(isEditingMode : Bool){
        if isEditingMode {
            if let navC = self.navigationController{
                navC.popToRootViewController(animated: true)
            }
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
        presenter.closeView()
    }
    
    @IBAction func saveContact(_ sender: UIBarButtonItem) {
        if let firstName = textFieldFirstName.text,
            let lastName = textFieldLastName.text,
            let phone = textFieldPhone.text{
            let email = textFieldEmail.text
            let imageData = buttonContactImage.currentImage ==  #imageLiteral(resourceName: "nophoto")  ? nil : UIImagePNGRepresentation(buttonContactImage.currentImage!)
            presenter.saveContact(firstName: firstName, lastName: lastName, phone: phone, email: email, imageData: imageData)
        }
        presenter.closeView()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textFieldPhone{
            return presenter.checkPhone(shouldChangeCharactersIn : range, replacementString : string, size : textField.text?.characters.count ?? 0)
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.initView()
        NotificationCenter.default.addObserver(self, selector: #selector(ContactAddEditImpl.keyboardDidShow(_:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactAddEditImpl.keyboardWillBeHidden(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactAddEditImpl.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func rotated(){
        //let heightMultiplier  = CGFloat(UIDevice.current.orientation.isLandscape ? 0.5 : 0.3)        
        //constraintPhotoHeight.multiplier.add(heightMultiplier)
    }
    
    
    
    
    weak var activeField: UITextField?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
    }
    
    func keyboardDidShow(_ notification: Notification) {
        if let activeField = self.activeField, let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            if (!aRect.contains(activeField.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
}

//
//  ContactAddEditPresenterImpl.swift
//  PhoneBook
//

import Foundation

class ContactAddEditPresenterImpl : ContactAddEditPresenter{
    private unowned let view: ContactAddEdit
    private let contactList: ContactList
    private var currentId : String?
    private var isEditingMode = false
    
    
    required init(view: ContactAddEdit, contactList: ContactList, currentId : String?) {
        self.view = view
        self.contactList = contactList
        self.currentId = currentId
    }
    
    func closeView(){
        view.close(isEditingMode: isEditingMode)
    }
    
    func getLocationPresenter(for view: LocationVC)->LocationPresenter{
        return LocationPresenterImpl(view : view, contactList: contactList, currentId : currentId)    
    }
    
    func presentSoursesPhotoAS(){
        var params = [String : ()->Void]()
        if view.isAvailableCamera(){
            params["Camera"] = presentCamera
        }
        if view.isAvailablePhotoLibrary(){
            params["Photo library"] = presentPhotoLibrary
        }
        if view.isAvailableSavedPhotosAlbum(){
            params["Saved photos album"] = presentSavedPhotosAlbum
        }        
        view.showSoursesPhotoAS(params  : params)
    }
    
    func presentCamera(){
        view.showCamera()
    }
    
    func presentPhotoLibrary(){
        view.showPhotoLibrary()
    }
    
    func presentSavedPhotosAlbum(){
        view.showSavedPhotosAlbum()
    }
    
    func initView(){
        if let id = currentId, let myContact = contactList.get(byID: id){
            view.setTitle(title: myContact.fullName)
            view.setFirstName(firstName: myContact.firstName)
            view.setLastName(lastName: myContact.lastName)
            view.setPhone(phone: myContact.phone)
            view.setEmail(email: myContact.email)
            view.setImage(imageData :myContact.imageData)
            isEditingMode = true
        }else{
            view.setTitle(title: "New contact")
            view.setImage(imageData : nil)
            isEditingMode = false
        }
        view.setEnableSaveButton(enable: isEditingMode)
        view.setVisibleDeleteButton(visible: !isEditingMode)
    }
    
    func closeSourcePhoto(){
        view.hideSourcePhoto()
    }
    
    func setImage(imageData : Data?){
        if let id = currentId, var contact = contactList.get(byID: id){
            contact.imageData = imageData
            contactList.update(contact: contact)            
        }
        view.setImage(imageData : imageData)
    }
    
    func deleteContact(){
        if let id = currentId{
            contactList.remove(contactId: id)
        }
        view.close(isEditingMode : isEditingMode)
    }
    
    func saveContact(firstName: String, lastName: String, email: String, phone: String?, imageData : Data?){
        let contact : Contact        
        if isEditingMode {
            contact = Contact(id : currentId!, firstName: firstName, lastName: lastName, email: email, phone: phone, imageData : imageData)
            contactList.update(contact: contact)
        }else{
            contact = Contact(firstName: firstName, lastName: lastName, email: email, phone: phone, imageData : imageData)
            contactList.add(newContact: contact)
        }        
    }
    
    func checkPhone(shouldChangeCharactersIn range: NSRange, replacementString string: String, size : Int) -> Bool{
        let aSet = CharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined()
        return (string == numberFiltered) && (size <= 20)
    }
}

//
//  ContactAddEdit.swift
//  PhoneBook
//

import Foundation

protocol ContactAddEdit: class {
    func setEnableSaveButton(enable : Bool)
    func setVisibleDeleteButton(visible : Bool)
    func setTitle(title : String)
    func setFirstName(firstName : String)
    func setLastName(lastName : String)
    func setPhone(phone : String?)
    func setEmail(email : String)
    func close(isEditingMode : Bool)
    func setImage(imageData : Data?)
    func showSoursesPhotoAS(params  : [String : ()->Void])
    func showPhotoLibrary()
    func showSavedPhotosAlbum()
    func showCamera()
    func isAvailablePhotoLibrary()->Bool
    func isAvailableSavedPhotosAlbum()->Bool
    func isAvailableCamera()->Bool
    func hideSourcePhoto()
}

//
//  ContacListTVC.swift
//  PhoneBook
//

import Foundation

protocol ContacListTVC: class {
    func setEditingMode(isEditing : Bool)
    func setVisibleButtonSortBy(isVisible : Bool)
    func setVisibleButtonEdit(isVisible : Bool)
    func setTitleSortBy(title : String)
    func refreshData()
    func refreshCellData(byIndexPath : IndexPath)
}

//
//  BaseView.swift
//  PhoneBook
//
import Foundation

protocol BaseView{
    func showSpinerActivityIndicator(title : String, message : String, minTime : Double, animated : Bool)
    func closeSpinerActivityIndicator(animated : Bool)
}

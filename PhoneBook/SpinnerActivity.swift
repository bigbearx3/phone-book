//
//  SpinnerActivity.swift
//  PhoneBook
//

import UIKit
import MBProgressHUD


extension  UIViewController{
    //let spinnerActivity = MBProgressHUD(view)
    func showSpinerActivity(title : String, message : String, minTime : Double, animated : Bool){
        let spinnerActivity = MBProgressHUD.showAdded(to: view, animated: animated)
        //spinnerActivity.animated = true
        spinnerActivity.label.text = title
        spinnerActivity.detailsLabel.text = message
        spinnerActivity.graceTime = minTime
        spinnerActivity.isUserInteractionEnabled = false
    }
    
    func closeSpinerActivity(animated : Bool){        
        MBProgressHUD.hide(for: view, animated: animated)
    }
}


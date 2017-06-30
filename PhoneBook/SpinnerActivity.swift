//
//  SpinnerActivity.swift
//  PhoneBook
//

import UIKit
import MBProgressHUD


class SpinerActivityIndicatorUtil{
    static func showSpinner(spinnerActivity : MBProgressHUD ,title : String, message : String, minTime : Double, animated : Bool) {
        spinnerActivity.label.text = title
        spinnerActivity.detailsLabel.text = message
        spinnerActivity.graceTime = minTime
        spinnerActivity.isUserInteractionEnabled = false
        spinnerActivity.show(animated: animated)        
    }
    
    static func closeSpinner(spinnerActivity : MBProgressHUD, animated : Bool){
        spinnerActivity.hide(animated: animated)
    }
}


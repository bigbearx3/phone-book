//
//  AppDelegate.swift
//  PhoneBook
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var contactList : ContactList?
    
    var window: UIWindow?
    
    private func loadSortType()->SortType{
        let defaults = UserDefaults.standard
        let intValue = defaults.integer(forKey: "SortBy")
        return SortType(rawValue : intValue)!
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        contactList = ContactList(assistent:  NetworkAsistent(urlString: AppSetting.src, appID: AppSetting.appId))       
        
        let photoURL = "https://api.imagga.com/v1/content"
        let photoData = UIImageJPEGRepresentation(#imageLiteral(resourceName: "nophoto"), 0.7)
        NetworkAsistent.uploadImage(urlString: photoURL, dataImage: photoData!)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "PhoneBookNC")
        if let phoneBookNC = initialViewController as? UINavigationController,
            let contactListTVC = phoneBookNC.viewControllers.first as? ContacListTVCImpl{
            let presenter = ContacListTVCPresenterImpl(view : contactListTVC, contactList : contactList!, sortType : loadSortType())
            contactListTVC.presenter = presenter
        }
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()       
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
}


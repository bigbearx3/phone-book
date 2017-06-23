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
        contactList = ContactList(assistent: NSCodingAssistent(sourceFile: "Contacts.db", destinationFile: "Contacts.db"))
        contactList?.load()
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
        
        let appId = Bundle.main.bundleIdentifier ?? "myApp"
        let converter =  ContactConverter(appId : appId, nameAppId : "appid", nameId: "userid", nameFirstName: "firstname", nameLastName: "lastname", nameEmail: "email", namePhone: "phonenumber", nameLatitude: "lat", nameLongidude: "lon")
        
        let beforeLoad = {() -> Void in
            DispatchQueue.main.async { print("Befor load")
            }
        }
        
        let afterLoad = { () -> Void in
            DispatchQueue.main.async { print("After load")
            }
        }
        
        let contacts = NetworkAsistent(urlString: "http://10.24.9.10:8080", appID: "", converter : converter).load(beforeLoad : beforeLoad, afterLoad : afterLoad)
        print(contacts)
        
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


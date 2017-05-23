//
//  ContacListTVC.swift
//  PhoneBook
//

import UIKit

class ContacListTVC: UITableViewController, PBMember {
    @IBOutlet weak var barButtonItemEdit: UIBarButtonItem!
    @IBOutlet weak var barButtonItemSortBy: UIBarButtonItem!
    private var myContactList : ContactList!
    private var sortField : SortField!
    private var contactsInCurrentState : [Contact] = []
    @IBAction func barButtonItemEditAction(_ sender: UIBarButtonItem) {
        setEditing(!isEditing, animated: true)
    }
    
    @IBAction func barButtonItemSortByAction(_ sender: UIBarButtonItem) {
        sortField.next()
        barButtonItemSortBy.title = "Sort by " + sortField.nextString()
        contactsInCurrentState = myContactList.sortedBy(sortingBy : sortField)
        tableView.reloadData()
        let defaults = UserDefaults.standard
        defaults.set(sortField.rawValue, forKey: "SortField")
        defaults.synchronize()
    }
    
    private func buttonSortByOnOff(){
        if contactsInCurrentState.count > 1 {
            barButtonItemSortBy.isEnabled = true
            barButtonItemSortBy.tintColor = nil
        }else{
            barButtonItemSortBy.isEnabled = false
            barButtonItemSortBy.tintColor = UIColor.clear
        }
    }
    
    private func buttonEditOnOff(){
        if contactsInCurrentState.count > 0 {
            barButtonItemEdit.isEnabled = true
            barButtonItemEdit.tintColor = nil
        }else{
            barButtonItemEdit.isEnabled = false
            barButtonItemEdit.tintColor = UIColor.clear
        }
    }
    
    private func loadSortBy(){
        let defaults = UserDefaults.standard
        let intValue = defaults.integer(forKey: "SortBy")
        self.sortField = SortField(rawValue : intValue)
        barButtonItemSortBy.title = "Sort by " + self.sortField.nextString()
    }
    
    var contactList: ContactList{
        set{myContactList = newValue}
        get{return myContactList}
    }
    
    @objc internal func refresh(){
        contactsInCurrentState = myContactList.sortedBy(sortingBy: sortField)
        tableView.reloadData()
        buttonEditOnOff()
        buttonSortByOnOff()
    }
    
    @objc private func refreshCell(notification : Notification){
        print(notification)
        if let data = notification.userInfo,
            let updatedId = data["id"],
            let id = updatedId as? String,
            let updatedContact = myContactList.get(byID: id),
            let  updRowIndex = contactsInCurrentState.index(of: updatedContact){
            contactsInCurrentState[updRowIndex] = updatedContact
            let indexPath = IndexPath(item: updRowIndex, section: 0)
            tableView.reloadRows(at: [indexPath], with: .top)
        }
    }
    
    private func initNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(ContacListTVC.refresh), name: Notification.Name(PBNotification.ContactListChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContacListTVC.refreshCell), name: Notification.Name(PBNotification.ContactChanged), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSortBy()
        initNotification()
        myContactList.load()
        contactsInCurrentState = myContactList.sortedBy(sortingBy : sortField)
        buttonEditOnOff()
        buttonSortByOnOff()
        self.navigationItem.leftBarButtonItem = self.barButtonItemEdit
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsInCurrentState.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTVCell", for: indexPath)
        if let myCell = cell as?  ContactTVCell {
            let curentContact = contactsInCurrentState[indexPath.item]
            myCell.textLabel?.text = curentContact.firstName + " " + curentContact.lastName
            myCell.detailTextLabel?.text = curentContact.phone
            myCell.currentID = curentContact.id
            return myCell
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myContactList.remove(contactID: contactsInCurrentState[indexPath.item].id)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setEditing(false, animated: false)
        if segue.identifier == "ToContactVC" {
            if let destination = segue.destination as? ContactVC {
                let path = tableView.indexPathForSelectedRow
                let cell = tableView.cellForRow(at: path!)
                destination.contactList = contactList
                if let myCell = cell as? ContactTVCell{
                    destination.currentID = myCell.currentID
                }
            }
        }
        if segue.identifier == "ToContactAddVC" {
            if let destination = segue.destination as? ContactAddEditNC{
                if let contactAddVC =  destination.viewControllers.first as? ContactAddVC{
                    contactAddVC.contactList = myContactList
                }
            }
        }
    }
}

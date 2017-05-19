//
//  ContacListTVC.swift
//  PhoneBook
//

import UIKit

class ContacListTVC: UITableViewController, PBMember {
    @IBOutlet weak var barButtonItemEdit: UIBarButtonItem!
    @IBOutlet weak var barButtonItemSortBy: UIBarButtonItem!
    private var myContactList : ContactList!
    private var sortBy : SortBy!
    private var contactsInCurrentState : [Contact] = []    
    @IBAction func barButtonItemEditAction(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    @IBAction func barButtonItemSortByAction(_ sender: UIBarButtonItem) {
        sortBy.next()
        barButtonItemSortBy.title = "Sort by" + sortBy.toString()
        let defaults = UserDefaults.standard
        defaults.set(sortBy, forKey: "SortBy")
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
        if let sort = defaults.object(forKey: "SortBy"),
            let sortBy = sort as? SortBy{
            self.sortBy = sortBy
           
        }else{
            self.sortBy = .firstName
        }
         barButtonItemSortBy.title = "Sort by" + self.sortBy.toString()

    }
    
    var contactList: ContactList{
        set{myContactList = newValue}
        get{return myContactList}
    }

    @objc internal func refresh(){
        contactsInCurrentState = myContactList.sortedByFirstName()
        tableView.reloadData()
        buttonEditOnOff()
        buttonSortByOnOff()
        print("ContactListChanged")
    }
    
    private func initNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(ContacListTVC.refresh), name: Notification.Name(PBNotification.ContactListChanged.rawValue), object: nil)
    }
    
    func refreshContact() {
        print("CellChanged")
    }   
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        loadSortBy()        
        initNotification()
        myContactList.prepare()
        contactsInCurrentState = myContactList.sortedByFirstName()
        buttonEditOnOff()
        buttonSortByOnOff()
                // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.leftBarButtonItem = self.barButtonItemEdit
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
         return contactsInCurrentState.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTVCell", for: indexPath)
        if let myCell = cell as?  ContactTVCell {
            let curentContact = contactsInCurrentState[indexPath.item]
            myCell.textLabel?.text = curentContact.firstName + " " + curentContact.lastName
            myCell.detailTextLabel?.text = curentContact.phone
            myCell.myContact = curentContact
            return myCell
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            myContactList.remove(contactID: contactsInCurrentState[indexPath.item].id)
            //contactsInCurrentState = phoneBook.sortedByFirstName()
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            //contactsInCurrentState.[indexPath.item]
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        tableView.isEditing = false
        if segue.identifier == "ToContactVC" {
            if let destination = segue.destination as? ContactVC {
                let path = tableView.indexPathForSelectedRow
                let cell = tableView.cellForRow(at: path!)
                if let myCell = cell as? ContactTVCell{
                    destination.currentContact = myCell.myContact
                }
            }
        }
        if segue.identifier == "ToAddContactVC" {
            if let destination = segue.destination as? ContactAddVC {
                destination.contactList = myContactList
            }
        }
        
    }
}

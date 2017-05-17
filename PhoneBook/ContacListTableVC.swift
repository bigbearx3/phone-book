//
//  ContacListTableViewController.swift
//  PhoneBook
//

import UIKit

class ContacListTableVC: UITableViewController {
    
    private var phoneBook = PhoneBook()
    private var contactsInCurrentState : [Contact] = []
    
    
    
    
    private func initNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(ContacListTableVC.refresh), name: Notification.Name("PhoneBookChanged"), object: nil)
        // Define identifier
        //let notificationName = Notification.Name("AddNewContact")
        
        // Register to receive notification
       /*NotificationCenter.default.addObserver(self, selector: #selector(ContacListTableVC.actionAddNewContact), name: Notification.Name("AddNewContact"), object: nil)
        */
        // Post notification
        //NotificationCenter.default.post(name: notificationName, object: nil)
        
        // Stop listening notification
        //NotificationCenter.default.removeObserver(self, name: notificationName, object: nil);
    }
    
    @objc private func refresh(){
        contactsInCurrentState = phoneBook.sortedByFirstName()
        self.tableView.reloadData()
        print("PhoneBookChanged")
        
    }
    
    func getPhoneBook() -> PhoneBook{
        return phoneBook
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneBook.load()
        contactsInCurrentState = phoneBook.sortedByFirstName()
        initNotification()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath)
        if let myCell = cell as?  ContactTableViewCell {
            let curentContact = contactsInCurrentState[indexPath.item]
            myCell.textLabel?.text = curentContact.firstName + " " + curentContact.lastName
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

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        if segue.identifier == "SendDataToContactVC" {
            if let destination = segue.destination as? ContactVC {
                
                let path = tableView.indexPathForSelectedRow
                let cell = tableView.cellForRow(at: path!)
                if let myCell = cell as? ContactTableViewCell{
                    destination.currentContact = myCell.myContact
                }
            }
        }
    }
    

}

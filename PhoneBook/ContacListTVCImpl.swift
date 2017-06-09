//
//  ContacListTVCImpl.swift
//  PhoneBook
//

import UIKit

class ContacListTVCImpl: UITableViewController, ContacListTVC {
    var presenter: ContacListTVCPresenter!
    @IBOutlet weak var barButtonItemEdit: UIBarButtonItem!
    @IBOutlet weak var barButtonItemSortBy: UIBarButtonItem!    
    
    @IBAction func barButtonItemEditAction(_ sender: UIBarButtonItem) {
        presenter.switchEditing()
    }
    
    @IBAction func barButtonItemSortByAction(_ sender: UIBarButtonItem) {
        presenter.changeSort()
    }
    
    func setEditingMode(isEditing : Bool){
        setEditing(isEditing, animated: true)
    }
    
    func setVisibleButtonSortBy(isVisible : Bool){
        barButtonItemSortBy.isEnabled = isVisible
        barButtonItemSortBy.tintColor = isVisible ? nil : UIColor.clear
    }
    
    func setVisibleButtonEdit(isVisible : Bool){
        barButtonItemEdit.isEnabled = isVisible
        barButtonItemEdit.tintColor = isVisible ? nil : UIColor.clear
    }
    
    func setTitleSortBy(title : String){
        barButtonItemSortBy.title = title
    }
    
    func refreshData(){
        tableView.reloadData()
    }
    
    func refreshCellData(byIndexPath : IndexPath){
        tableView.reloadRows(at: [byIndexPath], with: .top)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.initView()
        self.navigationItem.leftBarButtonItem = self.barButtonItemEdit
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 48
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.getNumberOfSection()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfRowsInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTVCellImpl", for: indexPath)
        if let myCell = cell as?  ContactTVCellImpl {
            let curentContactCellPresenter = presenter.getContactCellPresenter(byIndex: indexPath.row, view: myCell)
            myCell.presenter = curentContactCellPresenter
            curentContactCellPresenter.initView()
            return myCell
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteContact(byIndex : indexPath.row)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setEditing(false, animated: false)
        if segue.identifier == "ToContactVC" {
            if let contactVCImpl = segue.destination as? ContactVCImpl {
                let path = tableView.indexPathForSelectedRow
                let contactId = presenter.getContactId(byIndex : path!.item)
                let contactVCPresenter = presenter.getContactVCPresenter(for: contactVCImpl, contactId: contactId)
                contactVCImpl.presenter = contactVCPresenter
            }
        }
        if segue.identifier == "ToContactAddVC" {
            if let destination = segue.destination as? ContactAddEditNC{
                if let contactAddEditView =  destination.viewControllers.first as? ContactAddEditImpl{
                    let contactAddEditPresenter = presenter.getContactAddEditPresenter(for: contactAddEditView, contactId: nil)
                    contactAddEditView.presenter = contactAddEditPresenter
                }
            }
        }
    }
}

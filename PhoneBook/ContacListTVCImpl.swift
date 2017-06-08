//
//  ContacListTVCImpl.swift
//  PhoneBook
//

import UIKit

class ContacListTVCImpl: UITableViewController, ContacListTVC {
    var presenter: ContacListTVCPresenter!
    @IBOutlet weak var barButtonItemEdit: UIBarButtonItem!
    @IBOutlet weak var barButtonItemSortBy: UIBarButtonItem!
    private var paddingCell  = 0
    private var paddingCellFunc : (_ value : Int) -> Int = {$0 + 1}
    
    @IBAction func barButtonItemEditAction(_ sender: UIBarButtonItem) {
        setEditing(!isEditing, animated: true)
    }
    
    @IBAction func barButtonItemSortByAction(_ sender: UIBarButtonItem) {
        presenter.sortBy()
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            let curentContact = presenter.getContactBy(index : indexPath.item)
            myCell.configure(with: curentContact)
            //if paddingCell == 0 {paddingCellFunc = {$0 + 1}}
            //if paddingCell == 4 {paddingCellFunc = {$0 - 1}}
            paddingCell = paddingCellFunc(paddingCell)
            return myCell
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteContact(byIndex : indexPath.item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setEditing(false, animated: false)
        if segue.identifier == "ToContactVC" {
            if let destination = segue.destination as? ContactVCImpl {
                let path = tableView.indexPathForSelectedRow
                let cell = tableView.cellForRow(at: path!)
                if let myCell = cell as? ContactTVCellImpl{
                    let contactVCPresenter = presenter.getContactVCPresenter(for: destination, contactId: myCell.currentID)
                    destination.presenter = contactVCPresenter
                }
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

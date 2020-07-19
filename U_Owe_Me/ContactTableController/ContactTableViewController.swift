//
//  ContactTableViewController.swift
//  U_Owe_Me
//
//  Created by Anthony on 2020-06-10.
//  Copyright © 2020 Anthony. All rights reserved.
//

import UIKit
import Contacts
import CoreData

class ContactTableViewController: UITableViewController {
    
    var ContactData : [CNContact] = []
    var ContactNames : [String] = []
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    var selectedIndex : IndexPath?
    var selectedContacts: [String:CNContact] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: false)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//        resultSearchController = ({
//            let controller = UISearchController(searchResultsController: nil)
//            controller.searchResultsUpdater = self
//            controller.dimsBackgroundDuringPresentation = false
//            controller.searchBar.sizeToFit()
//
//            tableView.tableHeaderView = controller.searchBar
//
//            return controller
//        })()
        
        
//        let contactStore = CNContactStore()
//        if CNContactStore.authorizationStatus(for: .contacts) == .authorized{
//            DispatchQueue.main.async{
//                let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey]
//                let fetchReq = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
//                do{
//                    try contactStore.enumerateContacts(with: fetchReq){contact,stop in
//                        let newContact = ContactModel(firstName: contact.givenName, lastName: contact.familyName)
//                        self.ContactNames.append(newContact.givenName + " " + newContact.familyName)
//                    }
//                    self.tableView.reloadData()
//                }catch let enumerateError{
//                    print(enumerateError.localizedDescription)
//                }
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let contactStore = CNContactStore()
        if CNContactStore.authorizationStatus(for: .contacts) == .authorized{
            DispatchQueue.main.async{
                let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey]
                let fetchReq = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
                do{
                    try contactStore.enumerateContacts(with: fetchReq){contact,stop in
                        let newContact = ContactModel(firstName: contact.givenName, lastName: contact.familyName)
                        self.ContactNames.append(newContact.givenName + " " + newContact.familyName)
                        self.ContactData.append(contact)
                    }
                    self.tableView.reloadData()
                }catch let enumerateError{
                    print(enumerateError.localizedDescription)
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (resultSearchController.isActive){
            return filteredTableData.count
        }else{
            return self.ContactNames.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactInList", for: indexPath)
        if (resultSearchController.isActive) {
            cell.textLabel?.text = filteredTableData[indexPath.item]
        }
        else{
            cell.textLabel?.text = ContactNames[indexPath.item]

        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        guard let cell = tableView.cellForRow(at: indexPath) else{return}
        guard let cellText = cell.textLabel?.text else{return}
        
        //if selectedContacts[cellText] != nil {
             selectedContacts.updateValue(ContactData[indexPath.item], forKey: cellText)
        //}
            
        NSLog(cellText)
//        cell.accessoryType = cell.isSelected ? .checkmark : .none
    }
    override func tableView(_ tableView: UITableView,
                            didDeselectRowAt indexPath: IndexPath){
        guard let cell = tableView.cellForRow(at: indexPath) else{return}
        guard let cellText = cell.textLabel?.text else{return}
        
        if selectedContacts[cellText] != nil {
            selectedContacts.removeValue(forKey: cellText)
        }
        
        NSLog(cellText)
    }
    
    
//    override func tableView(_ tableView: UITableView,
//                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let iOweAction = UIContextualAction(style: .destructive, title: "I Owe"){ (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
//
//        }
//        let oweMeAction = UIContextualAction(style: .normal, title: "Owe Me"){ (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
//
//        }
//        oweMeAction.backgroundColor =  .green
//        let swipeConfig = UISwipeActionsConfiguration(actions: [iOweAction, oweMeAction])
//        return swipeConfig
//    }
    
    override func tableView(_ tableView: UITableView,
                            editActionsForRowAt indexPath: IndexPath)
        -> [UITableViewRowAction]? {

            let iOweTitle = NSLocalizedString("I Owee", comment: "I owe action")
            let iOweAction = UITableViewRowAction(style: .destructive,
                                                    title: iOweTitle) { (action, indexPath) in

            }

            let oweMeTitle = NSLocalizedString("Owe Me", comment: "Owe me action")
            let oweMeAction = UITableViewRowAction(style: .normal,
                                                      title: oweMeTitle) { (action, indexPath) in

            }
            oweMeAction.backgroundColor = .green
            return [oweMeAction, iOweAction]
    }
    
    
}

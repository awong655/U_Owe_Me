//
//  HomeContactListViewController.swift
//  U_Owe_Me
//
//  Created by Anthony on 2019-12-22.
//  Copyright © 2019 Anthony. All rights reserved.
//

import UIKit
import Contacts
import CoreData

class HomeContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBAction func CloseContacts(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var imageDisplay: UIImageView!
    
    @IBAction func saveClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "PendingTransaction", in: context)
        
        let newPendingTransaction = NSManagedObject(entity: entity!, insertInto: context)
        
        let contact : String?
        if let index = selectedIndex, let img = self.currentImage{
            contact = tableData[index.item]
            let image_raw = img.jpegData(compressionQuality: 1.0)
            newPendingTransaction.setValue(contact, forKey: "contact")
            newPendingTransaction.setValue(image_raw, forKey: "receiptImage")
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
            dismiss(animated: true, completion: nil)
        }
        
        
        //newPendingTransaction.setValue()
    }
    
    @IBAction func shareClicked(_ sender: Any) {
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableData : [String] = []
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    var selectedIndex : IndexPath?
    public var currentImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let img = currentImage{
            print(img)
            imageDisplay.image = img
        }
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
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
                        self.tableData.append(newContact.givenName + " " + newContact.familyName)
                    }
                    self.tableView.reloadData()
                }catch let enumerateError{
                    print(enumerateError.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (resultSearchController.isActive){
            return filteredTableData.count
        }else{
            return self.tableData.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeContact", for: indexPath)
        
        if (resultSearchController.isActive) {
            cell.textLabel?.text = filteredTableData[indexPath.item]
        }
        else{
            cell.textLabel?.text = tableData[indexPath.item]
            
        }
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (tableData as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [String]
        
        self.tableView.reloadData()
    }
    
    // set view for footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
        footerView.backgroundColor = UIColor(red:0.95, green:0.96, blue:0.96, alpha:1.0)
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        self.selectedIndex = indexPath
    }
    
}

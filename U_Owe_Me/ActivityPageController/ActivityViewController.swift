//
//  ActivityViewController.swift
//  U_Owe_Me
//
//  Created by Anthony on 2019-12-22.
//  Copyright © 2019 Anthony. All rights reserved.
//

import UIKit
import CoreData

class ActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableData: [ActivityModel] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Activity", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.item].contact
        cell.imageView?.image = tableData[indexPath.item].image
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        print("test")
        loadData()
    }
    
    private func loadData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"PendingTransaction")
        
        request.returnsObjectsAsFaults = false
        
        do{
            let result = try context.fetch(request)
            var newTable : [ActivityModel] = []
            for item in result as! [NSManagedObject]{
                let activity = ActivityModel(contact: item.value(forKey: "contact") as! String, image: UIImage(data: item.value(forKey: "receiptImage") as! Data, scale: 1.0))
                newTable.append(activity)
                if newTable.count != tableData.count{
                    tableData = newTable
                    self.tableView.reloadData()
                }	                
            }
        }catch{
            print("retrieve failed")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

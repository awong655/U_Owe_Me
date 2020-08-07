//
//  ContainerViewController.swift
//  U_Owe_Me
//
//  Created by Anthony on 2020-07-19.
//  Copyright © 2020 Anthony. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var contactFormModel : ContactFormModel?
    var tableVC : ContactTableViewController?
    var delegate : FormDataProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        contactFormModel = delegate?.setFormData()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ContactFormViewController{
            print("hooplah")
            vc.delegate = self
        }else if let vc = segue.destination as? ContactTableViewController{
            tableVC = vc
        }
        
    }
}

extension ContainerViewController : FormDataProtocol{
    func setFormData() -> ContactFormModel? {
        self.contactFormModel?.contactModel = tableVC?.selectedContacts
        return self.contactFormModel
    }
}

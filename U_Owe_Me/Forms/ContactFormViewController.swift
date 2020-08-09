//
//  ContactFormViewController.swift
//  U_Owe_Me
//
//  Created by Anthony on 2020-07-19.
//  Copyright © 2020 Anthony. All rights reserved.
//

import UIKit
import Contacts
import CoreData

class ContactFormViewController: UIViewController {
    var delegate : FormDataProtocol?
    var contactFormModel : ContactFormModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactFormModel = delegate?.setFormData()
    }
    
    @IBOutlet var form: Form!
    
    @IBAction func save() {
        print("Form Data:",
              form["firstName"],
              form["lastName"],
              form["age"])
        
    }
    
}

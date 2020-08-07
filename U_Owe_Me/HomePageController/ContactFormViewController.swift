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
    
    private var imageData : ImageModel?
    private var contactData : [CNContact]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactFormModel = delegate?.setFormData()
    }
}


//
//  ContactNavController.swift
//  U_Owe_Me
//
//  Created by Anthony on 2020-07-19.
//  Copyright © 2020 Anthony. All rights reserved.
//

import UIKit
import Contacts

class ContactNavController: UINavigationController {
    // MARK: Collected Data
    var imageModel : ImageModel?
    var contactList: [CNContact]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

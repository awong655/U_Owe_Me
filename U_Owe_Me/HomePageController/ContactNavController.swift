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
        var root = self.navigationController?.viewControllers.first
        // Do any additional setup after loading the view.
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? ContainerViewController{
//            print("hooray")
//            vc.delegate = self
//        }
//    }
}

extension ContactNavController : UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool){
        if let vc = viewController as? ContainerViewController{
            vc.delegate = self
        }
    }
}

extension ContactNavController : FormDataProtocol{
    func setFormData() -> ContactFormModel? {
        return (ContactFormModel(self.imageModel, self.contactList))
    }
}

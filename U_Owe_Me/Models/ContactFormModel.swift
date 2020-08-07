//
//  ContactFormModel.swift
//  U_Owe_Me
//
//  Created by Anthony on 2020-08-06.
//  Copyright © 2020 Anthony. All rights reserved.
//

import Foundation
import Contacts

class ContactFormModel{
    var imageModel : ImageModel?
    var contactModel : [CNContact]?
    
    init(_ imgModel: ImageModel?, _ cntModel:[CNContact]?){
        self.imageModel = imgModel
        self.contactModel = cntModel
    }
}

//
//  ContactModel.swift
//  U_Owe_Me
//
//  Created by Anthony on 2019-12-21.
//  Copyright © 2019 Anthony. All rights reserved.
//

import Foundation

public struct ContactModel{
    var givenName : String = ""
    var familyName : String = ""
    init(firstName givenName: String, lastName familyName: String){
        self.givenName = givenName
        self.familyName = familyName
    }
}

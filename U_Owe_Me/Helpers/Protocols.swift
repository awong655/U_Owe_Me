//
//  FormDataProtocol.swift
//  U_Owe_Me
//
//  Created by Anthony on 2020-08-06.
//  Copyright © 2020 Anthony. All rights reserved.
//

import Foundation

protocol FormDataProtocol : class{
    func setFormData() -> ContactFormModel?
}

@objc protocol FormControl: class{
    var key: String? { get }
    var text: String? { get }
    func clear()
}

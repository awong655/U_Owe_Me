//
//  TextFieldExtension.swift
//  U_Owe_Me
//
//  Created by Anthony on 2020-08-08.
//  Copyright © 2020 Anthony. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class TextField: UITextField {
    @IBInspectable var key: String?
}
extension TextField: FormControl {
    func clear() {
        text = nil
    }
}

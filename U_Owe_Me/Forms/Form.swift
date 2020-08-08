//
//  Form.swift
//  U_Owe_Me
//
//  Created by Anthony on 2020-08-08.
//  Copyright © 2020 Anthony. All rights reserved.
//

import Foundation

class Form: NSObject {
    @IBOutlet var controls: [FormControl]?
    subscript(_ key: String) -> String? {
        return value(for: key)
    }
    func value(for key: String) -> String? {
        return controls?.first(where: { $0.key == key })?.text
    }
    func clear() {
        controls?.forEach { $0.clear() }
    }
}

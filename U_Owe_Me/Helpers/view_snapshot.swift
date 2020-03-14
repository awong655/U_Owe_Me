//
//  view_snapshot.swift
//  U_Owe_Me
//
//  Created by Anthony on 2020-03-12.
//  Copyright © 2020 Anthony. All rights reserved.
//

import UIKit

extension UIView{
    func makeShapshot() -> UIImage? {
        // Creates a bitmap-based graphics context with the specified options.
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        // Renders a snapshot of the complete view hierarchy as visible onscreen into the current context.
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

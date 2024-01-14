//
//  View+Extension.swift
//  LoginApp
//
//  Created by Victor Roldan on 14/01/24.
//

import Foundation
import UIKit

extension UIView{
    static func view<T: UIView>(config: (T) -> Void) -> T {
        let view = T()
        config(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

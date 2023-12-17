//
//  UIView+Etensions.swift
//  RickMorty
//
//  Created by Amine CHATATE on 17/12/2023.
//

import Foundation
import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}

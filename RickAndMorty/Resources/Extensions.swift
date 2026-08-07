//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Rahul Acharya on 29/07/26.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}

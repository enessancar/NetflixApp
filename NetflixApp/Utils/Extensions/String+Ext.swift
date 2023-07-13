//
//  String+Ext.swift
//  NetflixApp
//
//  Created by Enes Sancar on 13.07.2023.
//

import Foundation

extension String {
    var asUrl: URL? {
        return URL(string: self)
    }
}

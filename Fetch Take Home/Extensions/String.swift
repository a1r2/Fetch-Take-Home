//
//  String.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/12/23.
//

import SwiftUI

extension String {
    func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}

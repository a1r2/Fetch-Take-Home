//
//  YoutubeHelper.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/11/23.
//

import SwiftUI

class YoutubeHelper: ObservableObject {
    @Published var isYoutubeViewAboutToBePresented = false
    @Published var youtubeRef = ""
    
    static func getYoutubeVideoID(from url: String) -> String? {
        guard let urlComponents = URLComponents(string: url),
              let queryItems = urlComponents.queryItems else {
            return nil
        }
        return queryItems.first(where: { $0.name == "v" })?.value
    }
}

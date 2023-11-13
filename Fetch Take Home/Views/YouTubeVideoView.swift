//
//  YouTubeVideoView.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/10/23.
//

import SwiftUI
import WebKit

struct YouTubeVideoView: UIViewRepresentable {
    let videoId: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.configuration.mediaTypesRequiringUserActionForPlayback = []
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let embedURL = "https://www.youtube.com/embed/\(videoId)"
        let embedHTML = """
            <iframe width="100%" height="100%" src="\(embedURL)" frameborder="0" allowfullscreen></iframe>
        """
        uiView.loadHTMLString(embedHTML, baseURL: nil)
    }
}

#Preview {
    YouTubeVideoView(videoId: "6R8ffRRJcrg")
}

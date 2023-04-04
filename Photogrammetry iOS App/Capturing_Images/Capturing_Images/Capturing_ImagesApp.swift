//
//  Capturing_ImagesApp.swift
//  Capturing_Images
//
//  Created by Piyush Manghani on 2/22/22.
//

import SwiftUI

@main
struct Capturing_ImagesApp: App {
    @StateObject var model = CameraViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(model: model)
        }
    }
}

//
//  ContentView.swift
//  Capturing_Images
//
//  Created by Piyush Manghani on 2/22/22.
//

import SwiftUI

// This is the root view of the app.
struct ContentView: View {
    @ObservedObject var model: CameraViewModel

    var body: some View {
        ZStack {
            // Make the entire background black.
            Color.black.edgesIgnoringSafeArea(.all)
            CameraView(model: model)
        }
    
        .environment(\.colorScheme, .dark)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    @StateObject private static var model = CameraViewModel()
    static var previews: some View {
        ContentView(model: model)
    }
}

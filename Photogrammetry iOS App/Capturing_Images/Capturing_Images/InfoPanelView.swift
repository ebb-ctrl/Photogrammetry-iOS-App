//
//  InfoPanelView.swift
//  Capturing_Images
//
//  Created by Piyush Manghani on 2/23/22.
//

import Foundation
import Combine
import SwiftUI

//This view implements an informational status panel that indicates whether gravity and depth are being captured.

// This view also contains a progress bar based on the current number of images taken compared with the maximum number of images for a capture.
struct InfoPanelView: View {
    @ObservedObject var model: CameraViewModel
    
    var body: some View {
        VStack {
            HStack {
                CameraStatusLabel(enabled: model.isCameraAvailable,
                                  qualityMode: model.isHighQualityMode)
                    .alignmentGuide(.leading, computeValue: { dimension in
                        dimension.width
                    })
                Spacer()
                GravityStatusLabel(enabled: model.isMotionDataEnabled)
                    .alignmentGuide(HorizontalAlignment.center,
                                    computeValue: { dimension in dimension.width })
                Spacer()
                DepthStatusLabel(enabled: model.isDepthDataEnabled)
                    .alignmentGuide(.trailing, computeValue: { dimension in
                        dimension.width
                    })
            }
            Spacer(minLength: 18)
            HStack {
                Text("Captures: \(model.captureFolderState!.captures.count)")
                    .foregroundColor(.secondary)
                    .font(.caption)
                Spacer()
                Label(title: {
                    Text("Recommended")
                        .font(.caption)
                        .foregroundColor(.secondary)
                },
                icon: {
                    ZStack {
                        Capsule()
                            .foregroundColor(CaptureCountProgressBar.unfilledProgressColor)
                            .frame(width: 20, height: 7, alignment: .leading)
                        Capsule()
                            .foregroundColor(CaptureCountProgressBar.recommendedZoneColor)
                            .frame(width: 20, height: 7, alignment: .leading)
                    }
                })
            }
            CaptureCountProgressBar(model: model)
        }
        .font(.caption)
        .transition(.move(edge: .top))
    }
}


//This view uses a transparent capsule wider than the progress bar to indicate the suggested number of photos for a good capture to convert into the 3d model.
struct CaptureCountProgressBar: View {
    @ObservedObject var model: CameraViewModel
    let height: CGFloat = 5
    let recommendedZoneHeight: CGFloat = 10
    static let recommendedZoneColor = Color(red: 0, green: 0, blue: 1, opacity: 0.5)
    static let unfilledProgressColor = Color(red: 1, green: 1, blue: 1, opacity: 0.5)
    
    var body: some View {
        GeometryReader { geometryReader in
            ZStack(alignment: .leading) {

                Capsule()
                    .frame(width: geometryReader.size.width,
                           height: height,
                           alignment: .leading)
                    .foregroundColor(CaptureCountProgressBar.unfilledProgressColor)
                
               
                Capsule()
                    .frame(width: CGFloat(Double(model.captureFolderState!.captures.count)
                                            / Double(CameraViewModel.maxPhotosAllowed)
                                            * Double(geometryReader.size.width)),
                           height: height,
                           alignment: .leading)
                    .foregroundColor(Color.white)
                
                // Another taller capsule to show the recommended number of images.
                Capsule()
                    .frame(width: CGFloat(Double(CameraViewModel.recommendedMaxPhotos -
                                                    CameraViewModel.recommendedMinPhotos)
                                            / Double(CameraViewModel.maxPhotosAllowed)) *
                            geometryReader.size.width,
                           height: recommendedZoneHeight,
                           alignment: .leading)
                    .foregroundColor(CaptureCountProgressBar.recommendedZoneColor)
                    .offset(x: CGFloat(Double(CameraViewModel.recommendedMinPhotos) /
                                        Double(CameraViewModel.maxPhotosAllowed)) *
                                geometryReader.size.width,
                            y: 0)
            }
        }
    }
}

//This is a label that shows the current status of the capture. It displays one of the following strings: High Quality, Not High Quality, No Camera.
struct CameraStatusLabel: View {
    var enabled: Bool = true
    var qualityMode: Bool = true
    
    var body: some View {
        if enabled && qualityMode {
            Image(systemName: "camera").foregroundColor(Color.blue)
            Text("High Quality").foregroundColor(.secondary).font(.caption)
        } else if enabled {
            Image(systemName: "exclamationmark.circle").foregroundColor(Color.yellow)
            Text("Low Quality").foregroundColor(.secondary).font(.caption)
        } else {
            Image(systemName: "xmark.circle").foregroundColor(Color.red)
            Text("Unavailable").foregroundColor(.secondary).font(.caption)
        }
    }
}

// This is a status label that indicates whether the app can access the intertial measurement unit (IMU) to get the device's gravity vector or not.
struct GravityStatusLabel: View {
    var enabled: Bool = true
    
    var body: some View {
        if enabled {
            Image(systemName: "arrow.down.to.line.alt").foregroundColor(Color.blue)
        } else {
            Image(systemName: "xmark.circle").foregroundColor(Color.red)
        }
        Text("Camera Gravity").font(.caption).foregroundColor(Color.secondary)
    }
}

// This view implements a label that indicates whether depth data is supported on the current device or not.
struct DepthStatusLabel: View {
    var enabled: Bool = true
    
    var body: some View {
        if enabled {
            Image(systemName: "square.3.stack.3d.top.fill").foregroundColor(Color.blue)
        } else {
            Image(systemName: "xmark.circle").foregroundColor(Color.red)
        }
Text("Depth Sensor").font(.caption).foregroundColor(.secondary)
    }
}

// This view implements a system status summary view. This view contains a different color icon depending on the capture status.
//case 1:- If the device is currently unable to take a picture, this view displays a red icon.

// case2:- If the device can take a picture, but can't access depth or gravity information, or if it can't take pictures at the highest quality and resolution, this view displays a yellow icon.

// case3:-If the device can take pictures at the highest quality with depth and gravity data, this view displays a green icon.
struct SystemStatusIcon: View {
    @ObservedObject var model: CameraViewModel
    
    init(model: CameraViewModel) {
        self.model = model
    }
    
    var body : some View {
        if !model.isCameraAvailable {
            Image(systemName: "xmark.circle")
                .foregroundColor(Color.red)
        } else if model.isMotionDataEnabled && model.isDepthDataEnabled {
            Image(systemName: "checkmark.circle")
                .foregroundColor(Color.blue)
        } else {
            Image(systemName: "exclamationmark.circle")
                .foregroundColor(Color.yellow)
        }
    }
}



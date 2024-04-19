//
//  ImageHelper.swift
//  Live Streaming App
//
//  Created by Sudayn on 19/4/2024.
//

import UIKit
import AVFoundation

class ImageHelper {
    class func thumbnailImage(for videoURL: URL) -> UIImage? {
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        // Get the midpoint time of the video
        let midpointTime = CMTime(seconds: asset.duration.seconds / 2, preferredTimescale: 1)
        
        do {
            // Generate the actual thumbnail
            let cgImage = try imageGenerator.copyCGImage(at: midpointTime, actualTime: nil)
            
            // Convert the CGImage to UIImage and return
            return UIImage(cgImage: cgImage)
        } catch {
            // Error handling
            print("Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
}

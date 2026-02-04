//
//  Image++.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/4.
//

import UIKit

// MARK: - 图片解码
extension UIImage {
    func decoded() -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let width = cgImage.width
        let height = cgImage.height
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        ) else {
            return nil
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let decodedCGImage = context.makeImage() else { return nil }
        
        return UIImage(cgImage: decodedCGImage, scale: self.scale, orientation: self.imageOrientation)
    }
}

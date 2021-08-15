//
//  ViewController.swift
//  ImageLoader
//
//  Created by arul-zt258 on 09/08/21.
//

import UIKit
import ImageIO

final class ViewController: UIViewController {

  @IBOutlet private var imageView: UIImageView!

  @IBAction private func showImage() {
    guard let urlStr = Bundle.main.path(forResource: "Autumn-colors", ofType: "jpg") else{return print("image fetch failed.")}
//    imageView.image = UIImage(contentsOfFile: urlStr)
    
    // Downsampling
    imageView.image = downSample(imageAt: URL(fileURLWithPath: urlStr), to: imageView.frame.size)
  }
  
  private func downSample(imageAt imageURL: URL, to size: CGSize) -> UIImage? {
    let imageSourceOption = [kCGImageSourceShouldCache: false] as CFDictionary
    let maxDimension = max(size.width, size.height)
    let downsampleOptions = [
      kCGImageSourceCreateThumbnailFromImageAlways: true,
      kCGImageSourceShouldCacheImmediately: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: maxDimension
    ] as CFDictionary
    guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOption),
          let downsampleImage = CGImageSourceCreateThumbnailAtIndex(imageSource, .zero, downsampleOptions) else{return nil}
    return UIImage(cgImage: downsampleImage)
  }

}

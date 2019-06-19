//
//  CoreImageFilterViewController.swift
//  AnimationSample
//
//  Created by Hank.Lee on 18/06/2019.
//  Copyright © 2019 Kakao corp. All rights reserved.
//

import UIKit

class CoreImageFilterViewController: UIViewController {
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 30)
        label.text = "Hahahaha~"
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        view.addConstraints([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        view.addConstraints([
            imageView.topAnchor.constraint(equalTo: label.bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: label.centerXAnchor)
            ])
        
        DispatchQueue.main.async {
            self.imageView.image = self.filteredTextImage()
        }
    }
    
    func filteredTextImage() -> UIImage {
        UIGraphicsBeginImageContext(label.bounds.size)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let filter = CIFilter(name: "CIGaussianBlur")!
        filter.setValue(2, forKey: kCIInputRadiusKey)
        filter.setValue(CIImage(cgImage: image.cgImage!), forKey: kCIInputImageKey)
        let outputImage = filter.outputImage!
        let ciContext = CIContext(options: nil)
        return UIImage(cgImage: ciContext.createCGImage(outputImage, from: outputImage.extent)!)
    }
}

//
//  KeyFrameAnimationViewController.swift
//  AnimationSample
//
//  Created by Hank.Lee on 18/06/2019.
//  Copyright © 2019 Kakao corp. All rights reserved.
//

import UIKit

class KeyframeAnimationViewController: UIViewController {
    let movingView: UIView = {
        let movingView = UIView(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        movingView.backgroundColor = .blue
        return movingView
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        return slider
    }()
    
    var animationDuration = TimeInterval(2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(movingView)
        
        slider.addTarget(self, action: #selector(didSliderValueChange(sender:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slider)
        view.addConstraints([
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            slider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addKeyframeAnimation()
    }
    
    func addKeyframeAnimation() {
        let toPosition = movingView.layer.position.applying(CGAffineTransform(translationX: 100, y: 100))
        
        let path = CGMutablePath()
        path.move(to: movingView.layer.position)
        path.addLine(to: toPosition)
        
        let keyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        keyframeAnimation.path = path
        keyframeAnimation.duration = animationDuration
        
        movingView.layer.position = toPosition
        movingView.layer.add(keyframeAnimation, forKey: "positionAnimation")
        movingView.layer.speed = 0
    }
    
    @objc func didSliderValueChange(sender: UISlider) {
        let timeOffset = animationDuration * TimeInterval(sender.value)
        movingView.layer.timeOffset = CFTimeInterval(timeOffset)
    }
}

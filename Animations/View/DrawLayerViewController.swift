//
//  DrawLayerViewController.swift
//  AnimationSample
//
//  Created by Hank.Lee on 18/06/2019.
//  Copyright © 2019 Kakao corp. All rights reserved.
//

import UIKit

class DrawLayerViewController: UIViewController, CALayerDelegate {
    let customLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.addSublayer(customLayer)
        
        customLayer.delegate = self
        customLayer.frame = view.bounds.center(width: 100, height: 100)
        customLayer.setNeedsDisplay()
    }
    
    func deg2rad(_ degree: CGFloat) -> CGFloat {
        return degree * CGFloat(Double.pi) / 180
    }
    
    /// 점으로부터 특정 각도로, 특정 거리만큼 떨어져있는 점의 좌표
    func point(origin: CGPoint, radius: CGFloat, angleRadian: CGFloat) -> CGPoint {
        let x = origin.x + radius * cos(angleRadian)
        let y = origin.y + radius * sin(angleRadian)
        return CGPoint(x: x, y: y)
    }
    
    func draw(_ layer: CALayer, in ctx: CGContext) {
        // 모기향 모양을 그려본다
        ctx.setStrokeColor(UIColor.black.cgColor)
        ctx.setLineWidth(3)
        
        let center = CGPoint(x: layer.bounds.width / 2, y: layer.bounds.height / 2)
        let path = CGMutablePath()
        var angleDegree = CGFloat(0)
        var radius = (layer.bounds.width / 2) - 3
        
        var point = self.point(origin: center, radius: radius, angleRadian: deg2rad(angleDegree))
        path.move(to: point)
        angleDegree += 1
        
        while radius > 0 {
            point = self.point(origin: center, radius: radius, angleRadian: deg2rad(angleDegree))
            path.addLine(to: point)
            
            radius -= 0.03
            angleDegree += 1
        }
        ctx.addPath(path)
        ctx.strokePath()
    }
}

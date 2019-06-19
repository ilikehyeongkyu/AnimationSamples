//
//  ShapeViewController.swift
//  AnimationSample
//
//  Created by Hank.Lee on 17/06/2019.
//  Copyright © 2019 Kakao corp. All rights reserved.
//

import UIKit

class ShapeViewController: UIViewController {
    private let shapeView = ShapeView()
    
    init(shapeType: ShapeType) {
        super.init(nibName: nil, bundle: nil)
        shapeView.shapeType = shapeType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        title = "Shape"
        
        shapeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shapeView)
        shapeView.addConstraints([
            NSLayoutConstraint(item: shapeView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 100),
            NSLayoutConstraint(item: shapeView, attribute: .height, relatedBy: .equal, toItem: shapeView, attribute: .width, multiplier: 1.0, constant: 0)
            ])
        view.addConstraints([
            shapeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shapeView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
}

enum ShapeType {
    case circle
    case roundedRect
}

class ShapeView: UIView {
    var shapeType: ShapeType?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        if let shapeType = shapeType, let context = UIGraphicsGetCurrentContext() {
            var functionForDraw: ((_ context: CGContext, _ rect: CGRect) -> Void)?
            switch shapeType {
            case .circle:
                functionForDraw = drawCircle(context:rect:)
            case .roundedRect:
                functionForDraw = drawRoundedRect(context:rect:)
            }
            functionForDraw?(context, rect)
        }
        
        super.draw(rect)
    }
    
    func deg2rad(_ degree: CGFloat) -> CGFloat {
        return degree * CGFloat(Double.pi) / 180
    }
    
    func drawCircle(context: CGContext, rect: CGRect) {
        context.setFillColor(UIColor.blue.cgColor)
        let rectForShape = rect.center(width: 100, height: 100)
        context.addEllipse(in: rectForShape)
        context.fillPath()
    }
    
    func drawRoundedRect(context: CGContext, rect: CGRect) {
        context.setFillColor(UIColor.blue.cgColor)
        context.setStrokeColor(UIColor.red.cgColor)
        let cornerRadius = CGFloat(20)
        let rectForShape = rect.center(width: 100, height: 100)
        let path = CGMutablePath()
        var center = CGPoint(x: rectForShape.minX + cornerRadius, y: rectForShape.minY + cornerRadius)
        path.addArc(center: center, radius: cornerRadius, startAngle: deg2rad(180), endAngle: deg2rad(270), clockwise: false)
        path.addLine(to: CGPoint(x: rectForShape.maxX - cornerRadius, y: rectForShape.minY))
        center = CGPoint(x: rectForShape.maxX - cornerRadius, y: rectForShape.minY + cornerRadius)
        path.addArc(center: center, radius: cornerRadius, startAngle: deg2rad(270), endAngle: deg2rad(360), clockwise: false)
        path.addLine(to: CGPoint(x: rectForShape.maxX, y: rectForShape.maxY - cornerRadius))
        center = CGPoint(x: rectForShape.maxX - cornerRadius, y: rectForShape.maxY - cornerRadius)
        path.addArc(center: center, radius: cornerRadius, startAngle: deg2rad(0), endAngle: deg2rad(90), clockwise: false)
        path.addLine(to: CGPoint(x: rectForShape.minX + cornerRadius, y: rectForShape.maxY))
        center = CGPoint(x: rectForShape.minX + cornerRadius, y: rectForShape.maxY - cornerRadius)
        path.addArc(center: center, radius: cornerRadius, startAngle: deg2rad(90), endAngle: deg2rad(180), clockwise: false)
        context.addPath(path)
        context.fillPath()
    }
}

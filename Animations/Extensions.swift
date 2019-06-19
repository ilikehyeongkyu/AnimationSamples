//
//  Extensions.swift
//  AnimationSample
//
//  Created by Hank.Lee on 17/06/2019.
//  Copyright © 2019 Kakao corp. All rights reserved.
//

import CoreGraphics

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: minX + (width / 2), y: minY + (height / 2))
    }
    
    /// self가 rect 내의 정중앙에 배치되어야할 경우, 사용해야할 CGRect 값을 반환
    func center(by rect: CGRect) -> CGRect {
        return rect.center(width: width, height: height)
    }
    
    /// self의 내부에 width, height 값을 가지는 무언가가 배치될 경우, 사용해야할 CGRect 값을 반환
    func center(width: CGFloat, height: CGFloat) -> CGRect {
        let x = (self.width - width) / 2
        let y = (self.height - height) / 2
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

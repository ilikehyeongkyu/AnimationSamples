//
//  TransitionViewController.swift
//  Animations
//
//  Created by Hank.Lee on 19/06/2019.
//  Copyright © 2019 hyeongkyu. All rights reserved.
//

import UIKit

class TransitionViewController: UIViewController {
    let myView1: UIView = {
       let myView1 = UIView(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        myView1.backgroundColor = .blue
        return myView1
    }()
    
    let myView2: UIView = {
        let myView2 = UIView(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        myView2.backgroundColor = .red
        return myView2
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        myView1.frame = view.frame.center(width: 100, height: 100)
        myView2.frame = view.frame.center(width: 100, height: 100)
        
        view.addSubview(myView1)
        view.addSubview(myView2)
        
        myView1.isHidden = true
        myView2.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        transition()
    }
    
    func transition() {
        let transition = CATransition()
        transition.startProgress = 0
        transition.endProgress = 1
        transition.type = .push
        transition.subtype = .fromRight
        transition.duration = 1.0
        
        myView1.layer.add(transition, forKey: "transition")
        myView2.layer.add(transition, forKey: "transition")
        
        myView1.isHidden = false
        myView2.isHidden = true
    }
}

//
//  ViewController.swift
//  AnimationSample
//
//  Created by Hank.Lee on 29/05/2019.
//  Copyright © 2019 Kakao corp. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    lazy var menus: [Menu] = [
        Menu(title: "Circle", action: {
            self.navigationController?.pushViewController(ShapeViewController(shapeType: .circle), animated: true)
        }),
        Menu(title: "Rounded Rectangle", action: {
            self.navigationController?.pushViewController(ShapeViewController(shapeType: .roundedRect), animated: true)
        }),
        Menu(title: "Draw Layer", action: {
            self.navigationController?.pushViewController(DrawLayerViewController(), animated: true)
        }),
        Menu(title: "Core Image Filter", action: {
            self.navigationController?.pushViewController(CoreImageFilterViewController(), animated: true)
        }),
        Menu(title: "Keyframe Animation with Slider", action: {
            self.navigationController?.pushViewController(KeyframeAnimationViewController(), animated: true)
        }),
        Menu(title: "ViewController Transition", action: {
            self.navigationController?.pushViewController(ColorTableViewController(), animated: true)
        })
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sample"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = menus[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menus[indexPath.row].action?()
    }
    
    struct Menu {
        var title: String
        var action: (() -> Void)?
        init(title: String, action: (() -> Void)?) {
            self.title = title
            self.action = action
        }
    }
}

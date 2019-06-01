//
//  ViewController.swift
//  AlphaVideoiOSDemo
//
//  Created by lvpengwei on 2019/5/26.
//  Copyright © 2019 lvpengwei. All rights reserved.
//

import UIKit
import AlphaVideoiOS

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        let videoSize = CGSize(width: 300, height: 300)
        let animView = AlphaVideoView(with: "playdoh-bat")
        view.addSubview(animView)
        animView.translatesAutoresizingMaskIntoConstraints = false
        animView.widthAnchor.constraint(equalToConstant: videoSize.width).isActive = true
        animView.heightAnchor.constraint(equalToConstant: videoSize.height).isActive = true
        animView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        animView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        animView.play()
    }
}


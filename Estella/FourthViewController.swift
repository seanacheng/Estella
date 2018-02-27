//
//  FourthViewController.swift
//  Estella
//
//  Created by Sean Cheng on 2/27/18.
//  Copyright © 2018 NTU. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class FourthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToDiary(_ sender: Any) {
        tabBarController?.selectedIndex=2
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "dolphins", ofType:"mov") else {
            debugPrint("dolphins.mov not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerViewController = AVPlayerViewController()
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        playerViewController.view.frame = CGRect (x:screenWidth*0.15, y:screenHeight*0.15, width:screenWidth*0.7, height:screenHeight*0.6)
        playerViewController.player = player
        
        self.addChildViewController(playerViewController)
        self.view.addSubview(playerViewController.view)
        playerViewController.didMove(toParentViewController: self)

    }
}

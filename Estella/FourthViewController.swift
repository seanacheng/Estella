//
//  FourthViewController.swift
//  Estella
//
//  Created by Sean Cheng on 2/27/18.
//  Copyright © 2018 NTU. All rights reserved.
//

import UIKit

class FourthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToDiary(_ sender: Any) {
        tabBarController?.selectedIndex=2
    }
}

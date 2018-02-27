//
//  FirstViewController.swift
//  Estella
//
//  Created by Sean Cheng on 2/6/18.
//  Copyright © 2018 NTU. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

@IBOutlet weak var enterText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let entry: String = enterText.text!
        let url = URL(string: "http://10.27.168.4:8891/diary")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    
    @IBAction func goToDiary(_ sender: Any) {
        tabBarController?.selectedIndex=1
        
    }
    
}


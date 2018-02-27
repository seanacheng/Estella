//
//  SecondViewController.swift
//  Estella
//
//  Created by Sean Cheng on 2/6/18.
//  Copyright © 2018 NTU. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        let url = URL(string: "http://10.27.168.4:8891/diary")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
//        request.httpBody = "key=\"value\"".data(using: .utf8)
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if error == nil,let usableData = data {
//                print(usableData) //JSONSerialization
//            }
//        }
//        task.resume()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

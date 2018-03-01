//
//  ThirdViewController.swift
//  Estella
//
//  Created by Sean Cheng on 2/6/18.
//  Copyright © 2018 NTU. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "http://10.27.168.4:8891/event")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
//            var arrayString = "\(String(describing: responseString))".replacingOccurrences(of: "{", with: "[")
//            arrayString = "\(String(describing: responseString))".replacingOccurrences(of: "}", with: "]")
//            let diaries = Array(arrayString["events"])
            
        }
        task.resume()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



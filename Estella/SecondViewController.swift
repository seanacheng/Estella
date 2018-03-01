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
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        var myScrollView: UIScrollView!
        myScrollView = UIScrollView(frame: CGRect(x: 0, y: 50, width: screenWidth, height: screenHeight))
        myScrollView.contentSize = CGSize(width: screenWidth, height: 2000)
        view.addSubview(myScrollView)

        let url = URL(string: "http://10.27.168.4:8891/diary")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
//            for dict in responseString! {
//                print(dict)
//            }
        }
        task.resume()

        let diarys = [["author": "zhihao", "type": "text", "score": 0.7, "content": "This is my first diary"], ["author": "zhihao", "type": "video", "score": 0.6, "video": "first.mp4"], ["author": "zhihao", "type": "text", "score": 0.0, "content": "Kjbhkbkbkj"], ["author": "zhihao", "type": "text", "score": 0.20000000298023224, "content": "Get this data"]]
        var startY = 0
        for dict in diarys {
            let label = UILabel(frame: CGRect(x: 80, y: startY, width: Int(screenWidth), height: 100))
            label.textAlignment = .left
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 100;
            label.text = ""
            for (key, value) in dict {
                print("The \(key) is \(value).")
                label.text = label.text! + "\(value) \n"
            }
            print("-------------------------")
            myScrollView.addSubview(label)
            startY += 100
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

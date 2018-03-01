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
        myScrollView = UIScrollView(frame: CGRect(x: 0, y: 40, width: screenWidth, height: screenHeight))

        let url = URL(string: "http://10.27.168.4:8891/diary")!
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
//            let diaries = Array(arrayString["diarys"])
        }
        task.resume()

        let diarys = [["author": "zhihao", "type": "text", "score": 0.7, "content": "This is my first diary"], ["author": "zhihao", "type": "video", "score": 0.6, "video": "first.mp4"], ["author": "zhihao", "type": "text", "score": 0.1, "content": "This is a long diary that will need to be several lines so I want to make sure that my app can see that."], ["author": "zhihao", "type": "text", "score": 0.20000000298023224, "content": "Get this data"]]
        var startY = 0
        let labelHeight = 70        // enough space for content and score
        var contentHeight = 0
        for dict in diarys {
            let label = UILabel()
            var labelHeightOffset = 0
            label.textAlignment = .left
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 100;
            label.text = ""
            for (key, value) in dict {
                switch "\(key)" {
                case "timestamp":
                    label.text = label.text! + "\(value) \n"
                case "content":
                    label.text = label.text! + "\(value) \n"
                    labelHeightOffset += "\(value)".count/2         // adds enough space to fit the content
                case "video":
                    label.text = label.text! + "\(value) \n"        // would like to move this piece above score
                case "score":
                    label.text = label.text! + "Score: \(value) \n"
                default:
                    continue
                }
                print("The \(key) is: \(value).")
            }
            print("-------------------------")
            label.frame = CGRect(x: 10, y: startY, width: Int(screenWidth), height: labelHeight + labelHeightOffset)
            contentHeight += labelHeightOffset + 70
            myScrollView.addSubview(label)
            startY += 50 + labelHeightOffset
        }
        myScrollView.contentSize = CGSize(width: Int(screenWidth), height: contentHeight)
        view.addSubview(myScrollView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

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
        myScrollView.backgroundColor = UIColor.lightGray

        let url = URL(string: "http://10.27.2.249:8891/diary")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with:url) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    let entries = parsedData["diarys"] as! [AnyObject]
                    var startY = 10
                    let labelHeight = 50        // enough space for content and score
                    var contentHeight = 0
                    for entry in entries {
                        let label = UILabel()
                        var labelHeightOffset = 0
                        label.textAlignment = .left
                        label.lineBreakMode = .byWordWrapping
                        label.numberOfLines = 100;
                        label.text = ""
                        for (key, value) in entry as! Dictionary<String, AnyObject> {
                            switch "\(key)" {
                            case "timestamp":
                                label.text = label.text! + "\(value) \n"
                            case "content":
                                label.text = label.text! + "\(value) \n"
                                labelHeightOffset += "\(value)".count/2 - "\(value)".count%2        // adds enough space to fit the content
                            case "score":
                                if Double("\(value)")! > 7.5 {
                                    label.text = label.text! + "happy \n"
                                } else if Double("\(value)")! < 2.5 {
                                    label.text = label.text! + "sad \n"
                                } else {
                                    label.text = label.text! + "neutral \n"
                                }
                            case "video":
                                label.text = label.text! + "\(value) \n"        // would like to move this piece above score
                            default:
                                continue
                            }
                            //                print("The \(key) is: \(value).")
                        }
                        //            print("-------------------------")
                        label.frame = CGRect(x: 10, y: startY, width: Int(screenWidth)-20, height: labelHeight + labelHeightOffset)
                        label.backgroundColor = UIColor.white
                        contentHeight += labelHeightOffset + 70
                        myScrollView.addSubview(label)
                        startY += 70 + labelHeightOffset
                    }
                    myScrollView.contentSize = CGSize(width: Int(screenWidth), height: contentHeight)
                    self.view.addSubview(myScrollView)
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()

//        let diarys = [["author": "zhihao", "type": "text", "score": 0.7, "content": "This is my first diary"], ["author": "zhihao", "type": "video", "score": 0.6, "video": "first.mp4"], ["author": "zhihao", "type": "text", "score": 0.1, "content": "This is a long diary that will need to be several lines so I want to make sure that my app can see that."], ["author": "zhihao", "type": "text", "score": 0.20000000298023224, "content": "Get this data"]]
//        var startY = 10
//        let labelHeight = 50        // enough space for content and score
//        var contentHeight = 0
//        for dict in diarys {
//            let label = UILabel()
//            var labelHeightOffset = 0
//            label.textAlignment = .left
//            label.lineBreakMode = .byWordWrapping
//            label.numberOfLines = 100;
//            label.text = ""
//            for (key, value) in dict {
//                switch "\(key)" {
//                case "timestamp":
//                    label.text = label.text! + "\(value) \n"
//                case "content":
//                    label.text = label.text! + "\(value) \n"
//                    labelHeightOffset += "\(value)".count/2 - "\(value)".count%2        // adds enough space to fit the content
//                case "score":
//                    if Double("\(value)")! > 7.5 {
//                        label.text = label.text! + "happy \n"
//                    } else if Double("\(value)")! < 2.5 {
//                        label.text = label.text! + "sad \n"
//                    } else {
//                        label.text = label.text! + "neutral \n"
//                    }
//                case "video":
//                    label.text = label.text! + "\(value) \n"        // would like to move this piece above score
//                default:
//                    continue
//                }
////                print("The \(key) is: \(value).")
//            }
////            print("-------------------------")
//            label.frame = CGRect(x: 10, y: startY, width: Int(screenWidth)-20, height: labelHeight + labelHeightOffset)
//            label.backgroundColor = UIColor.white
//            contentHeight += labelHeightOffset + 70
//            myScrollView.addSubview(label)
//            startY += 70 + labelHeightOffset
//        }
//        myScrollView.contentSize = CGSize(width: Int(screenWidth), height: contentHeight)
//        view.addSubview(myScrollView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

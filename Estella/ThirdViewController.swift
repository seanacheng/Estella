//
//  ThirdViewController.swift
//  Estella
//
//  Created by Sean Cheng on 2/6/18.
//  Copyright © 2018 NTU. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    @IBOutlet weak var eventsView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = eventsView.bounds.width
        
        let url = URL(string: "http://10.27.2.249:8891/event")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with:url) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    let events = parsedData["events"] as! [AnyObject]
                    var startY = 10
                    let labelHeight = 50        // enough space for content and score
                    var contentHeight = 0
                    for event in events {
                        let label = UILabel()
                        var labelHeightOffset = 0
                        label.textAlignment = .left
                        label.lineBreakMode = .byWordWrapping
                        label.numberOfLines = 100;
                        label.text = ""
                        for (key, value) in event as! Dictionary<String, AnyObject> {
                            switch "\(key)" {
                            case "time":
                                label.text = label.text! + "\(value) \n"
                            case "title":
                                label.text = label.text! + "\(value) \n"
                            case "description":
                                label.text = label.text! + "\(value) \n"
                                labelHeightOffset += "\(value)".count/2 - "\(value)".count%2        // adds enough space to fit the content
                            case "website":
                                label.text = label.text! + "\(value) \n"        // would like to move this piece above score
                            default:
                                continue
                            }
                            //                print("The \(key) is: \(value).")
                        }
                        //            print("-------------------------")
                        label.frame = CGRect(x: 10, y: startY, width: Int(screenWidth)-20, height: labelHeight + labelHeightOffset)
                        contentHeight += labelHeightOffset + 70
                        self.eventsView.addSubview(label)
                        startY += 70 + labelHeightOffset
                    }
                    self.eventsView.contentSize = CGSize(width: Int(screenWidth), height: contentHeight)
                    self.view.addSubview(self.eventsView)
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



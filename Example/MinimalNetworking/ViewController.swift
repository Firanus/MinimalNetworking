//
//  ViewController.swift
//  MinimalNetworking
//
//  Created by Firanus on 04/10/2018.
//  Copyright (c) 2018 Firanus. All rights reserved.
//

import UIKit
import MinimalNetworking

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let httpService = HttpService()
        httpService.get(url: "https://www.foaas.com/version", responseContentType: ResponseContentType.json, completion: { (myParam: NetworkResponse<String?>) in
            print(myParam)
        })
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


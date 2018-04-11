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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var getTextView: UITextView!
    @IBOutlet weak var postTextView: UITextView!
    
    @IBAction func touchGetButton(_ sender: UIButton) {
        let httpService = HttpService()
        _ = httpService.get(url: "https://xkcd.com/info.0.json", responseContentType: ResponseContentType.json) { [weak self] (networkResponse: NetworkResponse<XkcdResponse?>) in
            
            switch networkResponse {
            case .success(let xkcd, let response):
                self?.getTextView.text = xkcd?.alt
                print(response)
            case .failure(let error):
                self?.getTextView.text = error.localizedDescription
                self?.getTextView.textColor = UIColor.red
            }
        }
    }
    @IBAction func touchPostButton(_ sender: UIButton) {
        let httpService = HttpService()
        _ = httpService.post(url: "https://httpbin.org/post", body: PostQuery(), responseContentType: ResponseContentType.json) { [weak self] (networkResponse: NetworkResponse<PostResponse?>) in
            
            switch networkResponse {
            case .success(let data, let response):
                self?.postTextView.text = data?.form.minimalNetworking
                print(response)
            case .failure(let error):
                self?.postTextView.text = error.localizedDescription
                self?.postTextView.textColor = UIColor.red
                print(error)
            }
        }
    }

}

struct XkcdResponse: Codable {
    let month: String
    let num: Int
    let link: String
    let year: String
    let news: String
    let safe_title: String
    let transcript: String
    let alt: String
    let img: String
    let title: String
    let day: String
}

struct PostResponse: Codable {
    struct BodyStruct: Codable {
        let minimalNetworking: String
    }
    
    let url: String
    let form: BodyStruct
}
struct PostQuery: POSTBodyEncodable {
    var asFormUrlEncoded: String = "minimalNetworking=Successfully posted this message to HTTPBin and received it in a response"
}

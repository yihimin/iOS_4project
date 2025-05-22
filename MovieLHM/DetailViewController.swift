//
//  DetailViewController.swift
//  MovieLHM
//
//  Created by Induk-cs-1 on 2025/05/22.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var movieName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = movieName
        guard let url = URL(string:"https://m.naver.com") else { return  }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

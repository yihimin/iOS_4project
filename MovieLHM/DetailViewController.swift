//
//  DetailViewController.swift
//  MovieLHM
//
//  Created by Induk-cs-1 on 2025/05/22.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    var movieName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = movieName
    }
}

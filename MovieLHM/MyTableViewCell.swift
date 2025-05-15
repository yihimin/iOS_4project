//
//  MyTableViewCell.swift
//  MovieLHM
//
//  Created by Induk-cs-1 on 2025/05/08.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var movieName:  UILabel!
    @IBOutlet weak var audiAccumulate: UILabel!
    @IBOutlet weak var audiCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

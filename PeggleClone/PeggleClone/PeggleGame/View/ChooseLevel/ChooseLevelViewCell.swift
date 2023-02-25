//
//  ChooseLevelViewCell.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 26/2/23.
//

import UIKit

class ChooseLevelViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var blueCount: UILabel!
    @IBOutlet var gameModeLabel: UILabel!
    @IBOutlet var purpleCount: UILabel!
    @IBOutlet var greenCount: UILabel!
    @IBOutlet var blockCount: UILabel!
    @IBOutlet var redCount: UILabel!
    @IBOutlet var orangeCount: UILabel!

    @IBOutlet var ballCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

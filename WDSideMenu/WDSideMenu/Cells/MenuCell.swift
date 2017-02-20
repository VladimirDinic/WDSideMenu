//
//  MenuCell.swift
//  WDSideMenu
//
//  Created by Vladimir Dinic on 2/20/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var menuCellImage: UIImageView!
    @IBOutlet weak var menuCellLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

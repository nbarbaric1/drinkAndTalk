//
//  PlayerTableViewCell.swift
//  Drink & Talk
//
//  Created by Nikola Barbarić on 23.09.2021..
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var playerName: UILabel!

    
    func configureLabel(with name: String){
        playerName.text = name
    }
    
    override func prepareForReuse() {
        playerName.text = ""
    }
}

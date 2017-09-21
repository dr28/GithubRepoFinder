//
//  SwitchCell.swift
//  GithubDemo
//
//  Created by Deepthy on 9/20/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchCell: SwitchCell, didChangeValue value:  Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    weak var delegate: SwitchCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func onSwitchValueChanged(_ sender: Any) {
        switchValueChanged()
    }
    
    func switchValueChanged() {
        delegate?.switchCell?(switchCell: self, didChangeValue: onSwitch.isOn)
    }
}

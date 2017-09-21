//
//  SlidderCell.swift
//  GithubDemo
//
//  Created by Deepthy on 9/20/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

@objc protocol SliderCellDelegate {
    @objc optional func sliderCell(sliderCell: SliderCell, didChangeValue value:  Int)
}

class SliderCell: UITableViewCell {
    
    @IBOutlet weak var starSlider: UISlider!
    @IBOutlet weak var starSliderMaxLabel: UILabel!
    
    weak var delegate: SliderCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func onSliderValueChanged(_ sender: Any) {
        starSliderMaxLabel.text = "\(Int(starSlider.value))"
        delegate?.sliderCell?(sliderCell: self, didChangeValue: Int(starSlider.value))
    }
}

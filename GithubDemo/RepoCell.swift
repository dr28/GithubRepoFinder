//
//  RepoCell.swift
//  GithubDemo
//
//  Created by Deepthy on 9/20/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var forkLabel: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!

    var repo: GithubRepo! {
        didSet {
            if let urlString = repo.ownerAvatarURL,
                let url = URL(string: urlString) {
                avatarImg.setImageWith(url)
            }
            let starString = String(format: "%d", repo.stars ?? 0)
            let forkString = String(format: "%d", repo.forks ?? 0)
            nameLabel.text = repo.name
            descriptionLabel.text = repo.repoDescription
            starLabel.text = starString
            forkLabel.text = forkString
            ownerName.text = repo.ownerHandle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

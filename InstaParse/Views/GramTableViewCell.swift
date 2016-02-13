//
//  GramTableViewCell.swift
//  InstaParse
//
//  Created by Amay Singhal on 2/12/16.
//  Copyright © 2016 CodePath. All rights reserved.
//

import UIKit

class GramTableViewCell: UITableViewCell {

    @IBOutlet weak var gramImage: UIImageView!
    @IBOutlet weak var gramAuthorUsername: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var postedAgoTimeLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!

    var gramMedia: UserMedia! {
        didSet {
            updateCellContent()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        gramImage.contentMode = .ScaleAspectFit
        gramImage.clipsToBounds = true
    }

    private func updateCellContent() {
        likesCount?.text = "\(gramMedia.likesCount)"
        gramAuthorUsername?.text = gramMedia.username
        if let dateCreated = gramMedia.dateCreated {
            postedAgoTimeLabel?.text = DateUtils.getTimeElapsedSinceDate(dateCreated)
        } else {
            postedAgoTimeLabel?.text = ""
        }
        captionLabel?.text = gramMedia.mediaCaption
        gramMedia.setMediaOnImageView(gramImage)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

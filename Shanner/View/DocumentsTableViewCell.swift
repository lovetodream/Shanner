//
//  DocumentsTableViewCell.swift
//  Shanner
//
//  Created by Timo Zacherl on 03.05.22.
//

import UIKit

class DocumentsTableViewCell: UITableViewCell {

    static let reuseIdentifier = String(describing: DocumentsTableViewCell.self)

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!

    @IBAction func shareAction(_ sender: UIButton) {
        #warning("TODO: open share menu")
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        thumbnailImageView.layer.cornerRadius = 10.0
        thumbnailImageView.layer.masksToBounds = true
        thumbnailImageView.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

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
    @IBOutlet weak var shareButton: UIButton!

    weak var viewController: UITableViewController?

    var document: Document? {
        didSet {
            guard let document = document else { return }

            titleLabel.text = document.title
            subtitleLabel.text = (document.pageCount == 1 ? "\(document.pageCount) Page" : "\(document.pageCount) Pages")
            if let subtitle = subtitleLabel.text,
               let formattedDate = document.createdAt?.formatted(date: .abbreviated, time: .shortened),
               let title = titleLabel.text,
               !title.contains(formattedDate) {
                subtitleLabel.text = "\(subtitle) (\(formattedDate)"
            }

            thumbnailImageView.image = document.getPDF()?
                .page(at: 0)?
                .thumbnail(of: imageSize, for: .mediaBox)
            thumbnailImageView.addConstraints([thumbnailImageView.widthAnchor.constraint(equalToConstant: imageSize.width), thumbnailImageView.heightAnchor.constraint(equalToConstant: imageSize.height)])
        }
    }

    let imageSize: CGSize = {
        let dimension = UIScreen.main.bounds.size.width / 8
        return CGSize(width: dimension, height: dimension)
    }()

    @IBAction func shareAction(_ sender: UIButton) {
        guard let document = document else { return }

        let activityViewController = UIActivityViewController(activityItems: [DocumentActivityItemSource(document: document)], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = shareButton
        viewController?.present(activityViewController, animated: true)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialisation code
        thumbnailImageView.layer.cornerRadius = 10.0
        thumbnailImageView.layer.masksToBounds = true
        thumbnailImageView.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

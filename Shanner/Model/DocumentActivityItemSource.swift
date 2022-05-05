//
//  DocumentActivityItemSource.swift
//  Shanner
//
//  Created by Timo Zacherl on 05.05.22.
//

import UIKit
import LinkPresentation

/// The item source used to share documents with some metadata
class DocumentActivityItemSource: NSObject, UIActivityItemSource {
    let document: Document

    init(document: Document) {
        self.document = document
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        document.title as Any
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        document.data
    }

    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        document.title ?? "PDF Document"
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = document.title
        metadata.iconProvider = NSItemProvider(object: UIImage(systemName: "doc.richtext")!)
        return metadata
    }
}

//
//  DocumentActivityItemSource.swift
//  Shanner
//
//  Created by Timo Zacherl on 05.05.22.
//

import UIKit
import LinkPresentation

/// The item source used to share documents with some metadata.
class DocumentActivityItemSource: NSObject, UIActivityItemSource {

    /// The document used in the item source
    let document: Document

    /// Creates an item source with the provided document.
    /// - Parameter document: The document to be used.
    init(document: Document) {
        self.document = document
    }

    /// Returns the placeholder item for the activity.
    /// - Parameter activityViewController: The activity view controller used.
    /// - Returns: The document title.
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        document.title as Any
    }

    /// Returns the data, sent with the activity.
    /// - Parameters:
    ///   - activityViewController: The activity view controller used.
    ///   - activityType: The activity type, the user chose.
    /// - Returns: The document data.
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        document.data
    }

    /// Returns the subject for the activity.
    /// It is used if the user decides to send an email as its subject for example.
    /// - Parameters:
    ///   - activityViewController: The activity view controller used.
    ///   - activityType: The activity type, the user chose.
    /// - Returns: The subject, either the document title or "PDF Document".
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        document.title ?? "PDF Document"
    }

    /// Creates the metadata shown in the activity view.
    /// - Parameter activityViewController: The activity view controller used.
    /// - Returns: The metadata created.
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = document.title
        metadata.iconProvider = NSItemProvider(object: UIImage(systemName: "doc.richtext")!)
        return metadata
    }
}

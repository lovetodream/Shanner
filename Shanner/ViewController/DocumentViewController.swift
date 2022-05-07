//
//  DocumentViewController.swift
//  Shanner
//
//  Created by Timo Zacherl on 05.05.22.
//

import UIKit
import PDFKit
import CoreData

/// The view controller to show the PDF of a document's data.
class DocumentViewController: UIViewController {

    /// The document to show passed in by the parent view controller, most likely ``DocumentsTableViewController``.
    var document: Document!

    /// The managed object context passed in by the parent view controller, most likely ``DocumentsTableViewController``.
    var managedObjectContext: NSManagedObjectContext!

    /// The custom title view for the view's navigation item.
    lazy var titleView = DocumentTitleView(title: document.title)

    /// Sets the title view (``titleView``) with it's action for the navigation item and the PDF as the view's content.
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = titleView
        titleView.buttonView.addTarget(self, action: #selector(editTitle(_:)), for: .touchUpInside)

        let pdfView = PDFView(frame: view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(pdfView)

        guard let pdfData = document.data, let pdfDocument = PDFDocument(data: pdfData) else {
            return
        }

        pdfView.document = pdfDocument

        // Found that the following scale factor fits best by testing different values
        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit * 0.85
        } else {
            pdfView.autoScales = true
        }

        let barButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))
        navigationItem.rightBarButtonItem = barButton
    }

    /// Presents an activity view with a ``DocumentActivityItemSource``.
    /// - Parameter target: The action's target.
    @objc func share(_ target: Any) {
        let activityViewController = UIActivityViewController(activityItems: [DocumentActivityItemSource(document: document)], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityViewController, animated: true)
    }


    /// Presents an alert with a text field to change the title of ``document``.
    /// - Parameter target: The action's target.
    @objc func editTitle(_ target: Any) {
        let alertController = UIAlertController(title: "New Title", message: nil, preferredStyle: .alert)
        alertController.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertController] _ in
            guard let textFields = alertController.textFields,
                  let textField = textFields.first,
                  let newTitle = textField.text else { return }
            self.document.title = newTitle
            try? self.managedObjectContext.save()
            self.titleView.labelView.text = newTitle
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

}

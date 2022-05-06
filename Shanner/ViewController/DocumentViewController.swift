//
//  DocumentViewController.swift
//  Shanner
//
//  Created by Timo Zacherl on 05.05.22.
//

import UIKit
import PDFKit
import CoreData

class DocumentViewController: UIViewController {

    var document: Document!

    var managedObjectContext: NSManagedObjectContext!

    lazy var titleView = DocumentTitleView(title: document.title)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit * 0.85

        let barButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))
        navigationItem.rightBarButtonItem = barButton
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func share(_ target: Any) {
        let activityViewController = UIActivityViewController(activityItems: [DocumentActivityItemSource(document: document)], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityViewController, animated: true)
    }


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

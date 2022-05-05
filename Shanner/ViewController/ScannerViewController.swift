//
//  ScannerViewController.swift
//  Shanner
//
//  Created by Timo Zacherl on 27.04.22.
//

import VisionKit

class ScannerViewController: UIViewController {

    lazy var managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true)
    }

}

// MARK: - Document Camera View Controller Delegate

extension ScannerViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        #warning("TODO: Safe the scanned stuff")

        guard let managedObjectContext = managedObjectContext else {
            dismissToDocuments()
            return
        }

        _ = Document(context: managedObjectContext, scan: scan)
        try? managedObjectContext.save()
        dismissToDocuments()
    }

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        dismissToDocuments()
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        dismissToDocuments()
    }

    /// Dismisses the view controller and changes to the documents tab if possible
    /// - Parameter animated: Dismiss with or without animation
    func dismissToDocuments(animated: Bool = true) {
        dismiss(animated: animated)
        tabBarController?.selectedIndex = 1
    }
}

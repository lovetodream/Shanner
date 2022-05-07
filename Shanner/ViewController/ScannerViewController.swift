//
//  ScannerViewController.swift
//  Shanner
//
//  Created by Timo Zacherl on 27.04.22.
//

import VisionKit

/// The view controller to show the document scanner.
class ScannerViewController: UIViewController {

    /// Gets the managedObjectContext from ``AppDelegate``.
    lazy var managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    /// Creates a document camera view controller, sets its delegate and presents it.
    /// - Parameter animated: Indicates if the appearance should be animated or not.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: animated)
    }

}

// MARK: - Document Camera View Controller Delegate

extension ScannerViewController: VNDocumentCameraViewControllerDelegate {
    /// Called if data was scanned successfully. It saves a new ``Document`` to core data and calls ``dismissToDocuments(animated:)`` when done.
    /// - Parameters:
    ///   - controller: The associated view controller.
    ///   - scan: The document scanned by the user.
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard let managedObjectContext = managedObjectContext else {
            dismissToDocuments()
            return
        }

        _ = Document(context: managedObjectContext, scan: scan)
        try? managedObjectContext.save()
        dismissToDocuments()
    }

    /// Called if the user cancelled scanning. It calls ``dismissToDocuments(animated:)``.
    /// - Parameter controller: The associated view controller.
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        dismissToDocuments()
    }

    /// Called if an error happened while scanning. It calls ``dismissToDocuments(animated:)``.
    /// - Parameters:
    ///   - controller: The associated view controller.
    ///   - error: The error which occurred.
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

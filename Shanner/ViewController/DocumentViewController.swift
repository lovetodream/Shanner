//
//  DocumentViewController.swift
//  Shanner
//
//  Created by Timo Zacherl on 05.05.22.
//

import UIKit
import PDFKit

class DocumentViewController: UIViewController {

    var document: Document!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = document.title

        let pdfView = PDFView(frame: view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(pdfView)

        guard let pdfData = document.data, let pdfDocument = PDFDocument(data: pdfData) else {
            return
        }

        pdfView.document = pdfDocument

        // Found that the following scale factor fits best by testing different values
        pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit * 0.85
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

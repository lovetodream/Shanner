//
//  Document.swift
//  Shanner
//
//  Created by Timo Zacherl on 29.04.22.
//

import Foundation
import VisionKit
import PDFKit
import CoreData

extension Document {

    /// Creates a pdf document from a scan.
    /// **Be aware that this method does not safe the document to Core Data.**
    /// - Parameter scan: the scan which should be converted to a pdf
    /// - Returns: the created document
    static func createPDF(from scan: VNDocumentCameraScan) -> PDFDocument {
        let pdfDocument = PDFDocument()
        for pageIndex in 0..<scan.pageCount {
            if let pdfPage = PDFPage(image: scan.imageOfPage(at: pageIndex)) {
                pdfDocument.insert(pdfPage, at: pageIndex)
            }
        }
        return pdfDocument
    }

    /// Returns a PDF document from the data stored in the Document, if non is available or can't be constructed, it returns nil.
    /// - Returns: A PDF document if available
    func getPDF() -> PDFDocument? {
        guard let pdfData = data else { return nil }
        return PDFDocument(data: pdfData)
    }

    /// Initialises a document from a scan and inserts it into the given context.
    /// - Parameters:
    ///   - context: The context into which the document should be inserted.
    ///   - scan: The VNDocumentCameraScan used to create the document.
    convenience init(context: NSManagedObjectContext, scan: VNDocumentCameraScan) {
        self.init(context: context)
        let pdf = Self.createPDF(from: scan)
        self.data = pdf.dataRepresentation()
        self.pageCount = Int16(pdf.pageCount)
        self.createdAt = .now

        guard let createdAt = self.createdAt else { return }

        self.title = "Scan \(createdAt.formatted(date: .abbreviated, time: .shortened))"
    }

}

//
//  DocumentsTableViewController.swift
//  Shanner
//
//  Created by Timo Zacherl on 02.05.22.
//

import UIKit
import CoreData

/// The table view controller, responsible to show all the documents stored in core data.
class DocumentsTableViewController: UITableViewController {

    var documents = [Document]()
    var filteredDocuments = [Document]()
    var selectedDocument: Document?

    var searchController = UISearchController(searchResultsController: nil)

    /// Gets the managedObjectContext from ``AppDelegate``.
    /// - Throws: If ``AppDelegate`` does not exist, a fatal error will be thrown.
    lazy var managedObjectContext: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("AppDelegate missing") }
        return appDelegate.persistentContainer.viewContext
    }()

    /// Indicates if the user filters the documents at the moment.
    var isFiltering: Bool {
      return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }

    /// Loads the view, adds an edit button, sort button  and ``searchController`` to the navigation item.
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: DocumentsTableViewCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: DocumentsTableViewCell.reuseIdentifier)

        self.navigationItem.rightBarButtonItem = self.editButtonItem

        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Documents"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(reverseDocuments(_:)))
    }

    /// Fetches the documents and stores them in ``documents``, once done it reloads the table view.
    /// - Parameter animated: Indicates if the appearance should be animated or not.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let fetchRequest = Document.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Document.createdAt, ascending: false)]

        do {
            documents = try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch documents. \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    /// Sets the number of sections to one.
    /// - Parameter tableView: The table view.
    /// - Returns: The number of sections, which is one.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /// Sets the number of rows to the amount of ``documents`` or ``filteredDocuments``, based on ``isFiltering``.
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: The index of the current section.
    /// - Returns: The amount of documents to show.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredDocuments.count : documents.count
    }

    /// Sets the cell and its content for a certain row.
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - indexPath: The index path, (section and row).
    /// - Returns: The configured ``DocumentsTableViewCell``.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DocumentsTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? DocumentsTableViewCell else {
            fatalError("The cell with reuse identifier \(DocumentsTableViewCell.reuseIdentifier) is not implemented!")
        }

        let document = currentDocument(for: indexPath)
        cell.document = document
        cell.viewController = self

        return cell
    }

    /// Sets the selected document and performs a segue on row selection.
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - indexPath: The index path, (section and row).
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDocument = currentDocument(for: indexPath)
        performSegue(withIdentifier: "showDocument", sender: self)
    }

    /// Deletes the document at the indexPath, if the editing style is delete, otherwise nothing happens.
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - editingStyle: The editing style, committed by the user.
    ///   - indexPath: The index path.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let document = currentDocument(for: indexPath)
            managedObjectContext.delete(document)
            try? managedObjectContext.save()
            if (isFiltering) { filteredDocuments.removeAll { $0.id == document.id } }
            documents.removeAll { $0.id == document.id }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    /// Does preparation before the segue "showDocument" with ``DocumentViewController`` as its destination, otherwise nothing happens.
    /// - Parameters:
    ///   - segue: The segue, containing it's identifier and destination.
    ///   - sender: The sender, which triggered the segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard segue.identifier == "showDocument",
              let selectedDocument = selectedDocument,
              let destinationViewController = segue.destination as? DocumentViewController else {
            return
        }

        destinationViewController.document = selectedDocument
        destinationViewController.managedObjectContext = managedObjectContext
    }

    /// Reverses ``documents`` and if applicable ``filteredDocuments``.
    /// - Parameter target: The action's target.
    @objc func reverseDocuments(_ target: Any) {
        documents.reverse()
        if (isFiltering) { filteredDocuments.reverse() }
        tableView.reloadData()
    }

}

extension DocumentsTableViewController: UISearchResultsUpdating {

    /// Updates the search results by filtering the documents and reloads the table view.
    /// The filtering happens based on the search text being part of the document title.
    /// - Parameter searchController: The affected search controller.
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filteredDocuments = documents.filter { document in
            guard let title = document.title else { return false }
            return title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }

    /// Gets the current document for the provided index path, based on ``isFiltering``.
    /// - Parameter indexPath: The index path  to use.
    /// - Returns: A document.
    func currentDocument(for indexPath: IndexPath) -> Document {
        isFiltering ? filteredDocuments[indexPath.row] : documents[indexPath.row]
    }

}

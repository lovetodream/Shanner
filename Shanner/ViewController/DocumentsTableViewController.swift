//
//  DocumentsTableViewController.swift
//  Shanner
//
//  Created by Timo Zacherl on 02.05.22.
//

import UIKit
import CoreData

class DocumentsTableViewController: UITableViewController {

    var documents = [Document]()
    var filteredDocuments = [Document]()
    var selectedDocument: Document?

    var searchController = UISearchController(searchResultsController: nil)

    lazy var managedObjectContext: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("AppDelegate missing") }
        return appDelegate.persistentContainer.viewContext
    }()

    var isFiltering: Bool {
      return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: DocumentsTableViewCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: DocumentsTableViewCell.reuseIdentifier)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredDocuments.count : documents.count
    }

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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDocument = currentDocument(for: indexPath)
        performSegue(withIdentifier: "showDocument", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
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

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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

    @objc func reverseDocuments(_ target: Any) {
        documents.reverse()
        if (isFiltering) { filteredDocuments.reverse() }
        tableView.reloadData()
    }

}

extension DocumentsTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filteredDocuments = documents.filter { document in
            guard let title = document.title else { return false }
            return title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }

    func currentDocument(for indexPath: IndexPath) -> Document {
        isFiltering ? filteredDocuments[indexPath.row] : documents[indexPath.row]
    }

}

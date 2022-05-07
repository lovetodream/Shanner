# Shanner

> Share + Scanner = Shanner

An app to scan and share documents created as the final project for CS50.

View the instruction video [here](TODO)TODO.


## Run Locally

To run the App on your iPhone or iPad, you'll need to clone the Project to your Mac and open `Shanner.xcodeproj` with Xcode. Select the device you want to use on the toolbar at the top and press the run button. You might need to change the Team on the Signing & Capabilities tab of the project file. **The app only runs on physical devices, because it uses the device's camera.**


## Documentation

The App uses [CoreData](https://developer.apple.com/documentation/coredata) for Storage and [UIKit](https://developer.apple.com/documentation/uikit) for the User Interface along with [VisionKit](https://developer.apple.com/documentation/visionkit) to provide the scanning experience.

The `Shanner` folder contains the Source Code. It's seperated in `Delegate`, `Model`, `View` and `ViewController`.

### Delegate

This contains the [`AppDelegate`](https://timozacherl.com/Shanner/documentation/shanner/appdelegate) and [`SceneDelegate`](https://timozacherl.com/Shanner/documentation/shanner/scenedelegate), those classes are basically what Apple provides by default.

### Model

This contains an extension to [`Document`](https://timozacherl.com/Shanner/documentation/shanner/document) (Core Data Model) and [`DocumentActivityItemSource`](https://timozacherl.com/Shanner/documentation/shanner/documentactivityitemsource) (used for sharing documents).

### View

This contains the following:
- [`DocumentTitleView`](https://timozacherl.com/Shanner/documentation/shanner/documenttitleview): The title for the document detail view.
- [`DocumentsTableViewCell`](https://timozacherl.com/Shanner/documentation/shanner/documentstableviewcell): The cell for the documents table view.

### ViewController

This contains the following:
- [`DocumentViewController`](https://timozacherl.com/Shanner/documentation/shanner/documentviewcontroller): The view controller for viewing a single document.
- [`DocumentsTableViewController`](https://timozacherl.com/Shanner/documentation/shanner/documentstableviewcontroller): The view controller for a list of documents.
- [`ScannerViewController`](https://timozacherl.com/Shanner/documentation/shanner/scannerviewcontroller): The view controller for the scanner.

### Full Documentation

For convenience a detailed documentation for the App is available [here](https://timozacherl.com/Shanner/documentation/shanner/). It is generated using [DocC](https://developer.apple.com/documentation/Xcode/distributing-documentation-to-external-developers).

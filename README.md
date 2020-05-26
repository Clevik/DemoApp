# DemoApp
Special application with sample code.

## Requirements

### General

* __External libraries or components shouldn't be used__. Only defaults iOS components allowed.
  
* Minimal supported iOS version is 12.4.
* App should be localized on English and Russian.
* There should be no memory leaks in the project.
* App should store all data.

### UI

* The application should display the top bar with the name of the active screen.
* The application should display the bottom menu (TabBar) with two items: List and Service.

#### The List screen

This screen should contain the next elements:

* List of items.
* _Each item should contain:_
  * Icon
    _The icon will depend on the checkbox state._
  * Name
  * Checkbox
* Add button should open List Item screen.
* After tap on the item should open List Item screen in editing mode.
* Add swipe menu
  * Left item - Edit
  * Right item - Delete

#### The List Item screen

This screen should contain the next elements:

* Buttons:
  * Back
  _If text field contains any data, an alert should be reflected. The alert should offer to save the item._
  * Cancel
  _Revert all changes and back to the List screen._
  * Save
  _Save all changes and back to the List screen._

### The Service screen

This screen should contain the next elements:

* List of items.

Data for the table can be downloaded from XML - https://www.w3schools.com/xml/cd_catalog.xml
Data should be download in a background stream.
The downloading process should be reflected on the screen.


## Notes from the author

* In the project using CoreData for storing entered items.
* VIP pattern applied.
* Reactive approach for the list screen without RxSwift/RxCocoa.
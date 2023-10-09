# KeysocCodeTest
Tools/library used in this code test project:

Snapkit: Simple ui constraints setting

PagingKit: Switch in top tab bar

Realm: Local storage (bookmark function)

Rxswift: Data binding for listing

This project used rxswift as data binding to the tableView, by creating a data relay(displayList) in view model, and bind it to the table view as data source, any update in the displayList will update the table view data source 

Search Listing: Any update in the search bar input text & stop editing for 1 second will trigger the fetch function in view model, the fetch function will be triggered for 3 times if it is trigger by search text update, search for song, album and artist, store as instance variable in view model, then update the displayList, then the table view will be updated

Filtering: Using Paging Kit to create the tab bar, any click action will be detected by the library and trigger the delegate function which has the index of the tabbed element
Here the project has 3 filters; songs, albums, artist, therefore the index will be 0, 1, 2
if index 0 tabbed, displayList will assign songList, then table view update the data source as song list, same logic in albumList and artistList

Pagination: Impletmented by the table view "willDisplay" delagate, this delegate will give the tableview cell and indexPath of next coming up cell as input
simply check if it is the last cell in the data source, if yes, increase the page size by 20 then fetch for new data, update the relay then the table view will be updated



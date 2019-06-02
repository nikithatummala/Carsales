# Carsales 🚙 

A sample Carsales app written in Swift and used CocoaPods for fetching images from server.

A cars list screen displays the list of cars by loading data from a REST API. 
A detail screen is shown when user taps on the listing cell.

The car list page shows details like car image, car name, car price and location.
The car detail page again loads data from REST API and shows multiple photos of the car which are horizontally scrollable from left to right, location, price, sale status and overview with different font sizes for iPhone and iPad.

The number of cells shown per row changes with landscape & potrait modes in both iPhone and iPad.

The images in the car list view are fetched and saved in app memory. The images are cleared from memory when app is killed and relaunched.
The images in the car detail view are fetched every time the page is opened and stored in cache. 

When there is no network connection an error message is displayed on the screen and data is displayed when network is reconnected.

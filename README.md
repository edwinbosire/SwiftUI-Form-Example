# SwiftUI-Form-Example

This is an example project utilizing the new Form object in SwiftUI (Beta2) release on the 17th June.

The `Form` is a generic structure that is used as a container for grouping controls used for data entry, such as in settings or inspectors.

The `Form` automatically adapts to the platform, on iPhone, they appear as grouped lists, using a `Section` object to create a hierarchical view content. On first look it looks exactly like a `UITableView` or `List` container in SwiftUI, and it's probably based off the latter, but it comes with a lot more formatting goodies some of which have been addressed below.

In this example we explore some properties of the Form which include.
- Sections
- Responding to state changes
- Data input
- Data pickers
- Auto styling of form elements

As a bonus, I've implemented a `Bindable` data object to fully utilise SwiftUI capabilities.
I've also included a function to send the order to a fictious server that responds with the exact same payload.

![image-of-running-sample-app](img/1-Sample-app.png)
![image-of-running-sample-app-dynamic-list](img/2-dynamic-list-content.png)
![image-of-running-sample-app-picker](img/3-picker-view-detail-view.png)


All credit to [Paul Hudson](https://twitter.com/twostraws) for this wonderful tutorial

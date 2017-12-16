# Viewstate

An example Swift project detailing an architecture with view state, reducers, and interactors.

Explained in detail in the blog post series:

1. [Modeling View State](http://twocentstudios.com/2017/07/24/modeling-view-state/)
2. [Transitioning Between View States Using Reducers](http://twocentstudios.com/2017/08/02/transitioning-between-view-states-using-reducers/)
3. [Asynchronous Changes to View Models Using Interactors](http://twocentstudios.com/2017/11/05/interactors/)
4. [Simple Intelligent UITableView Diffing](http://twocentstudios.com/2017/12/16/simple-intelligent-uitableview-diffing/)

## Preview

<video src="http://twocentstudios.com/images/view_controller_with_interactor-normal_load.mov" controls preload="none" poster="http://twocentstudios.com/images/view_controller_with_interactor-normal_load-poster.png" height="600"></video>
<video src="http://twocentstudios.com/images/view_controller_with_interactor-failed.mov" controls preload="none" poster="http://twocentstudios.com/images/view_controller_with_interactor-failed-poster.png" height="600"></video>

## Getting started

1. Clone the repo. `$ git clone git://github.com/twocentstudios/viewstate.git`.
2. Install the pods. `$ bundle exec pod install`.
3. Open `viewstate.xcworkspace`.
4. Build!

## Requirements

* Swift 4
* [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift)
* [Differ](https://github.com/tonyarnold/Differ)

## License

MIT License for source.
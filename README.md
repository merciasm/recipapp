# recipapp

An app that fetches a list of recipes from https://dummyjson.com/recipes/ and display them in a list/detail pattern.

## Work Environment

- Swift 5.10
- Xcode 15.3

## Dependencies

This project uses **Swift Package Manager** to manage its dependencies. 

### Alamofire

[Alamofire](https://github.com/Alamofire/Alamofire) is an HTTP networking library written in Swift.

### RxSwift

[RxSwift](https://github.com/ReactiveX/RxSwift) is a generic abstraction of computation expressed through Observable<Element> interface, which lets you broadcast and subscribe to values and other events from an Observable stream.

### Realm

[Realm](https://github.com/realm/realm-swift) is a mobile database that runs directly inside phones, tablets or wearable

The user can mark which recipes it has already prepared.
The app should use Retrofit to fetch the recipes and Realm as a local DB, both using RxSwift to interface with the app. We suggest using MVVM as architecture.
As an extra, we suggest you add tests to the app, using whatever framework you feel more comfortable with.

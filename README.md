# RefluxCocoa

[![Version](https://img.shields.io/cocoapods/v/RefluxCocoa.svg?style=flat)](http://cocoapods.org/pods/RefluxCocoa)
[![License](https://img.shields.io/cocoapods/l/RefluxCocoa.svg?style=flat)](http://cocoapods.org/pods/RefluxCocoa)
[![Platform](https://img.shields.io/cocoapods/p/RefluxCocoa.svg?style=flat)](http://cocoapods.org/pods/RefluxCocoa)

RefluxCocoa is an implementation of [Reflux](https://github.com/reflux/refluxjs) in Objective-C. To put it simply, it is to introduce a more functional programming style architecture by eschewing MVC like pattern and adopting a single data flow pattern.

```
╔═════════╗       ╔════════╗       ╔═════════════════╗
║ Actions ║──────>║ Stores ║──────>║ View Components ║
╚═════════╝       ╚════════╝       ╚═════════════════╝
     ^                                      │
     └──────────────────────────────────────┘
```
The pattern is composed of actions and data stores, where actions initiate new data to pass through data stores before coming back to the view components again. If a view component has an event that needs to make a change in the application's data stores, they need to do so by signaling to the stores through the actions available.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

**Minimum iOS Target**: iOS7.

## Installation

RefluxCocoa is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "RefluxCocoa"
```

## Author

RefluxCocoa is developed by my former colleague Liu Yaodong and me(Wang Jianfei).

## License

RefluxCocoa is available under the MIT license. See the LICENSE file for more info.

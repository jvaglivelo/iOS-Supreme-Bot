# iOS Supreme Bot
###### A Free (and open source) Supreme Bot for iOS

---

## Features
* Supports multiple items in one cart
* All front end based, no web requests
* Uses JSON to quickly find color and size information
* Adds item to cart in 2 seconds (add additional second for every extra item)
* Compatible with Swift 5.0

## Disclaimers
* This bot is not guaranteed to work properly (it will most likely need some work done)
* It is stripped down to be very basic. The only way to edit information is by editing the Supreme.swift file
* I am not responsible for any misuse of this project, it is distributed AS-IS
* I am in no way affiliated with Supreme New York or any of their associates

## Installation
1. Clone the repository
2. Open the iOS-Supreme-Bot.xcworkspace and change the Signing and Capabilities tab in order to build / install the app.

## Usage
1. Modify the beginning of Supreme.swift to match your desired information.
2. Run the bot by tapping Run.
3. Feel free to modify and build upon the bot.

Notes:
* If an item does not have a size, use "n/a" as size.
* Sizes are specific. Ex: "large" will only look for large. It is checking for exact instead of contains to make sure "large" does not cart an "xlarge".
* Only tested for US region. Support for other regions included, but untested.

## Support
* If there is an issue, create a pull request or an issue and I will look into it.
* New features are not likely to be added.
* In-Store registration bot will likely be released at a later point in time (separate project).

## Screenshots
<img src="/img/log2.png" width="350" />

**Two items checked out in 3 seconds (0 checkout delay)**

<img src="/img/log1.png" width="350" />

**One item checked out in 2 seconds (0 checkout delay)**

[Video of the bot running adding two items to the cart in 4 seconds (site was a little slow)](https://www.youtube.com/watch?v=3Zg67F4O4yI&feature=youtu.be)


# License

Copyright 2020 Jordan Vaglivelo

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

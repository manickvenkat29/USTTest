# USTTest - iOS App

This is an iOS application developed in Objective-C and Swift 5. The app allows users to log in using Google OAuth 2.0 and discover AirPlay devices on their network.


## Features

- **Login Screen**: Users can log in using Google OAuth 2.0 authentication.
- **mDNS Discovery**: Automatically discover AirPlay devices on the local network.
- **Core Data Storage**: Persist discovered devices using Core Data.
- **Detail Screen**: View details of the selected device, including its public IP address and geographical information.

## Technologies Used

- **Programming Languages**: Objective-C, Swift 5
- **UI Framework**: UIKit with Storyboard
- **Networking**: NSURLSession for API calls
- **Data Persistence**: Core Data for storing discovered devices
- **Authentication**: OAuth 2.0 for Google sign-in
- **Service Discovery**: mDNS (Multicast DNS) using NSNetService

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/manickvenkat29/USTTest.git

2. **Open the project in Xcode:**

Navigate to the project directory and open the .xcworkspace file.
3. **Install any dependencies :**

To install the required dependencies for this project, you can use CocoaPods. Add the following line to your `Podfile`:

  pod 'GoogleSignIn', '~> 6.0'

  pod install

4. **Run the App**
Open the .xcworkspace file created by CocoaPods.
Select the appropriate simulator or physical device.
Build and run the app by clicking the play button or using the keyboard shortcut Command + R.

## Usage
- **Login**: Open the app and tap the "Login with Google" button to authenticate.
- **Discover Devices**: Once logged in, the app will automatically discover AirPlay devices on your network and display them in a list.
- **View Device Details**: Tap on any discovered device to view more details, including the public IP address and geographical information.

## Project Structure
USTTest
├── USTTest.xcodeproj             # Xcode project file
├── AppDelegate.m                 # Application delegate
├── HomeViewController.swift       # Home screen controller
├── LoginViewController.swift      # Login screen controller
├── DetailViewController.swift     # Detail screen controller
├── DeviceTableViewCell.swift      # Custom table view cell for devices
├── Device.swift                   # Device model
├── CoreDataManager.swift          # Core Data manager
└── DeviceDiscoveryManager.swift    # mDNS discovery manager



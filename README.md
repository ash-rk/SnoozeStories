# Snooze Stories IOS App

Welcome to the GitHub repository for the Snooze Stories iOS app! This app uses a local Large Language Model (LLM) to generate captivating bedtime stories for children, offering a unique storytelling experience inspired by the visual ease of platforms like Netflix while ensuring complete privacy.

## Table of Contents
- [App Overview](#app-overview)
- [Features](#features)
  - [Current Features](#current-features)
  - [Incomplete Features](#incomplete-features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Model Download](#model-download)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## App Overview

Snooze Stories provides an intuitive platform where users can craft stories by setting themes, emotional tones, and characters, specifically tailored for their children. By leveraging a locally hosted LLM, the app ensures all data remains private, addressing potential privacy concerns for parents.

### Features

#### Current Features:
- **Story Generation**: Leveraging a locally hosted LLM to generate personalized stories securely on the device.
- **Sign in with Apple**: Ensures a seamless and secure login experience.
- **User-Friendly Interface**: Easy-to-navigate interface, with sections to define themes, settings, moods, and characters.
- **Privacy-Focused**: The local model ensures that all story generation is completely private, with no data leaving the device.
## App Interface

Below are some key screenshots from the Bedtime Tales app, showcasing the intuitive and user-friendly design:

### App Screenshots

Here are some key screenshots from the Bedtime Tales app, showcasing various features:

<p float="left">
  <img src="/assets/generate.png" width="250" alt="Story Creation Screen" title="Story Creation Screen"/>
  <img src="/assets/library.png" width="250" alt="Library Dashboard" title="Library Dashboard"/>
  <img src="/assets/login.png" width="250" alt="Sign In With Apple" title="Secure Sign In"/>
</p>

- **Story Creation Screen**: Allows users to set themes, choose settings, and define characters for their stories.
- **Library Dashboard (Under Development)**: Will soon allow users to store and revisit their generated stories.
- **Sign In With Apple**: Illustrates the secure and seamless sign-in process using Apple's system.


Illustrating the secure and seamless sign-in process using Apple's sign-in system.

#### Incomplete Features:
- **Library Dashboard**: Currently shows dummy data, intended for future development to store and categorize generated stories.

## Getting Started

### Prerequisites
- iOS 17.0 or later
- Swift 5
- Xcode 15 or later

### Installation
Clone the repository and open the project in Xcode:

```bash
git clone https://github.com/ash-rk/Snooze-Stories.git
cd Snooze-Stories
open Snooze Stories.xcodeproj
```

### Model Download
To fully utilize the story generation capabilities of the Snooze Stories app, download the required LLM model:
- Model Name: **Phi-3-mini-128k-instruct.IQ4_NL.gguf**
- Download Link: [Hugging Face - Phi-3-mini-128k-instruct](https://huggingface.co/PrunaAI/Phi-3-mini-128k-instruct-GGUF-Imatrix-smashed)
- Copy the downloaded model into Models folder

Follow the link and select the specific model file to download for best results. Integrate the model into your local project setup as per the included instructions.

Run the app in the iOS Simulator or on a real device. Also, modify the the plist file with your own keys

## Contributing
We warmly welcome contributions to the Snooze Stories project, particularly in areas that will enhance user experience and functionality:
- **Library Dashboard Development**: Help develop a functional library for managing generated stories.
- **UI Enhancements**: Improve the interactivity and user-friendliness of the interface.
- **Feature Extensions**: Enhance story generation features or add new customization options.

## License
This project is licensed under the MIT License

## Acknowledgments
- A special thanks to [LLMFarm](https://github.com/guinmoon/LLMFarm) for some of the code used in this project. Their work on large language models has been instrumental in the development of our story generation features.
- Inspiration from various storytelling platforms.
- Thanks to all contributors and supporters of the project.

Thank you for visiting the Snooze Stories GitHub page. We hope you join us in bringing the magic of storytelling to children with the utmost privacy and security. Happy coding!


# Angry Mark Game

## Overview

**Angry Mark** is a mobile game inspired by the classic "Angry Birds" mechanics. The game features a slingshot mechanic where players launch a character to destroy obstacles and targets. The game includes various levels, unique characters with special abilities, and a smooth zoom effect that adjusts based on the character's focus.

## Features

- **Slingshot Mechanic**: Use a slingshot to launch the character and destroy structures.
- **Destructible Obstacles**: Interact with various obstacles including glass and wood.
- **Smooth Zoom Effect**: Adjusts dynamically based on the character's position.
- **Background Image**: Custom background with seamless tiling.
- **Character Abilities**: Unique characters with different launching and destruction abilities.
- **Game Controls**: Zoom in and out using intuitive buttons.

## Getting Started

### Prerequisites

- **Flutter**: Ensure you have Flutter SDK installed. [Installation Guide](https://flutter.dev/docs/get-started/install)
- **Dart**: Compatible with Dart SDK bundled with Flutter.
- **Visual Studio Code**: Recommended for development. [Installation Guide](https://code.visualstudio.com/)

### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/ezeanyimhenry/angry_mark.git
    ```

2. Navigate into the project directory:

    ```bash
    cd angry_mark
    ```

3. Install dependencies:

    ```bash
    flutter pub get
    ```

4. Run the application:

    ```bash
    flutter run
    ```

## Development

### Building the App

To build the app for release:

- For Android:

    ```bash
    flutter build apk
    ```

- For iOS:

    ```bash
    flutter build ios
    ```

### Customizing the Game

- **Background Image**: Replace `assets/images/game-background.jpeg` with your desired background image.
- **Character and Obstacle Design**: Modify the `Character` and `Obstacle` classes in `lib/character.dart` and `lib/obstacle.dart` respectively.

## Contributing

We welcome contributions! Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch:

    ```bash
    git checkout -b feature/YourFeature
    ```

3. Make your changes and commit them:

    ```bash
    git commit -am 'Add new feature'
    ```

4. Push to the branch:

    ```bash
    git push origin feature/YourFeature
    ```

5. Create a new Pull Request.

## Download the Demo

### APK Download
- [Download APK](https://drive.google.com/drive/folders/1Hv5Wq9nV_E2Iv5JVMCxFBhpSd3b-7VTw?usp=sharing)

### Appetize.io Demo
- [View Demo](https://appetize.io/app/b_3kqlb4rylr2irwvi2per32hxk4)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

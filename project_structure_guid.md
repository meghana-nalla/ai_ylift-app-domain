# Project Structure Guide

Our goal is to ensure that our Flutter project structure is well-organized and modular. This will help maintain clean code and facilitate ease of development and scalability. This document will assist in keeping the project divided into clear modules, making it easy to maintain and scale. 

The main focus is on the separation of concerns. Different aspects, such as business logic (controllers), data models, UI (presentation), and utilities, need to be well-separated. The project also uses centralized exports, with `z-index_export.dart` files in various folders for cleaner imports in other parts of the application.

It's important to note that creating comprehensive models and components is essential for a complex and feature-rich application. For example, having an extensive list of models under `api` demonstrates that even if we don't immediately use them, they might be needed in the future. As the application grows beyond an e-commerce platform, it's good practice to create solutions that will benefit the platform later.

Following the documentation laid out here will provide a solid foundation for a large-scale Flutter application, ensuring maintainability and scalability.

## Primary Folders

Inside our `lib` folder, we have three primary folders, each with a separation of concerns and domain specifics:

- **Core Folder**: Business Logic
- **Model Folder**: Model Data (aka Types)
- **Presentation Folder**: Strictly Views

The 'main.dart' file is the entry point of the application, it initializes the app and sets up initial configurations.

### Core Folder 📁

This folder contains the essential parts of the project, focusing on constants, controllers, providers, routes, services, and utilities.

- 📁 Core
  - 📁 Constants
  - 📁 Controllers
  - 📁 Providers
  - 📁 Routes
  - 📁 Services
  - 📁 Utils

#### 📁 Constants 

Contains files for various constants like authentication settings and rules.

#### 📁 Controllers 

Manages the state and business logic of different parts of the application. Each subfolder (auth, carts, display, products, promotions, quicklinks, user) has its own 'index.dart', which is the main entry point for the respective controller. And 'global.dart' being the global state controller that wraps all other subfolders. 'z-index_export.dart' is the centralized export for controllers.

#### 📁 Providers 

Meant for other state management providers, but empty for now. State is controlled inside the 'controllers' folder.

#### 📁 Routes 

Manages the application static routing. 'index.dart' Main file is for defining routes. However, keep in mind that the in application routing is handled via the global controller >> display controller object. These routes are meant for first entrance routes.

#### 📁 Services 

Contains service classes for API interaction, authentication, device checks, and theming.

#### 📁 Utils 

Utility functions and other general use methods.

### Models Folder 📁

This folder contains data models representing various entities in the application.

- 📁 Api
- 📁 Simple
- 📁 Urls

#### 📁 Api 

Models related to the legacy API which contains a comprehensive list of entities like address, cart, order, product, profile, stream, etc., indicating a robust and feature-rich application with complex data interactions. These are models that are based off of those found inside the ylift_api models directory folder. Being that some models are yet to be implemented the 'z-index-export.dart' file houses all the models in this folder that are currently used by the application. If a model is activated (i.e., used) then it should be reflected inside this z-index-export file.

#### 📁 Simple 

Simplified models are used to build better model organization for specific purposes and simplified views. Here you will find the application models are all in use models like card, cart_info, product_display, etc. Any new data structure or model should be created here.

#### 📁 Urls 

Contains API URL definitions that is used by the Api service. Contains the file 'api.dart' which defines the API endpoints.

### Presentation Folder 📁

This folder focuses on the UI components, layouts, and mixins used throughout the application.

- 📁 Presentation
  - 📁 Components
  - 📁 Layouts
  - 📁 Mixins
  - 📁 Pages_Desktop
  - 📁 Pages_Mobile

#### 📁 Components 

Contains various reusable UI components. Subfolders for specific components like animated_route_display, carousel, counter, hero, image_fallback, menu, products, quick_links, and rotating_profile. And 'z-index_export.dart' for central export for components.

#### 📁 Layouts 

Defines different layouts for desktop and mobile views. 'desktop_view.dart' Desktop-specific layout. 'mobile_view.dart' Mobile-specific layout. It's important to note that in viewing order its main >> layout >> page view

#### 📁 Mixins 

Reusable mixins for shared functionality across multiple widgets. Contains mixins for product_grid_dynamic, promotions, search_bar, shop, single_product, splashs. Typically a mixin is a complex component that uses various other components as its base. Same as components it uses 'z-index_export.dart' as central export for mixins. 

#### 📁 Pages_Desktop 

Pages specific to the desktop view. Note: The view threshold of what's a desktop view needs to be evaluated, as desktop can have responsive display logic built in.

#### 📁 Pages_Mobile 

Pages specific to the mobile view. This view should be limited to mobile phones and not necessarily tablets.

## File and Folder Naming Conventions

### Folder Names
- **Lowercase with words separated by underscores (`_`)**:
  - Examples: `core`, `constants`, `controllers`, `providers`, `services`, `utils`, `models`, `presentation`, `components`, `layouts`, `mixins`, `pages/desktop`, `pages/mobile`.
- **Must Reflect content or functionality**:
  - Folders are named to clearly indicate their purpose.

### File Names
- **Lowercase with words separated by underscores (`_`)**:
  - Examples: `auth0.dart`, `index.dart`, `rules.dart`, `auth.dart`, `device_check.dart`.
- **Underscores for readability**:
  - Examples: `product_grid_dynamic`, `stream_product_mention.dart`.

### Index Files
- **Common use of `index.dart`**:
  - Serves as an entry point for classes within a folder. (see Components Organization for more info.)
- **`z-index_export.dart` files**:
  - Aggregates multiple exports for streamlined importing. (see Components Organization for more info.)

### Component-Specific Files
- **Naming reflects purpose**:
  - Examples: `animated_route_display`, `image_fallback`, `slider_featured`.
- **Type of component included in the name**:
  - Helps in identifying the functionality of the component.

### Model Files
- **Named after entities they represent**:
  - Examples: `address.dart`, `banner.dart`, `cart.dart`, `product.dart`.
- **Reflects database tables or API data structures**:
  - Ensures clarity and ease of maintenance.

### Utilization of Grouped Naming
- **Grouped by related functionality**:
  - Examples: `auth`, `carts`, `products`, `promotions`, `quicklinks` under `controllers` and similarly structured under `models/api`.

### Separation by Platform
- **Platform-specific folders**:
  - Examples: `pages/desktop`, `pages/mobile`.
  - Ensures codebase targeting different platforms is organized.

### Readme Files
- **Documentation within directories**:
  - Examples: `readme.md` in `components`, `mixins`.
  - Provides context or instructions relevant to that part of the codebase.

## Components Organization

We are organizing our Dart project in a way that allows for modular and extensible components.

Inside the components folder we have two types of components. A component that is extensible, 
one that is allowing the component to be built upon if needed. And the other component is a topic base.

This setup keeps your structure clean, focusing on the folder name as the key identifier, 
with the index.dart file serving as the entry point for the component.

We are streamlining the project structure by avoiding redundancy in naming. 
Here's the structure guidance to achieve this approach:

```
lib/
├── components/
│   ├── folderName/
│   │   ├── subfolder/
│   │   │   ├── component1.dart
│   │   │   ├── component2.dart
│   │   │   └── z-index_export.dart  // Exports all components in the subfolder
│   │   ├── index.dart               // Main component built upon subfolder components
│   └── z-index_export.dart      // Exports everything in folderName
```

z-index_export.dart in Subfolder
Exports all the individual components within that subfolder.

```dart
// lib/components/folderName/subfolder/z-index_export.dart
export 'component1.dart';
export 'component2.dart';
```

index.dart
This file represents the main component that can be extended or built upon.

```dart
// lib/components/folderName/store_password_field.dart
import 'subfolder/z-index_export.dart';

class FolderName {
  // Component implementation
}
```

z-index_export.dart in components folder
Exports everything within the folderName, using the index.dart file,
allowing other modules to easily import everything related to this component.

```dart
// lib/components/z-index_export.dart
export 'folderName/store_password_field.dart';
```
 
## Services

The services folder contains several key files that handle various aspects of the application's functionality:

- **api.dart**: Implements the `ApiService` class, which manages HTTP requests using the Dio package. It includes methods for GET, POST, PUT, and DELETE requests, along with error handling and logging.

- **bearer.dart**: Contains the `BearerTokenInterceptor` class, which extends Dio's Interceptor. It automatically adds the bearer token to outgoing requests if the user is authenticated.

- **device_check.dart**: Provides the `WebDeviceService` class with methods to check if the application is running on the web and whether it's a mobile or desktop web environment.

- **jwt.dart**: Implements the `JwtToken` class with static methods for parsing and validating JSON Web Tokens, including header and payload extraction, expiration checks, and token time calculations.

- **kodbox.dart**: Defines the `KodBoxService` class, a singleton that manages application state and persistence. It provides methods for storing, retrieving, and manipulating data, with support for both web (using cookies) and mobile (using SharedPreferences) environments.

These services form the backbone of the application's data management, authentication, and device-specific functionality.



## Global Controllers

The project uses a global controller pattern to manage the application state and business logic. The `GlobalController` serves as the main controller, initializing and coordinating other sub-controllers. This approach allows for a clean separation of concerns and modular state management.

### GlobalController

The `GlobalController` (found in `global.dart`) is responsible for:

- Initializing services (API, Auth0)
- Managing authentication state
- Coordinating other controllers (Products, Promotions, QuickLinks, Display, Cart, Auth0, User)
- Handling global states (e.g., loading states, UI states)
- Managing global data (e.g., active promotions, quick links, best sellers)

### Sub-Controllers

The project uses several sub-controllers, each responsible for a specific domain:

1. **ProductsController**: Manages product-related operations
2. **PromotionsController**: Handles promotion-related functionalities
3. **QuickLinksController**: Manages quick links data
4. **DisplayController**: Controls the app's display logic and navigation
5. **CartController**: Manages shopping cart operations
6. **Auth0Controller**: Handles authentication logic
7. **UserController**: Manages user-related operations

### Creating a New Controller

To create a new controller, follow these steps:

1. Create a new file in the appropriate subdirectory of the `controllers` folder (e.g., `controllers/new_feature/index.dart`)
2. Define your controller class extending `GetxController`
3. Implement the necessary methods and properties
4. Add the controller to the `GlobalController` initialization
5. Export the new controller in `z-index_export.dart`

Example of a new controller:

```dart
// controllers/new_feature/store_password_field.dart
import 'package:get/get.dart';

class NewFeatureController extends GetxController {
  final GlobalController global = Get.find<GlobalController>();

  // Define your controller logic here
  final RxString exampleState = ''.obs;

  void exampleMethod() {
    // Implement your method
  }
}

// In global.dart, add:
late NewFeatureController newFeature;

// In the init() method of GlobalController, add:
newFeature = Get.put(NewFeatureController());

// In z-index_export.dart, add:
export 'new_feature/store_password_field.dart';
```

### Using Controllers in Components

To use a controller in a component, you can access it through the `GlobalController` or directly using Get's dependency injection. Here are examples of both approaches:

1. Accessing through GlobalController:

```dart
class ExampleWidget extends StatelessWidget {
  final GlobalController global = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => global.newFeature.exampleMethod(),
      child: Text('Example'),
    );
  }
}
```

2. Directly accessing a sub-controller:

```dart
class ExampleWidget extends StatelessWidget {
  final NewFeatureController newFeatureController = Get.find<NewFeatureController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(newFeatureController.exampleState.value));
  }
}
```

By following this controller structure, you can maintain a clean and modular architecture for your Flutter application, making it easier to manage state and business logic across different features.

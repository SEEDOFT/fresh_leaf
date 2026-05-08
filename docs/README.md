# FreshLeaf Mobile App Documentation

Welcome to the FreshLeaf Flutter mobile application documentation. This folder contains detailed information about each feature of the consumer-facing mobile app.

## Table of Contents

### Getting Started
- [01. Project Overview](01-project-overview.md) - Tech stack, architecture, project structure

### Core Features
- [02. Modules](02-modules.md) - All GetX modules overview
- [03. Services](03-services.md) - Core services (API, Storage, etc.)
- [04. Models](04-models.md) - Data models
- [05. Routing](05-routing.md) - Navigation and routes

### Feature Documentation
- [06. Authentication](06-authentication.md) - Login, register, PIN security
- [07. Products](07-products.md) - Product browsing and details
- [08. Cart & Checkout](08-cart-checkout.md) - Shopping flow
- [09. Orders](09-orders.md) - Order management
- [10. Wallet](10-wallet.md) - Digital wallet system
- [11. AI Assistant](11-ai-assistant.md) - AI chat feature
- [12. Support Chat](12-support-chat.md) - Customer support
- [13. Profile](13-profile.md) - User profile management
- [14. Notifications](14-notifications.md) - Push notifications
- [15. Realtime](15-realtime.md) - WebSocket services
- [16. Localization](16-localization.md) - EN/KM translations
- [17. State Management](17-state-management.md) - GetX patterns
- [18. API Integration](18-api-integration.md) - API client & endpoints

### Additional
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Common issues and solutions
- [CODING_STANDARDS.md](CODING_STANDARDS.md) - Code conventions

## Quick Start

### Running the App
```bash
# Install dependencies
flutter pub get

# Run with environment config
flutter run --dart-define-from-file=.env.local
```

### Project Structure
```
fresh_leaf/
├── lib/
│   ├── app/
│   │   ├── modules/        # GetX feature modules
│   │   ├── routes/         # Navigation
│   │   └── middlewares/   # Route middleware
│   ├── core/
│   │   ├── services/       # API, storage, etc.
│   │   ├── models/        # Data models
│   │   ├── config/        # App config
│   │   ├── constants/      # Constants
│   │   ├── theme/         # UI theme
│   │   └── localization/   # Translations
│   └── shared/            # Shared widgets
└── docs/                   # This documentation
```

## Tech Stack

| Technology | Purpose |
|------------|---------|
| Flutter stable | UI Framework |
| GetX | State management, routing, DI |
| Dio | HTTP client |
| GetStorage | Local persistence |
| Firebase Cloud Messaging | Push notifications |
| Flutter Map + OpenStreetMap | Maps/address picking |

## Key Concepts

### GetX Module Structure
Each feature follows:
```
module_name/
├── bindings/    # Dependency injection
├── controllers/ # Business logic
├── views/        # UI screens
└── widgets/     # Reusable widgets
```

### State Management
- Controllers extend `GetxController`
- Reactive variables with `.obs`
- Views use `Obx()` widget

### API Communication
- ApiClient for HTTP requests
- Services abstract business logic
- Models with `fromMap()` factory constructors

---

For detailed information, navigate to specific feature documentation.
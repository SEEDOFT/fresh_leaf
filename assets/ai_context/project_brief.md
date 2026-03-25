# Project Brief: FreshLeaf

## App Overview
- Flutter + GetX app for organic grocery browsing, carting, and account flows.
- Uses Gemini via `GeminiAiChatService` for AI assistance.
- Persistent storage via GetStorage (`AiChatStorageService`), API via Dio (`ApiClient`).

## Key Modules
- Auth: lib/app/modules/login, register, auth
- Home/Dashboard: lib/app/modules/home, dashboard
- AI Assistant: lib/app/modules/ai_assistant
- Theming: lib/core/theme/app_colors.dart, app_text_styles.dart
- Routing: lib/app/routes/app_pages.dart, app_routes.dart

## Data/Services
- Gemini chat: lib/core/services/gemini_ai_chat_service.dart
- Persistent chat history: lib/core/services/ai_chat_storage_service.dart
- API client: lib/core/services/api_client.dart (base URL in AppConstants)

## Coding Guidelines
- State mgmt: GetX controllers (extends GetxController)
- UI: Prefer existing widgets/styles; background color `AppColors.background`
- Avoid blocking UI; use streaming for AI responses

## Prompt Hints
- When asked about code, cite file paths and keep answers concise.
- If user asks for code changes, suggest patch-ready snippets.
- If unsure, ask for the specific file or context.

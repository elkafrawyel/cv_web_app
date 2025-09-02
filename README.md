# CV Web App

A professional portfolio web application built with Flutter. This modern, responsive CV showcases personal information, skills, work experience, projects, and contact details with smooth animations and an elegant design.

## Features

### Sections
- **Header Section**: Hero section with personal introduction and call-to-action
- **About Section**: Personal information and professional summary  
- **Skills Section**: Technical skills with interactive animations
- **Work Experience Section**: Professional timeline with detailed experience cards
- **Projects Section**: Portfolio projects with expandable descriptions and tech stacks
- **Contact Section**: Contact information and social links

### UI/UX Features
- **Responsive Design**: Optimized for desktop, tablet, and mobile devices
- **Floating Navigation**: Smooth scrolling navigation bar with section links
- **Dark/Light Theme**: Theme toggle with animated transitions
- **Animations**: Staggered animations, hover effects, and smooth transitions
- **Performance Optimized**: Efficient rendering with RepaintBoundary widgets

## Technical Architecture

### Project Structure
```
lib/
├── main.dart              # App entry point and main layout
├── models/                # Data models
│   ├── project.dart       # Project data model
│   ├── projects_list.dart # Sample project data
│   ├── work_experience.dart # Work experience data model
│   └── work_experience_list.dart # Sample work experience data
├── providers/             # State management
│   └── theme_provider.dart # Theme state management
├── utils/                 # Utility functions
│   └── performance_utils.dart # Performance optimization utilities
└── widgets/              # UI components
    ├── about_section.dart
    ├── contact_section.dart
    ├── floating_nav_bar.dart
    ├── header_section.dart
    ├── loading_widgets.dart
    ├── projects_section.dart
    ├── skills_section.dart
    └── work_experience_section.dart
```

### Key Technologies
- **Flutter**: Cross-platform UI framework
- **Provider**: State management for theme switching
- **Google Fonts**: Custom typography
- **Font Awesome**: Professional icons
- **URL Launcher**: External link handling
- **Staggered Animations**: Enhanced user experience

## Getting Started

### Prerequisites
- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)
- Web browser for testing

### Installation
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run -d chrome
   ```

### Building for Production
```bash
flutter build web
```

## Customization

### Adding Work Experience
Edit `lib/models/work_experience_list.dart` to add your professional experience:

```dart
{
  "company": "Your Company",
  "position": "Your Position",
  "duration": "Jan 2023 - Present",
  "location": "Location",
  "description": "Brief description...",
  "responsibilities": [
    "Key responsibility 1",
    "Key responsibility 2"
  ],
  "technologies": ["Flutter", "Dart", "Firebase"],
  "icon": "FontAwesomeIcons.code",
  "color": "#6366F1",
  "companyUrl": "https://company.com",
  "employmentType": "Full-time"
}
```

### Adding Projects
Edit `lib/models/projects_list.dart` to showcase your projects with similar JSON structure.

### Theming
The app supports automatic dark/light theme switching. Customize themes in `lib/providers/theme_provider.dart`.

## Performance Optimizations
- RepaintBoundary widgets for efficient rendering
- Throttled scroll listeners (60 FPS)
- Lazy loading with "Show More" functionality
- Optimized animations and transitions

## Browser Compatibility
- Chrome (recommended)
- Firefox
- Safari
- Edge

## License

This project is open source and available under the [MIT License](LICENSE).

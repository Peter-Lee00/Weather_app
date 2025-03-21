Weather App

Introduction 
  A simple weather app built using Flutter.
  It fetches real-time weather data using the OpenWeather API.
  
Features 

1. Fetch weather based on current location
2. Search weather by city name
3. Save recent searches
4. Supports dark mode
5. Animated weather icons based on conditions

Project Structure 

 weather_app
 ├── main.dart                 // Main entry point
 ├── pages/
 │   ├── weather_page.dart      // Main UI
 ├── services/
 │   ├── weather_service.dart   // Weather data handling
 ├── models/
 │   ├── weather_model.dart     // Weather data model

Installation & Usage 

1.Clone the project 
 git clone https://github.com/your-username/weather-app.git
 cd weather-app

2. Install dependencies 
flutter pub get

3. Set API Key 
 1. Open weather_service.dart 
 2. Replace 'your_api_key_here' with your actual OpenWeather API key 

4. Run the app 
flutter run

Used dependencies
- Flutter
- Geolocator
- http
- Lottie
  
License
- This project is licensed under the MIT License – feel free to modify and distribute.

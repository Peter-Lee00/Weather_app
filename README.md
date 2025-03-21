날씨 앱 Weather App

Introduction (소개)
  A simple weather app built using Flutter.
  It fetches real-time weather data using the OpenWeather API.
  
  Flutter를 활용하여 제작된 간단한 날씨 앱입니다.
  OpenWeather API를 사용하여 실시간 날씨 정보를 제공합니다.

Features (기능)
Fetch weather based on current location
- 현재 위치 날씨 조회: Geolocator를 이용하여 자동으로 현재 위치의 날씨를 가져옵니다.
Search weather by city name
- 도시 검색 기능: 사용자가 원하는 도시의 날씨를 조회할 수 있습니다.
Save recent searches
- 최근 검색 기록 저장: 검색한 도시를 저장하여 빠르게 다시 검색할 수 있도록 지원합니다.
Supports dark mode
- 다크 모드 지원: UI에서 다크 모드를 지원하여 사용자 환경에 맞게 변경할 수 있습니다.
Animated weather icons based on conditions
- 날씨 애니메이션 표시: 날씨 상태에 따라 Lottie 애니메이션을 표시합니다.

Project Structure (프로젝트 구조)

 weather_app
 ├── main.dart                 // 앱의 진입점 (Main entry point)
 ├── pages/
 │   ├── weather_page.dart      // 메인 UI (Main UI)
 ├── services/
 │   ├── weather_service.dart   // 날씨 데이터 처리 (Weather data handling)
 ├── models/
 │   ├── weather_model.dart     // 날씨 데이터 모델 (Weather data model)



Installation & Usage (설치 및 실행 방법)

1.Clone the project (프로젝트 클론)
 git clone https://github.com/your-username/weather-app.git
 cd weather-app

2. Install dependencies (패키지 설치)
flutter pub get

3. Set API Key (API 키 설정)
 1. Open weather_service.dart (weather_service.dart 파일 실행)
 2. Replace 'your_api_key_here' with your actual OpenWeather API key (api 키 변경)

4. Run the app (실행)
flutter run


Used dependencies
- Flutter: UI 프레임워크
- Geolocator: 위치 정보 가져오기
- http: API 요청 처리
- Lottie: 애니메이션 효과 추가

Upcoming fucntions
- 주간 예보 기능 추가
- 날씨 위젯 제공
- 사용자가 즐겨찾는 도시 목록 저장

License
- This project is licensed under the MIT License – feel free to modify and distribute.


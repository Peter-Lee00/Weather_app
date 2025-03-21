import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app_ver1/models/weather_model.dart';
import 'package:weather_app_ver1/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('APIKEY');
  Weather? _weather;
  bool _isDarkMode = true; // Default to dark mode
  bool _isLoading = false;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();

  // List to store saved cities
  List<String> _savedCities = [];

  // 날씨 정보
  _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // 현재 도시 정보
    String cityName = await _weatherService.getCurrentCity();
    String countryName = await _weatherService.getCurrentCountry();

    // 현재 날씨 정보
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = Weather(
          cityName: weather.cityName,
          temperature: weather.temperature,
          mainCondition: weather.mainCondition,
          countryName: countryName,
        );
        _isLoading = false;
      });
    }

    // 에러 메세지
    catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to get weather for current location';
      });
      print(e);
    }
  }

  // Search for a specific city's weather
  _searchWeather(String cityName) async {
    if (cityName.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final weather = await _weatherService.getWeather(cityName);
      final countryCode = await _weatherService.getCountryCode(cityName);

      setState(() {
        _weather = Weather(
          cityName: weather.cityName,
          temperature: weather.temperature,
          mainCondition: weather.mainCondition,
          countryName: countryCode,
        );

        // Add to saved cities if not already in the list
        if (!_savedCities.contains(cityName) && cityName.isNotEmpty) {
          if (_savedCities.length >= 5) {
            _savedCities.removeAt(0); // Remove the oldest city
          }
          _savedCities.add(cityName);
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'City not found. Please check the spelling.';
      });
      print(e);
    }
  }

  // 날씨 애니메이션
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; //날씨 기본값

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json'; // Fixed typo in path
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // Toggle dark mode
  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  // Show search dialog
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: _isDarkMode ? Colors.grey[850] : Colors.white,
            title: Text(
              'Search City',
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Enter city name',
                    hintStyle: TextStyle(
                      color: _isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: _isDarkMode ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                if (_savedCities.isNotEmpty) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recent searches:',
                      style: TextStyle(
                        fontSize: 14,
                        color: _isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _savedCities.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ActionChip(
                            label: Text(_savedCities[index]),
                            onPressed: () {
                              _searchController.text = _savedCities[index];
                            },
                            backgroundColor: _isDarkMode
                                ? Colors.grey[700]
                                : Colors.blue[100],
                            labelStyle: TextStyle(
                              color:
                                  _isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_searchController.text.isNotEmpty) {
                    Navigator.pop(context);
                    _searchWeather(_searchController.text);
                    _searchController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isDarkMode ? Colors.blue[700] : Colors.blue,
                ),
                child: const Text('Search'),
              ),
            ],
          );
        });
      },
    );
  }

  // Show city options menu
  void _showCityOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _isDarkMode ? Colors.grey[850] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          'Select Location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.add,
                            color: _isDarkMode ? Colors.white : Colors.black87,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _showSearchDialog();
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.my_location,
                      color: _isDarkMode ? Colors.white : Colors.black87,
                    ),
                    title: Text(
                      'Current Location',
                      style: TextStyle(
                        color: _isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _fetchWeather();
                    },
                  ),
                  if (_savedCities.isNotEmpty) const Divider(),
                  // This is the fix: Replace Expanded with a Container of fixed height
                  Container(
                    height: _savedCities.isEmpty
                        ? 0
                        : 200, // Adjust height as needed
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _savedCities.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            _savedCities[index],
                            style: TextStyle(
                              color:
                                  _isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 18,
                              color:
                                  _isDarkMode ? Colors.white70 : Colors.black54,
                            ),
                            onPressed: () {
                              setModalState(() {
                                setState(() {
                                  _savedCities.removeAt(index);
                                });
                              });
                            },
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _searchWeather(_savedCities[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // init state 초기 화면
  @override
  void initState() {
    super.initState();

    // 초기 화면 날씨 정보
    _fetchWeather();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.blue[50],
      appBar: AppBar(
        title: Text(
          'Weather App',
          style: TextStyle(
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        backgroundColor: _isDarkMode ? Colors.grey[850] : Colors.blue[100],
        elevation: 0,
        actions: [
          // Add city button with + icon
          IconButton(
            icon: Icon(
              Icons.add,
              color: _isDarkMode ? Colors.white : Colors.black87,
            ),
            onPressed: _showCityOptionsMenu,
          ),

          // Dark mode toggle
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: _isDarkMode ? Colors.white : Colors.black87,
            ),
            onPressed: _toggleDarkMode,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: _isDarkMode ? Colors.white : Colors.blue,
              ),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 50,
                          color: _isDarkMode ? Colors.white70 : Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage,
                          style: TextStyle(
                            fontSize: 18,
                            color:
                                _isDarkMode ? Colors.white70 : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _fetchWeather,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 도시 이름과 국가 이름
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${_weather?.cityName ?? "Loading city..."}',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color:
                                    _isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_weather?.countryName != null && _weather!.countryName.isNotEmpty ? "(${_weather?.countryName})" : ""}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                                color: _isDarkMode
                                    ? Colors.white70
                                    : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 날씨 애니메이션
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: Lottie.asset(
                            getWeatherAnimation(_weather?.mainCondition)),
                      ),

                      // 온도 - 더 큰 텍스트로 표시
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          '${_weather?.temperature.round() ?? "--"}°C',
                          style: TextStyle(
                            fontSize: 72, // Much larger temperature display
                            fontWeight: FontWeight.bold,
                            color: _isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),

                      // 날씨정보
                      Text(
                        _weather?.mainCondition ?? "",
                        style: TextStyle(
                          fontSize: 24,
                          color: _isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}

class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final String countryName;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    this.countryName = "", // Default empty string
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      // The country name will be set separately from the location service
    );
  }
}

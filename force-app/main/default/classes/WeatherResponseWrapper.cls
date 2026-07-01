public class WeatherResponseWrapper {
    
    // 1. Root-level variables
    public Decimal latitude;
    public Decimal longitude;
    
    // 2. The nested JSON block requires its own custom data type (the inner class)
    public CurrentWeather current_weather;

    // 3. The Inner Class defining what is inside "current_weather"
    public class CurrentWeather {
        public Decimal temperature;
        public Decimal windspeed;
    }
}
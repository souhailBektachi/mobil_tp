package com.example.weatherappxml;

public class MeteoItem {
    private String cityName;
    private double temperature;
    private double feelsLike;
    private int humidity;
    private String weatherCondition;
    private String weatherDescription;
    private String dateTime;

    public MeteoItem() {
    }

    public MeteoItem(String cityName, double temperature, double feelsLike, int humidity, String weatherCondition, String weatherDescription, String dateTime) {
        this.cityName = cityName;
        this.temperature = temperature;
        this.feelsLike = feelsLike;
        this.humidity = humidity;
        this.weatherCondition = weatherCondition;
        this.weatherDescription = weatherDescription;
        this.dateTime = dateTime;
    }

    // Getters and setters
    public String getCityName() {
        return cityName;
    }

    public void setCityName(String cityName) {
        this.cityName = cityName;
    }

    public double getTemperature() {
        return temperature;
    }

    public void setTemperature(double temperature) {
        this.temperature = temperature;
    }

    public double getFeelsLike() {
        return feelsLike;
    }

    public void setFeelsLike(double feelsLike) {
        this.feelsLike = feelsLike;
    }

    public int getHumidity() {
        return humidity;
    }

    public void setHumidity(int humidity) {
        this.humidity = humidity;
    }

    public String getWeatherCondition() {
        return weatherCondition;
    }

    public void setWeatherCondition(String weatherCondition) {
        this.weatherCondition = weatherCondition;
    }

    public String getWeatherDescription() {
        return weatherDescription;
    }

    public void setWeatherDescription(String weatherDescription) {
        this.weatherDescription = weatherDescription;
    }

    public String getDateTime() {
        return dateTime;
    }

    public void setDateTime(String dateTime) {
        this.dateTime = dateTime;
    }
}

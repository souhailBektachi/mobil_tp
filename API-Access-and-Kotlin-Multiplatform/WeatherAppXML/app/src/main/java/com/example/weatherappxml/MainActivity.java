package com.example.weatherappxml;

import android.os.Bundle;
import android.text.format.DateFormat;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.SearchView;
import androidx.appcompat.widget.Toolbar;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Calendar;
import java.util.Locale;

public class MainActivity extends AppCompatActivity {
    
    private static final String TAG = "MainActivity";
    private static final String API_KEY = "e457293228d5e1465f30bcbelaea456b"; 
    private static final String API_URL = "https://api.openweathermap.org/data/2.5/weather";
    
    private TextView tvCityName;
    private TextView tvDateTime;
    private ImageView ivWeatherIcon;
    private TextView tvTemperatureValue;
    private TextView tvFeelsLikeValue;
    private TextView tvHumidityValue;
    private TextView tvWeatherDescriptionValue;
    private android.widget.ProgressBar progressBar;
    
    private RequestQueue requestQueue;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        requestQueue = Volley.newRequestQueue(this);
        
        tvCityName = findViewById(R.id.tvCityName);
        tvDateTime = findViewById(R.id.tvDateTime);
        ivWeatherIcon = findViewById(R.id.ivWeatherIcon);
        tvTemperatureValue = findViewById(R.id.tvTemperatureValue);
        tvFeelsLikeValue = findViewById(R.id.tvFeelsLikeValue);
        tvHumidityValue = findViewById(R.id.tvHumidityValue);
        tvWeatherDescriptionValue = findViewById(R.id.tvWeatherDescriptionValue);
        progressBar = findViewById(R.id.progressBar);
        
        fetchWeatherData("Paris");
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_main, menu);
        
        MenuItem searchItem = menu.findItem(R.id.action_search);
        SearchView searchView = (SearchView) searchItem.getActionView();
        
        searchView.setQueryHint(getString(R.string.search_hint));
        
        searchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
            @Override
            public boolean onQueryTextSubmit(String query) {
                if (query != null && !query.isEmpty()) {
                    fetchWeatherData(query);
                    searchView.clearFocus();
                }
                return true;
            }

            @Override
            public boolean onQueryTextChange(String newText) {
                return false;
            }
        });
        
        return true;
    }
    
    /**
     * Fetch weather data for a given city using Volley.
     * 
     * @param cityName Name of the city to fetch weather data for
     */
    private void fetchWeatherData(String cityName) {
        String url = API_URL + "?q=" + cityName + "&appid=" + API_KEY + "&units=metric";
        
        Log.d(TAG, "Fetching weather data for: " + cityName + " from URL: " + url);
        progressBar.setVisibility(TextView.VISIBLE);

        JsonObjectRequest request = new JsonObjectRequest(Request.Method.GET, url, null,
                response -> {
                    Log.d(TAG, "Response: " + response.toString());
                    progressBar.setVisibility(TextView.GONE);
                    try {
                        parseWeatherData(response);
                    } catch (JSONException e) {
                        Log.e(TAG, "JSON parsing error", e);
                        Toast.makeText(MainActivity.this, getString(R.string.error_parsing), Toast.LENGTH_LONG).show();
                    }
                },
                error -> {
                    Log.e(TAG, "Volley error: ", error);
                    progressBar.setVisibility(TextView.GONE);
                    if (error.networkResponse != null && error.networkResponse.statusCode == 404) {
                        Toast.makeText(MainActivity.this, getString(R.string.error_city_not_found), Toast.LENGTH_LONG).show();
                    } else {
                        Toast.makeText(MainActivity.this, getString(R.string.error_network), Toast.LENGTH_LONG).show();
                    }
                });
        
        requestQueue.add(request);
    }
    
    /**
     * Parse the JSON response and update the UI.
     * 
     * @param response JSONObject response from the API
     * @throws JSONException if JSON parsing fails
     */
    private void parseWeatherData(JSONObject response) throws JSONException {
        String cityName = response.getString("name");
        
        JSONObject mainData = response.getJSONObject("main");
        double tempKelvin = mainData.getDouble("temp");
        double feelsLikeKelvin = mainData.getDouble("feels_like");
        int humidity = mainData.getInt("humidity");
        
        JSONArray weatherArray = response.getJSONArray("weather");
        JSONObject weatherObject = weatherArray.getJSONObject(0);
        String weatherCondition = weatherObject.getString("main");
        String weatherDescription = weatherObject.getString("description");
        
        double tempCelsius = tempKelvin - 273.15;
        double feelsLikeCelsius = feelsLikeKelvin - 273.15;
        
        Calendar calendar = Calendar.getInstance();
        String dateTime = DateFormat.format("yyyy-MM-dd HH:mm", calendar).toString();
        
        MeteoItem meteoItem = new MeteoItem(
                cityName,
                tempCelsius,
                feelsLikeCelsius,
                humidity,
                weatherCondition,
                weatherDescription,
                dateTime
        );
        
        updateUI(meteoItem);
    }
    
    /**
     * Update the UI with weather data.
     * 
     * @param meteoItem Weather data object
     */
    private void updateUI(MeteoItem meteoItem) {
        tvCityName.setText(meteoItem.getCityName());
        tvDateTime.setText(meteoItem.getDateTime());
        tvTemperatureValue.setText(String.format(Locale.getDefault(), "%.1f°C", meteoItem.getTemperature()));
        tvFeelsLikeValue.setText(String.format(Locale.getDefault(), "%.1f°C", meteoItem.getFeelsLike()));
        tvHumidityValue.setText(String.format(Locale.getDefault(), "%d%%", meteoItem.getHumidity()));
        tvWeatherDescriptionValue.setText(capitalizeFirstLetter(meteoItem.getWeatherDescription()));
        
        setWeatherIcon(meteoItem.getWeatherCondition());
    }
    
    /**
     * Set the weather icon based on the weather condition.
     * 
     * @param weatherCondition Weather condition string from API
     */
    private void setWeatherIcon(String weatherCondition) {
        if (weatherCondition == null) {
            ivWeatherIcon.setImageResource(R.drawable.unknown);
            return;
        }
        switch (weatherCondition.toLowerCase(Locale.ROOT)) {
            case "clear":
                ivWeatherIcon.setImageResource(R.drawable.clear);
                break;
            case "clouds":
                ivWeatherIcon.setImageResource(R.drawable.cloudy);
                break;
            case "rain":
            case "drizzle":
                ivWeatherIcon.setImageResource(R.drawable.rainy);
                break;
            case "thunderstorm":
                ivWeatherIcon.setImageResource(R.drawable.thunderstorm);
                break;
            case "snow":
                ivWeatherIcon.setImageResource(R.drawable.snowy);
                break;
            case "mist":
            case "fog":
            case "haze":
                ivWeatherIcon.setImageResource(R.drawable.foggy);
                break;
            default:
                ivWeatherIcon.setImageResource(R.drawable.unknown);
                break;
        }
    }

    /**
     * Helper method to capitalize the first letter of a string.
     * 
     * @param original The original string.
     * @return The string with the first letter capitalized.
     */
    private String capitalizeFirstLetter(String original) {
        if (original == null || original.isEmpty()) {
            return original;
        }
        return original.substring(0, 1).toUpperCase(Locale.ROOT) + original.substring(1);
    }
}

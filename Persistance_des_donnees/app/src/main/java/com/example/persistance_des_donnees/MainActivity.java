package com.example.persistance_des_donnees;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.Button;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    private EditText nomEditText, emailEditText;
    private SharedPreferences sharedpreferences;
    private static final String PREF_NAME = "mypref";
    private static final String KEY_NAME = "Name";
    private static final String KEY_EMAIL = "Email";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        nomEditText = findViewById(R.id.nomEditText);
        emailEditText = findViewById(R.id.emailEditText);

        sharedpreferences = getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);

        Button enregistrerButton = findViewById(R.id.enregistrerButton);
        Button chargerButton = findViewById(R.id.chargerButton);
        Button effacerButton = findViewById(R.id.effacerButton);
    
        enregistrerButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                saveData();
            }
        });

        chargerButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                loadData();
            }
        });

        effacerButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                clearData();
            }
        });

        loadData();
    }

    private void saveData() {
        SharedPreferences.Editor editor = sharedpreferences.edit();
        editor.putString(KEY_NAME, nomEditText.getText().toString());
        editor.putString(KEY_EMAIL, emailEditText.getText().toString());
        editor.apply(); // Use apply() instead of commit() for better performance
    }

    private void loadData() {
        if (sharedpreferences.contains(KEY_NAME)) {
            nomEditText.setText(sharedpreferences.getString(KEY_NAME, ""));
        }
        if (sharedpreferences.contains(KEY_EMAIL)) {
            emailEditText.setText(sharedpreferences.getString(KEY_EMAIL, ""));
        }
    }

    private void clearData() {
        SharedPreferences.Editor editor = sharedpreferences.edit();
        editor.remove(KEY_NAME);
        editor.remove(KEY_EMAIL);
        editor.apply();
        nomEditText.setText("");
        emailEditText.setText("");
    }
}
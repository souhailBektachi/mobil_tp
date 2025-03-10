package com.example.sharedpre;

import android.content.Context;
import android.database.Cursor;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Button;
import android.widget.ListView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import java.util.ArrayList;

public class MainActivity extends AppCompatActivity {

    private EditText nameEdt;
    private Button addUserBtn, deleteUserBtn, updateUserBtn;

    private DBHandler dbHandler;
    private ArrayList<String> listItems;
    private ArrayAdapter<String> adapter;
    private ListView listUsers;

    private int selectedId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        nameEdt = findViewById(R.id.editTextName);

        addUserBtn = findViewById(R.id.btnSave);
        updateUserBtn = findViewById(R.id.btnUpdate);
        deleteUserBtn = findViewById(R.id.btnDelete);

        listUsers = findViewById(R.id.listViewUsers);  // Ensure this ID exists in your layout

        dbHandler = new DBHandler(MainActivity.this);
        listItems = new ArrayList<>();

        addUserBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String name = nameEdt.getText().toString();

                if (name.isEmpty()) {
                    Toast.makeText(MainActivity.this, "Please Enter name", Toast.LENGTH_SHORT).show();
                    return;
                }

                dbHandler.addNewUser(name);
                Toast.makeText(MainActivity.this, "User Added", Toast.LENGTH_SHORT).show();
                nameEdt.setText("");  // Clear the input field

                // Refresh list
                viewData();
            }
        });

        deleteUserBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dbHandler.deleteUser(selectedId);
                Toast.makeText(MainActivity.this, "User Deleted", Toast.LENGTH_SHORT).show();
                nameEdt.setText("");  // Clear the input field

                // Refresh list
                viewData();
            }
        });

        updateUserBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String name = nameEdt.getText().toString();

                if (name.isEmpty()) {
                    Toast.makeText(MainActivity.this, "Please Enter name", Toast.LENGTH_SHORT).show();
                    return;
                }

                dbHandler.updateUser(selectedId, name);
                Toast.makeText(MainActivity.this, "User Updated", Toast.LENGTH_SHORT).show();
                nameEdt.setText("");  // Clear the input field

                // Refresh list
                viewData();
            }
        });

        viewData();

        listUsers.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                String selectedItem = listItems.get(position);
                Toast.makeText(getApplicationContext(), "Selected Item: " + selectedItem, Toast.LENGTH_SHORT).show();

                String[] parts = selectedItem.split(":");
                selectedId = Integer.parseInt(parts[0].trim());
                nameEdt.setText(parts[1].trim());
            }
        });
    }

    private void viewData() {
        listItems.clear(); // Clear the list before adding new data

        Cursor cursor = dbHandler.viewData();
        if (cursor.getCount() == 0) {
            Toast.makeText(MainActivity.this, "No data to show", Toast.LENGTH_LONG).show();
            return;
        }

        while (cursor.moveToNext()) {
            listItems.add(cursor.getInt(0) + " : " + cursor.getString(1)); // index 1 is name, index 0 is id
        }

        adapter = new ArrayAdapter<>(MainActivity.this, android.R.layout.simple_list_item_1, listItems);
        listUsers.setAdapter(adapter);
    }
}
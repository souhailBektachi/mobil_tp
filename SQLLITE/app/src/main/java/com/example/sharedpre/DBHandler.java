package com.example.sharedpre;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.DatabaseErrorHandler;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public class DBHandler extends SQLiteOpenHelper {
    private static final String DB_NAME = "usersdb";
    private static final int DB_VERSION = 1;
    private static final String TABLE_NAME = "users";

    private static final String ID_COL = "id";

    private static final String NAME_COL = "name";


    public DBHandler(Context context) {
        super(context, DB_NAME, null, DB_VERSION);
    }


    @Override
    public void onCreate(SQLiteDatabase db) {
        String query = "CREATE TABLE " + TABLE_NAME + " ("
                + ID_COL + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + NAME_COL + " TEXT)" ;

        db.execSQL(query);

        db.execSQL("INSERT INTO " +TABLE_NAME  + "(name) VALUES ('Mostapha')");


    }


    public void addNewUser(String name){
        SQLiteDatabase db =this.getWritableDatabase();
        ContentValues content=new ContentValues();
        content.put(NAME_COL,name);
        db.insert(TABLE_NAME,null,content);
        db.close();
    }


    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
db.execSQL("DROP TABLE IF EXISTS "+TABLE_NAME);
    }

    public Cursor viewData(){

        SQLiteDatabase db = this.getReadableDatabase();
        String query = "Select * from " + TABLE_NAME;
        Cursor cursor = db.rawQuery(query, null);
        return cursor;
    }

    public void updateUser(int id, String name) {
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues content = new ContentValues();
        content.put(NAME_COL, name);
        db.update(TABLE_NAME, content, ID_COL + "=?", new String[]{String.valueOf(id)});
    }

    public void deleteUser(int id) {
        SQLiteDatabase db = this.getWritableDatabase();
        db.delete(TABLE_NAME, ID_COL + "=?", new String[]{String.valueOf(id)});
    }





}

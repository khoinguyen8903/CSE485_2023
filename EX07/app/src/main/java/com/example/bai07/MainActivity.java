package com.example.bai07;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;


public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);
        Button btn1 = findViewById(R.id.btnNext);
        btn1.setOnClickListener(view -> {
            Intent intent1 = new Intent(MainActivity.this,ChildActivity.class);
            startActivity(intent1);
        });
    }
}
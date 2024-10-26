package com.example.bai2;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.View;
import androidx.appcompat.app.AppCompatActivity;

public class SubActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Đặt layout đúng cho SubActivity
        setContentView(R.layout.activity_subactivity);

        // Đảm bảo rằng btnok nằm trong activity_sub.xml
        @SuppressLint({"MissingInflatedId", "LocalSuppress"})
        View btnok = findViewById(R.id.btnok);

        btnok.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish(); // Kết thúc activity khi nhấn nút
            }
        });
    }
}

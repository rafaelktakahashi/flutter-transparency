package com.rafaeltakahashi.playground.transparency

import android.app.ActivityOptions
import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.core.content.ContextCompat
import com.rafaeltakahashi.playground.transparency.activity.ModalFlutterActivity
import com.rafaeltakahashi.playground.transparency.ui.theme.PrimaryPurple
import com.rafaeltakahashi.playground.transparency.ui.theme.RegularTheme
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.engine.FlutterEngineCache

/// Icon from FlatIcons: https://www.flaticon.com/free-icons/halloween-party

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            Content(openFlutter = { openFlutter() })
        }
    }

    private fun openFlutter() {
        // Create the intent with transparent background mode.
        // Aside from this, the theme (in the themes xml) also needs to be transparent, and the
        // Flutter code also needs a transparent page builder.
        val intent = Intent(this, ModalFlutterActivity::class.java)
        startActivity(intent)
    }
}

@Composable
fun Content(openFlutter: () -> Unit) {
    RegularTheme {
        // A surface container using the 'background' color from the theme
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = MaterialTheme.colorScheme.primary
        ) {
            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                Spacer(modifier = Modifier.size(40.dp))
                Text(text = "Transparent Flutter over native", style = MaterialTheme.typography.titleLarge)
                Image(
                    painter = painterResource(id = R.drawable.ghost),
                    contentDescription = "Ghost",
                    modifier = Modifier
                        .padding(vertical = 40.dp)
                        .size(200.dp)
                        .clip(CircleShape)
                        .background(color = Color.White)
                )
                Button(onClick = {
                    openFlutter()
                }) {
                    Text(text = "Open!")
                }
            }
        }
    }
}

package com.rafaeltakahashi.playground.transparency

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
import androidx.compose.ui.unit.dp
import com.rafaeltakahashi.playground.transparency.activity.CustomFlutterActivity
import com.rafaeltakahashi.playground.transparency.ui.theme.RegularTheme
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

/// Icon from FlatIcons: https://www.flaticon.com/free-icons/halloween-party

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            Content(openFlutter = {s -> openFlutter(s)})
        }
    }

    private fun openFlutter(pageName: String) {
        // Don't use this navigation as an example. Prefer using an interop navigator.
        val engine = FlutterEngineCache.getInstance().get("engine")
        MethodChannel(engine!!.dartExecutor.binaryMessenger, "method-channel").invokeMethod("navigate", pageName)

        // Create the intent with transparent background mode.
        // Aside from this, the theme (in the themes xml) also needs to be transparent, and the
        // Flutter code also needs a transparent page builder.
        val intent = Intent(this, CustomFlutterActivity::class.java)
        startActivity(intent)
    }
}

@Composable
fun Content(openFlutter: (String) -> Unit) {
    RegularTheme {
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
                    openFlutter("modal")
                }) {
                    Text(text = "Open Modal")
                }
                Button(onClick = {
                    openFlutter("card")
                }) {
                    Text(text = "Open Card")
                }
            }
        }
    }
}

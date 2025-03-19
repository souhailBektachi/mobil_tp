package fr.iutlan.tp4.jetpack_compose_practice.feu3.ui

import android.widget.RadioButton
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.wrapContentSize
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import fr.iutlan.tp4.jetpack_compose_practice.feu3.state.Feu3State

@Composable
fun Feu3ViewV2(state: Feu3State, modifier: Modifier = Modifier) {
    Column(
        modifier.wrapContentSize()
    ) {
        // Feu rouge
        Row (Modifier.align(Alignment.Start).padding(horizontal = 16.dp)) {
            RadioButton(
                selected = state.rouge,
                onClick = null // non réactif
            )
            Text(
                text = "rouge",
                modifier = Modifier.padding(start = 16.dp)
            )
        }

        // Feu orange
        Row(Modifier.align(Alignment.Start).padding(horizontal = 16.dp)) {
            RadioButton(
                selected = state.orange,
                onClick = null // non réactif
            )
            Text(
                text = "orange",
                modifier = Modifier.padding(start = 16.dp)
            )
        }

        // Feu vert
        Row(Modifier.align(Alignment.Start).padding(horizontal = 16.dp)) {
            RadioButton(
                selected = state.vert,
                onClick = null // non réactif
            )
            Text(
                text = "vert",
                modifier = Modifier.padding(start = 16.dp)
            )
        }
    }
}

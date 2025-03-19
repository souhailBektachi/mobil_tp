package fr.iutlan.tp4.jetpack_compose_practice.feu3.ui

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.wrapContentSize
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import fr.iutlan.tp4.jetpack_compose_practice.feu3.state.Feu3State

@Composable
fun Feu3ViewV3(state: Feu3State, modifier: Modifier = Modifier) {
    Column (
        modifier = modifier.wrapContentSize(Alignment.Center)
    ) {
        Box(
            contentAlignment = Alignment.Center,
            modifier = Modifier
                .size(64.dp, 192.dp)
                .clip(RoundedCornerShape(24.dp))
                .background(Color.DarkGray)
                .padding(8.dp)
        ) {
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Feu(Color.Red, state.rouge)
                Feu(Color.Orange, state.orange)
                Feu(Color.Green, state.vert)
            }
        }
    }
}

/**
 * Draws a colored or gray circle based on the isOn flag.
 */
@Composable
fun Feu(color: Color, isOn: Boolean, modifier: Modifier = Modifier) {
    Canvas(
        modifier = modifier
            .size(48.dp)
            .padding(4.dp),
        onDraw = {
            drawCircle(color = if (isOn) color else Color.Gray)
        }
    )
}

/**
 * Defines the color Orange as an extension of the Color class.
 */
private val Color.Companion.Orange: Color
    get() = Color.hsv(33.0f, 1.0f, 1.0f)

@Preview(showBackground = true)
@Composable
fun Feu3ViewV3Preview() {
    Feu3ViewV3(state = Feu3State(false, true, false))
}

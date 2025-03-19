package fr.iutlan.tp4.jetpack_compose_practice.feu3.ui
import androidx.compose.foundation.*
import androidx.compose.foundation.layout.*

import androidx.compose.foundation.shape.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.*
import androidx.compose.ui.unit.*
import androidx.lifecycle.viewmodel.compose.viewModel
import fr.iutlan.tp4.jetpack_compose_practice.feu3.controller.Feu3ViewModel
import fr.iutlan.tp4.jetpack_compose_practice.feu3.state.Feu3State

@Composable
fun MainActivityFeu3View(viewmodel: Feu3ViewModel = viewModel()) {
    val state = viewmodel.state
    Column(
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        // affichage du feu, version 1
        Feu3ViewV1(state, modifier = Modifier.padding(16.dp))
        // bouton, voir la suite du TP
    }
}

@Composable
fun Feu3ViewV1(state: Feu3State, modifier: Modifier = Modifier) {
    Text(text = "Feu ${state.nomCouleur}",
        style = MaterialTheme.typography.titleLarge,
        modifier = modifier,
    )
}
package fr.iutlan.tp4.jetpack_compose_practice.feu3.controller

import fr.iutlan.tp4.jetpack_compose_practice.feu3.state.Feu3State
import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.ViewModel

class Feu3ViewModel : ViewModel() {

    private val _state = mutableStateOf(Feu3State())
    var state
        get() = _state.value // _state.value = instance de Feu3State
        private set(newstate) {
            _state.value = newstate // remplace l
        }
    init {
        reset()
    }
    fun reset() {
        state = Feu3State()
    }
    fun suivant() {
        if (state.rouge) {
            state = Feu3State(false, false, true)

        } else if (state.vert) {
            state = Feu3State(false, true, false)
        } else {
            state = Feu3State(true, false, false)
        }
    }
}
package fr.iutlan.tp4.jetpack_compose_practice.feu3.state

data class Feu3State(
    val rouge: Boolean = true,
    val orange: Boolean = false,
    val vert: Boolean = false,
) {
    /**
     * @return nom de la couleur courante
     */
    val nomCouleur: String
        get() =
            if (rouge) "rouge" else
                if (orange) "orange" else
                    if (vert) "vert" else "???"

}
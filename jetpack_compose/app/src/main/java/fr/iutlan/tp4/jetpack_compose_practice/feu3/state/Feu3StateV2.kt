package fr.iutlan.tp4.jetpack_compose_practice.feu3.state

enum class FeuCouleur {
    ROUGE,
    ORANGE,
    VERT
}

data class Feu3StateV2(
    val couleur: FeuCouleur = FeuCouleur.ROUGE
) {
    val rouge: Boolean get() = couleur == FeuCouleur.ROUGE
    val orange: Boolean get() = couleur == FeuCouleur.ORANGE
    val vert: Boolean get() = couleur == FeuCouleur.VERT

    val nomCouleur: String
        get() = couleur.name.lowercase().replaceFirstChar { it.uppercase() }
    fun copyChangeCouleur(nouvelle: FeuCouleur): Feu3StateV2 {
        return this.copy(couleur = nouvelle)
    }
}

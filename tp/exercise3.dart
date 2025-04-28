import 'dart:async';

Future<String> fetchData() {
  return Future.delayed(Duration(seconds: 2), () => "Données reçues");

}

void main() async {
  print("loading ...");

  try {
    String resultat = await fetchData();

    print("Résultat: $resultat");
  } catch (e) {
    print("Une erreur est survenue: $e");
  } finally {
      print("Opération terminée (succès ou échec).");
  }

}

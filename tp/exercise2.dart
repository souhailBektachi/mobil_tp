class Employe {
  String _nom;
  double _salaire;

  Employe({required String nom, required double salaire})
      : _nom = nom,
        _salaire = salaire;

  void afficherInfos() {
    print("Employé: Nom = $_nom, Salaire = $_salaire €");
  }

  String get nom => _nom;
  double get salaire => _salaire;
}

class Manager extends Employe {
  double _prime;

  Manager({required String nom, required double salaire, required double prime})
      : _prime = prime,
        super(nom: nom, salaire: salaire);

  @override
  void afficherInfos() {
    print("Manager: Nom = $_nom, Salaire = $_salaire €, Prime = $_prime €");
  }

  double get prime => _prime;
}

void main() {
  var employe1 = Employe(nom: "Alice", salaire: 3000.0);
  var manager1 = Manager(nom: "Bob", salaire: 5000.0, prime: 1000.0);

  List<Employe> equipe = [employe1, manager1];

  print("--- Informations de l'équipe ---");
  for (var membre in equipe) {
    membre.afficherInfos();
  }

}

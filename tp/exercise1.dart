import 'dart:core';

class Book {
  String title;
  String author;
  int year;
  bool isAvailable;

  Book({required this.title, required this.author, required this.year, this.isAvailable = false});

  Book.available({required this.title, required this.author, required this.year}) : isAvailable = true;

  @override
  String toString() {
    return 'Titre: $title, Auteur: $author (Année: $year) - ${isAvailable ? "Disponible" : "Emprunté"}';
  }
}

class Library {
  final List<Book> _books = [];

  void addBook(Book book) {
    _books.add(book);
  }

  void borrowBook(String title) {
    for (var book in _books) {
      if (book.title == title && book.isAvailable) {
        book.isAvailable = false;
        print("Livre '$title' emprunté.");
        return;
      }
    }
    print("Livre '$title' non trouvé ou déjà emprunté.");
  }

  List<Book> getAvailableBooks() {
    return _books.where((book) => book.isAvailable).toList();
  }

  List<Book> getAllBooks() {
    return List.unmodifiable(_books);
  }

  Library operator +(Library other) {
    Library mergedLibrary = Library();
    for (var book in _books) {
      if (!mergedLibrary._books.any((b) => b.title == book.title && b.author == book.author && b.year == book.year)) {
         mergedLibrary.addBook(Book(title: book.title, author: book.author, year: book.year, isAvailable: book.isAvailable));
      }
    }
    for (var book in other._books) {
       if (!mergedLibrary._books.any((b) => b.title == book.title && b.author == book.author && b.year == book.year)) {
         mergedLibrary.addBook(Book(title: book.title, author: book.author, year: book.year, isAvailable: book.isAvailable));
       }
    }
    return mergedLibrary;
  }
}

void displayBooks(List<Book> books, String title) {
  print("\n--- $title ---");
  if (books.isEmpty) {
    print("Aucun livre à afficher.");
    return;
  }
  for (var book in books) {
    print("Titre: ${book.title}, Auteur: ${book.author} (Année: ${book.year})");
  }
}

void main() {
  var book1 = Book.available(title: "Le Seigneur des Anneaux", author: "J.R.R. Tolkien", year: 1954);
  var book2 = Book.available(title: "1984", author: "George Orwell", year: 1949);
  var book3 = Book(title: "Fondation", author: "Isaac Asimov", year: 1951, isAvailable: false);

  var library1 = Library();
  library1.addBook(book1);
  library1.addBook(book2);
  library1.addBook(book3);

  print("Livres initiaux dans library1:");
  displayBooks(library1.getAllBooks(), "Tous les livres Library 1");
  displayBooks(library1.getAvailableBooks(), "Livres disponibles Library 1");

  library1.borrowBook("1984");
  print("\nAprès emprunt de '1984':");
  displayBooks(library1.getAvailableBooks(), "Livres disponibles Library 1 (MAJ)");

  var library2 = Library();
  var book4 = Book.available(title: "Dune", author: "Frank Herbert", year: 1965);
  var book5 = Book(title: "Le Seigneur des Anneaux", author: "J.R.R. Tolkien", year: 1954);
  library2.addBook(book4);
  library2.addBook(book5);

  print("\nLivres initiaux dans library2:");
  displayBooks(library2.getAllBooks(), "Tous les livres Library 2");

  var mergedLibrary = library1 + library2;
  print("\nAprès fusion de library1 et library2:");
  displayBooks(mergedLibrary.getAllBooks(), "Tous les livres Bibliothèque Fusionnée");
  displayBooks(mergedLibrary.getAvailableBooks(), "Livres disponibles Bibliothèque Fusionnée");

}

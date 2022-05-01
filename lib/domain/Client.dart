
class Client {
  final int idClient;
  final String firstname;
  final String lastname;
  final String email;
  final String numeroTel;
  final String dateCreation;

  const Client({
    required this.idClient,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.numeroTel,
    required this.dateCreation,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      idClient: json['id_client'],
      firstname: json['prenom'],
      lastname: json['nom'],
      email: json['email'],
      numeroTel: json['numero_tel'],
      dateCreation: json['date_creation'],
    );
  }

  @override
  String toString() {
    return "$idClient : $firstname";
  }
}
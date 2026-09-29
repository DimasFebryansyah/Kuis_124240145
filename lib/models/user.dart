class User {
  final String nim;
  final String nama;
  final String prodi;
  final String password;

  User({                    // ← tidak pakai const
    required this.nim,
    required this.nama,
    required this.prodi,
    required this.password,
  });

  bool credentialsMatch(String inputNim, String inputPassword) {
    return nim == inputNim && password == inputPassword;
  }

  @override
  String toString() => 'User(nim: $nim, nama: $nama, prodi: $prodi)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! User) return false;
    return nim == other.nim;
  }

  @override
  int get hashCode => nim.hashCode;
}
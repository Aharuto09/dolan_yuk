class User {
  const User(
      {this.id = 0,
      required this.username,
      required this.email,
      required this.password,
      required this.url});
  final int id;
  final String username, email, password, url;

  get toJson {
    return {
      "username": this.username,
      "email": this.email,
      "password": this.password,
    };
  }

  get forUpdate {
    return {
      "username": this.username,
      "email": this.email,
      "url": this.url,
    };
  }
}

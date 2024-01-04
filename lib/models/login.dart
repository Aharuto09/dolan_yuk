class Login {
  const Login({required this.email, required this.password});
  final String email, password;
  get toJson {
    return {"email": this.email, "password": this.password};
  }

  get data {
    return '{"email": "${this.email}", "password": "${this.password}"}';
  }
}

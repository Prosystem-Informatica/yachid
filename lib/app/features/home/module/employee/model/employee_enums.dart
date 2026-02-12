// ignore_for_file: constant_identifier_names

enum EmployeeStatus {
  ATIVO('ACTIVE'),
  INATIVO('INACTIVE');

  final String value;
  const EmployeeStatus(this.value);
}

enum EmployeeRole {
  ADMINISTRADOR('ADMIN'),
  USUARIO('USER');

  final String value;
  const EmployeeRole(this.value);
}

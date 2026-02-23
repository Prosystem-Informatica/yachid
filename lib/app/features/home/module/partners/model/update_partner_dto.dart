class UpdatePartnerDto {
  final String? document;
  final String? ieRg;
  final String? name;
  final String? fantasyName;
  final String? mainPhone;
  final String? secondaryPhone;
  final String? cellphone;
  final String? personType;
  final String? partnerType;
  final String? suframa;
  final String? businessSector;
  final String? emailNfe;
  final String? email;
  final String? site;
  final String? status;
  final String? accountingAccount;
  final String? type;
  final bool? provision;
  final String? fixedExpenses;

  UpdatePartnerDto({
    this.document,
    this.ieRg,
    this.name,
    this.fantasyName,
    this.mainPhone,
    this.secondaryPhone,
    this.cellphone,
    this.personType,
    this.partnerType,
    this.suframa,
    this.businessSector,
    this.emailNfe,
    this.email,
    this.site,
    this.status,
    this.accountingAccount,
    this.type,
    this.provision,
    this.fixedExpenses,
  });

  Map<String, dynamic> toJson() {
    return {
      'document': document,
      'ieRg': ieRg,
      'name': name,
      'fantasyName': fantasyName,
      'mainPhone': mainPhone,
      'secondaryPhone': secondaryPhone,
      'cellphone': cellphone,
      'personType': personType,
      'partnerType': partnerType,
      'suframa': suframa,
      'businessSector': businessSector,
      'emailNfe': emailNfe,
      'email': email,
      'site': site,
      'status': status,
      'accountingAccount': accountingAccount,
      'type': type,
      'provision': provision,
      'fixedExpenses': fixedExpenses,
    };
  }
}

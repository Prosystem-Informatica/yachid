import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/helpers/environments.dart';
import 'package:yachid/app/core/rest/http/http_rest_client.dart';

import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/partners/model/update_partner_dto.dart';
import 'package:yachid/app/features/home/module/partners/module/model/partner_details.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/data/cubit/partner_data_cubit.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/data_field.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/section_card_header.dart';
import 'package:yachid/app/repository/partners/partners_repository.dart';

class DadosTab extends StatelessWidget {
  DadosTab({super.key, required this.partner}) {
    codigoController.text = partner.codigo.toString();
    documentController.text = partner.document;
    ieRgController.text = partner.ieRg;
    personTypeController.text = partner.personType;
    suframaController.text = partner.suframa;
    typeController.text = partner.type;
    nameController.text = partner.name;
    fantasyNameController.text = partner.fantasyName;
    typePartnerController.text = partner.type;
    businessSectorController.text = partner.businessSector;
    statusController.text = partner.status;
    mainPhoneController.text = partner.mainPhone;
    secondaryPhoneController.text = partner.secondaryPhone;
    cellphoneController.text = partner.cellphone;
    emailController.text = partner.email;
    emailNfeController.text = partner.emailNfe;
    siteController.text = partner.site;
    accountingAccountController.text = partner.accountingAccount ?? '';
    fixedExpensesController.text = partner.fixedExpenses ? 'SIM' : 'NÃO';
    provisionController.text = partner.provision ? 'SIM' : 'NÃO';
    accountController.text = partner.accountingAccount ?? '';
  }

  final PartnerDetails partner;

  final TextEditingController codigoController = TextEditingController();
  final TextEditingController documentController = TextEditingController();
  final TextEditingController ieRgController = TextEditingController();
  final TextEditingController personTypeController = TextEditingController();
  final TextEditingController suframaController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController fantasyNameController = TextEditingController();
  final TextEditingController typePartnerController = TextEditingController();
  final TextEditingController businessSectorController =
      TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController mainPhoneController = TextEditingController();
  final TextEditingController secondaryPhoneController =
      TextEditingController();
  final TextEditingController cellphoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController emailNfeController = TextEditingController();
  final TextEditingController siteController = TextEditingController();
  final TextEditingController accountingAccountController =
      TextEditingController();
  final TextEditingController fixedExpensesController = TextEditingController();
  final TextEditingController provisionController = TextEditingController();
  final TextEditingController accountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => PartnerDataCubit(
            repository: PartnersRepository(
              rest: HttpRestClient(
                baseUrl: Environments.get('BASE_URL') ?? "",
                env: Environments.get('ENV') ?? "",
                port: Environments.get('PORT') ?? "",
              ),
            ),
          ),
      child: BlocBuilder<PartnerDataCubit, PartnerDataState>(
        builder: (context, state) {
          if (state is PartnerDataError) {
            return Center(child: Text(state.message));
          } else if (state is PartnerDataInitial) {
            context.read<PartnerDataCubit>().loadPartnerData(
              token: context.read<AuthBlocCubit>().state.authModel.token ?? '',
              partnerId: partner.id,
            );
            return const Center(child: CircularProgressIndicator());
          } else if (state is PartnerDataLoaded) {
            return ListView(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 160,
                    vertical: 16,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 20,
                        children: [
                          SectionHeader(
                            setIsEditing: (isEditing) {
                              context.read<PartnerDataCubit>().setIsEditing(
                                isEditing,
                              );
                            },
                            iconDecoration: BoxDecoration(
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.4,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            icon: const Icon(Icons.fingerprint, size: 16),
                            title: 'Identificação',
                            description: 'Dados de identificação do parceiro',
                            isEditing: state.isEditing,
                            onEdit: () async {
                              final bool success = await context
                                  .read<PartnerDataCubit>()
                                  .updatePartnerData(
                                    token:
                                        context
                                            .read<AuthBlocCubit>()
                                            .state
                                            .authModel
                                            .token ??
                                        '',
                                    partnerId: partner.id,
                                    updatePartnerDto: UpdatePartnerDto(
                                      document: documentController.text,
                                      ieRg: ieRgController.text,
                                      name: nameController.text,
                                      fantasyName: fantasyNameController.text,
                                      mainPhone: mainPhoneController.text,
                                      secondaryPhone:
                                          secondaryPhoneController.text,
                                      cellphone: cellphoneController.text,
                                      personType: personTypeController.text,
                                      partnerType: typePartnerController.text,
                                      suframa: suframaController.text,
                                      businessSector:
                                          businessSectorController.text,
                                      emailNfe: emailNfeController.text,
                                      email: emailController.text,
                                      site: siteController.text,
                                      status:
                                          statusController.text.toUpperCase() ==
                                                  'ACTIVE'
                                              ? 'ACTIVE'
                                              : 'INACTIVE',
                                      accountingAccount:
                                          accountingAccountController.text,
                                      type: typeController.text,
                                      provision:
                                          provisionController.text == 'SIM'
                                              ? true
                                              : false,
                                      fixedExpenses:
                                          fixedExpensesController.text,
                                    ),
                                  );
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Parceiro atualizado com sucesso!',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Erro ao atualizar parceiro!',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            trailing: null,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    isEditing: state.isEditing,
                                    label: 'Código',
                                    enabled: false,
                                    value: partner.codigo,
                                    controller: codigoController,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    enabled: false,
                                    isEditing: state.isEditing,
                                    label: 'Documento',
                                    value: partner.document,
                                    controller: documentController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    isEditing: state.isEditing,
                                    label: 'IR/RG',
                                    value: partner.ieRg,
                                    controller: ieRgController,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    enabled: false,
                                    isEditing: state.isEditing,
                                    label: 'Tipo Pessoa',
                                    value: partner.personType,
                                    controller: personTypeController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    isEditing: state.isEditing,
                                    label: 'Suframa',
                                    value: partner.suframa,
                                    controller: suframaController,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    isEditing: state.isEditing,
                                    label: 'Tipo',
                                    value: partner.type,
                                    controller: typeController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SectionHeader(
                            setIsEditing: null,
                            iconDecoration: BoxDecoration(
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.4,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            icon: const Icon(Icons.info_outline, size: 16),
                            title: 'Dados Gerais',
                            description: 'Informações gerais do parceiro',
                            isEditing: false,
                            onEdit: null,
                            trailing: null,
                          ),
                          SizedBox.shrink(),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    isEditing: state.isEditing,
                                    label: 'Razão Social',
                                    value: partner.name,
                                    controller: nameController,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    isEditing: state.isEditing,
                                    label: 'Nome Fantasia',
                                    value: partner.fantasyName,
                                    controller: fantasyNameController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    isEditing: state.isEditing,
                                    label: 'Tipo Parceiro',
                                    value: partner.type,
                                    controller: typePartnerController,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    isEditing: state.isEditing,
                                    label: 'Ramo de Atividade',
                                    value: partner.businessSector,
                                    controller: businessSectorController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ValueListenableBuilder<TextEditingValue>(
                              valueListenable: statusController,
                              builder: (context, statusValue, _) {
                                final statusText =
                                    statusValue.text.toUpperCase();
                                final isActive =
                                    statusText == 'ACTIVE' ||
                                    statusText == 'ATIVO';
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.gray300.withValues(
                                      alpha: 0.25,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.toggle_on_rounded,
                                        size: 20,
                                        color: AppColors.gray700,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Status',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.gray800,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        isActive ? 'Ativo' : 'Inativo',
                                        style: TextStyle(
                                          color:
                                              isActive
                                                  ? AppColors.success
                                                  : AppColors.error,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Switch(
                                        value: isActive,
                                        activeTrackColor: AppColors.primaryColor
                                            .withValues(alpha: 0.5),
                                        thumbColor:
                                            WidgetStateProperty.resolveWith((
                                              states,
                                            ) {
                                              if (states.contains(
                                                WidgetState.selected,
                                              )) {
                                                return AppColors.primaryColor;
                                              }
                                              return null;
                                            }),
                                        onChanged:
                                            state.isEditing
                                                ? (value) {
                                                  statusController.text =
                                                      value
                                                          ? 'ACTIVE'
                                                          : 'INACTIVE';
                                                }
                                                : null,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox.shrink(),
                          SectionHeader(
                            icon: const Icon(
                              Icons.contact_phone_outlined,
                              size: 16,
                            ),
                            title: 'Contato',
                            description: 'Telefones, e-mails e redes',
                            trailing: null,
                            iconDecoration: BoxDecoration(
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.4,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          SizedBox.shrink(),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    isEditing: state.isEditing,
                                    label: 'Telefone Principal',
                                    value: partner.mainPhone,
                                    controller: mainPhoneController,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    isEditing: state.isEditing,
                                    label: 'Telefone Secundário',
                                    value: partner.secondaryPhone,
                                    controller: secondaryPhoneController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    isEditing: state.isEditing,
                                    label: 'Celular',
                                    value: partner.cellphone,
                                    controller: cellphoneController,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    isEditing: state.isEditing,
                                    label: 'E-mail',
                                    value: partner.email,
                                    controller: emailController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    isEditing: state.isEditing,
                                    label: 'E-mail NF-e',
                                    value: partner.emailNfe,
                                    controller: emailNfeController,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    isEditing: state.isEditing,
                                    label: 'Site',
                                    value: partner.site,
                                    controller: siteController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox.shrink(),
                          SectionHeader(
                            icon: const Icon(
                              Icons.account_balance_outlined,
                              size: 16,
                            ),
                            title: 'Financeiro',
                            description: 'Dados financeiros do parceiro',
                            trailing: null,
                            iconDecoration: BoxDecoration(
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.4,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    isEditing: state.isEditing,
                                    label: 'Conta Contábil',
                                    value: partner.accountingAccount,
                                    controller: accountingAccountController,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    isEditing: state.isEditing,
                                    label: 'Despesas Fixas',
                                    value: partner.fixedExpenses,
                                    controller: fixedExpensesController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    isEditing: state.isEditing,
                                    label: 'Provisão',
                                    value: partner.provision,
                                    controller: provisionController,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: DataField(
                                    isEditing: state.isEditing,
                                    label: 'Provisão',
                                    value: partner.provision,
                                    controller: accountController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

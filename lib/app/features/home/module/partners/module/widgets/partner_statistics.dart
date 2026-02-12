import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/card_partner.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/data_field.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/section_card_header.dart';

class PartnerStatistics extends StatelessWidget {
  const PartnerStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          CardPartnerContact(
            icon: Icon(Icons.credit_card),
            iconDecoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            title: 'Crédito',
            subtitle: 'Informações de credito e consulta',
            dataFields: [
              DataField(label: 'Crédito', value: '1000'),
              DataField(label: 'Data', value: '14/11/2025'),
              DataField(label: 'Consulta Serasa', value: 'Não'),
            ],
            footer: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.gray300),
                color: AppColors.gray300.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HISTORICO',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.2,
                      fontFamily: 'Frutiger_bold',
                      color: AppColors.gray600,
                    ),
                  ),
                  Text(
                    'Data',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.2,
                      fontFamily: 'Frutiger',
                      color: AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {},
          ),
          CardPartnerContact(
            icon: Icon(Icons.credit_card),
            iconDecoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            title: 'Restrições',
            subtitle: 'Restrições ativa para o parceiro',
            dataFields: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF2BAB81).withOpacity(0.05),
                  border: Border.all(color: Color(0xFF2BAB81).withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: null,
                      child: Icon(Icons.shield, color: Color(0xFF2BAB81)),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Pedido Novo',
                            style: TextStyle(
                              fontFamily: 'Hind-Semi-Bold',
                              fontSize: 16,
                              color: AppColors.textOnPrimaryLight,
                            ),
                          ),
                          Text(
                            'Liberado',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF2BAB81).withValues(alpha: 0.05),
                  border: Border.all(
                    color: Color(0xFF2BAB81).withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: null,
                      child: Icon(Icons.shield, color: Color(0xFF2BAB81)),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Baixa Pedido',
                            style: TextStyle(
                              fontFamily: 'Hind-Semi-Bold',
                              fontSize: 16,
                              color: AppColors.textOnPrimaryLight,
                            ),
                          ),
                          Text(
                            'Liberado',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF2BAB81).withValues(alpha: 0.05),
                  border: Border.all(
                    color: Color(0xFF2BAB81).withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: null,
                      child: Icon(Icons.shield, color: Color(0xFF2BAB81)),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Emissão NF-e',
                            style: TextStyle(
                              fontFamily: 'Hind-Semi-Bold',
                              fontSize: 16,
                              color: AppColors.textOnPrimaryLight,
                            ),
                          ),
                          Text(
                            'Liberado',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFDC2828).withValues(alpha: 0.05),
                  border: Border.all(
                    color: Color(0xFFDC2828).withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: null,
                      child: Icon(Icons.shield, color: Color(0xFFDC2828)),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Analise de Crédito',
                            style: TextStyle(
                              fontFamily: 'Frutiger_bold',
                              fontSize: 16,
                              color: AppColors.textOnPrimaryLight,
                            ),
                          ),
                          Text(
                            'Restrito',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Frutiger',
                              color: Color(0xFFDC2828),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onTap: () {},
          ),
          CardPartnerContact(
            icon: Icon(Icons.credit_card),
            iconDecoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            title: 'Restrições',
            subtitle: 'Restrições ativa para o parceiro',
            dataFields: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF2BAB81).withOpacity(0.05),
                  border: Border.all(color: Color(0xFF2BAB81).withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: null,
                      child: Icon(Icons.shield, color: Color(0xFF2BAB81)),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Pedido Novo',
                            style: TextStyle(
                              fontFamily: 'Hind-Semi-Bold',
                              fontSize: 16,
                              color: AppColors.textOnPrimaryLight,
                            ),
                          ),
                          Text(
                            'Liberado',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF2BAB81).withValues(alpha: 0.05),
                  border: Border.all(
                    color: Color(0xFF2BAB81).withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: null,
                      child: Icon(Icons.shield, color: Color(0xFF2BAB81)),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Baixa Pedido',
                            style: TextStyle(
                              fontFamily: 'Hind-Semi-Bold',
                              fontSize: 16,
                              color: AppColors.textOnPrimaryLight,
                            ),
                          ),
                          Text(
                            'Liberado',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF2BAB81).withValues(alpha: 0.05),
                  border: Border.all(
                    color: Color(0xFF2BAB81).withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: null,
                      child: Icon(Icons.shield, color: Color(0xFF2BAB81)),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Emissão NF-e',
                            style: TextStyle(
                              fontFamily: 'Hind-Semi-Bold',
                              fontSize: 16,
                              color: AppColors.textOnPrimaryLight,
                            ),
                          ),
                          Text(
                            'Liberado',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFDC2828).withValues(alpha: 0.05),
                  border: Border.all(
                    color: Color(0xFFDC2828).withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: null,
                      child: Icon(Icons.shield, color: Color(0xFFDC2828)),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Analise de Crédito',
                            style: TextStyle(
                              fontFamily: 'Frutiger_bold',
                              fontSize: 16,
                              color: AppColors.textOnPrimaryLight,
                            ),
                          ),
                          Text(
                            'Restrito',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Frutiger',
                              color: Color(0xFFDC2828),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'dart:developer';
import 'package:yachid/app/core/rest/rest_client_response.dart';

import '../../core/rest/rest_client.dart';
import '../../features/home/module/employee/model/create_employee_dto.dart';
import '../../features/home/module/employee/model/branch_model.dart';
import '../../features/home/module/employee/model/employee_model.dart';

class EmployeeRepository {
  final RestClient _rest;

  EmployeeRepository({required RestClient rest}) : _rest = rest;

  Future<RestClientResponse<dynamic>> createEmployee(
    CreateEmployeeDto dto,
    String token,
    String branchId,
  ) async {
    try {
      final respoonse = await _rest.post(
        '/employee/$branchId/create',
        data: jsonEncode(dto.toJson()),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      return respoonse;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<BranchModel>> getBranches(
    String enterpriseId,
    String token,
  ) async {
    try {
      final response = await _rest.get(
        '/branch/$enterpriseId',
        headers: {'Authorization': 'Bearer $token'},
      );
      List<BranchModel> branches = [];

      if (response.data != null && response.data is List) {
        branches.addAll(
          (response.data as List).map((e) => BranchModel.fromJson(e)),
        );
        return branches;
      }
      return branches;
    } catch (e) {
      log(e.toString());
      print(e.toString());
      rethrow;
    }
  }

  Future<List<EmployeeModel>> getEmployees(
    String branchId,
    String token,
  ) async {
    try {
      final response = await _rest.get(
        '/employee/employees',
        queryParameters: {'branchId': branchId},
        headers: {'Authorization': 'Bearer $token'},
      );
      List<EmployeeModel> employees = [];

      if (response.data != null && response.data is List) {
        employees.addAll(
          (response.data as List).map((e) => EmployeeModel.fromJson(e)),
        );
        return employees;
      }
      return employees;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}

import 'package:future_pos/core/core.dart';

extension StaffRoleX on StaffRole {
  bool get canManageStaff => this == StaffRole.owner || this == StaffRole.admin;

  bool get canProcessPayments =>
      this == StaffRole.owner ||
      this == StaffRole.admin ||
      this == StaffRole.manager ||
      this == StaffRole.cashier;

  bool get canViewReports => this != StaffRole.support;
}

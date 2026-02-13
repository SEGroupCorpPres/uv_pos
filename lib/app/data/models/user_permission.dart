class UserPermissions {
  final bool canSell;
  final bool canRefund;
  final bool canManageStaff;
  final bool canViewReports;
  final bool canManageInventory;

  const UserPermissions({
    required this.canSell,
    required this.canRefund,
    required this.canManageStaff,
    required this.canViewReports,
    required this.canManageInventory,
  });
}

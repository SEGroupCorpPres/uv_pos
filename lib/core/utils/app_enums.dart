import '../core.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum StaffRole {
  owner, // Full system ownership
  admin, // System administration
  manager, // Store / shift management
  cashier, // Sales operations
  accountant, // Financial reports & audits
  warehouse, // Inventory control
  support // Technical / operational support
}

@JsonEnum(fieldRename: FieldRename.snake)
enum StaffStatus {
  active, // Allowed to operate
  inactive, // Temporarily disabled
  suspended, // Policy violation
  terminated // Permanently revoked
}

@JsonEnum(fieldRename: FieldRename.snake)
enum StaffShift { morning, afternoon, night, custom }

@JsonEnum(fieldRename: FieldRename.snake)
enum StaffPermissionLevel {
  fullAccess, // No restrictions
  managementAccess, // Manager-level operations
  salesAccess, // POS sales only
  viewOnly // Read-only (reports, logs)
}

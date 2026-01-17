// lib/core/localization/app_locale_keys.dart
abstract final class AppLocaleKeys {
  // General
  static const appName = 'app_name';
  static const ok = 'ok';
  static const cancel = 'cancel';
  static const yes = 'yes';
  static const no = 'no';
  static const loading = 'loading';
  static const error = 'error';

  // Authentication
  static const login = 'login';
  static const logout = 'logout';
  static const username = 'username';
  static const password = 'password';
  static const invalidCredentials = 'invalid_credentials';

  // POS Core
  static const pos = 'pos';
  static const newSale = 'new_sale';
  static const addProduct = 'add_product';
  static const quantity = 'quantity';
  static const price = 'price';
  static const total = 'total';
  static const subtotal = 'subtotal';
  static const discount = 'discount';
  static const tax = 'tax';
  static const grandTotal = 'grand_total';

  // Payments
  static const payment = 'payment';
  static const cash = 'cash';
  static const card = 'card';
  static const transfer = 'transfer';
  static const paymentSuccess = 'payment_success';
  static const paymentFailed = 'payment_failed';

  // Receipt
  static const receipt = 'receipt';
  static const printReceipt = 'print_receipt';
  static const receiptNumber = 'receipt_number';
  static const cashier = 'cashier';
  static const date = 'date';

  // Products
  static const products = 'products';
  static const productName = 'product_name';
  static const productCode = 'product_code';
  static const stock = 'stock';
  static const outOfStock = 'out_of_stock';

  // Settings
  static const settings = 'settings';
  static const language = 'language';
  static const currency = 'currency';
  static const theme = 'theme';

  // Generic alerts
  static const alertTitle = 'alert_title';
  static const confirmTitle = 'confirm_title';
  static const warningTitle = 'warning_title';
  static const errorTitle = 'error_title';
  static const successTitle = 'success_title';

  // Actions
  static const confirm = 'confirm';
  static const dismiss = 'dismiss';
  static const retry = 'retry';
  static const close = 'close';

  // POS-specific alerts
  static const deleteItemTitle = 'delete_item_title';
  static const deleteItemMessage = 'delete_item_message';

  static const cancelSaleTitle = 'cancel_sale_title';
  static const cancelSaleMessage = 'cancel_sale_message';

  static const paymentConfirmTitle = 'payment_confirm_title';
  static const paymentConfirmMessage = 'payment_confirm_message';

  static const outOfStockTitle = 'out_of_stock_title';
  static const outOfStockMessage = 'out_of_stock_message';

  static const sessionExpiredTitle = 'session_expired_title';
  static const sessionExpiredMessage = 'session_expired_message';

  // Generic errors
  static const unknownError = 'error_unknown';
  static const networkError = 'error_network';
  static const timeoutError = 'error_timeout';
  static const serverError = 'error_server';
  static const unauthorized = 'error_unauthorized';
  static const forbidden = 'error_forbidden';

  // Authentication
  static const loginFailed = 'error_login_failed';
  static const sessionExpired = 'error_session_expired';

  // POS Operations
  static const addProductFailed = 'error_add_product_failed';
  static const removeProductFailed = 'error_remove_product_failed';
  static const emptyCart = 'error_empty_cart';
  static const invalidQuantity = 'error_invalid_quantity';

  // Payment
  static const paymentCancelled = 'error_payment_cancelled';
  static const insufficientFunds = 'error_insufficient_funds';

  // Inventory
  static const stockSyncFailed = 'error_stock_sync_failed';

  // Printer
  static const printerNotFound = 'error_printer_not_found';
  static const printerDisconnected = 'error_printer_disconnected';
  static const receiptPrintFailed = 'error_receipt_print_failed';
}

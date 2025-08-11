class ErrorMessages {
  // Authentication
  static const String loginFailed = "Login failed. Please check your credentials.";
  static const String invalidEmail = "Invalid email address.";
  static const String passwordTooShort = "Password must be at least 8 characters.";
  static const String passwordsDoNotMatch = "Passwords do not match.";
  static const String accountNotFound = "Account not found.";
  static const String emailAlreadyInUse = "This email address is already in use.";

  // Network
  static const String noInternetConnection = "No internet connection. Please check your network.";
  static const String serverError = "A server error occurred. Please try again later.";
  static const String requestTimeout = "Request timed out. Please check your connection and try again.";

  // Product/Cart
  static const String productNotFound = "Product not found.";
  static const String outOfStock = "This product is currently out of stock.";
  static const String notEnoughStock = "Not enough stock available.";
  static const String maximumQuantityExceeded = "Maximum quantity exceeded for this product.";
  static const String cartLimitExceeded = "Your cart has reached the maximum limit.";
  static const String invalidProductOptions = "Please select valid product options.";
  static const String productAlreadyInCart = "This product is already in your cart.";
  static const String AddToCart = "A problem occurred. Please contact customer support if the issue persists.";

  // Form Validation
  static const String fieldRequired = "This field is required.";
  static const String invalidInput = "Invalid input.";
  static const String invalidPhoneNumber = "Invalid phone number.";

  // Other
  static const String unknownError = "An unknown error occurred. Please try again later.";
  static const String somethingWentWrong = "Something went wrong. Please try again later.";
  static const String locationNotAvailable = "Location services are not available.";
  static const String permissionDenied = "Permission denied.";


  // Example of a parameterized message (using a function)
  static String quantityAvailable(int quantity) => "Only $quantity units available.";
}

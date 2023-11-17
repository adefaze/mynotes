//login exceptions
class InvalidLoginCredentialsAuthException implements Exception {}

class InvalidEmailAddressAuthException implements Exception {}

//register exceptions
class EmailAlreadyInUseAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

// Generic exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

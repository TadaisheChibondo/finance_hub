// lib/services/fake_backend_service.dart

// A simple in-memory "database"
class FakeDatabase {
  // Store users: email -> password
  static final Map<String, String> users = {};

  // Store currently logged in user email
  static String? currentUserEmail;
}

class FakeBackendService {
  // Sign Up - creates a new user
  static Future<bool> signUp(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check if user already exists
    if (FakeDatabase.users.containsKey(email)) {
      throw Exception('Email already registered');
    }

    // Check password length
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Save user to fake database
    FakeDatabase.users[email] = password;
    FakeDatabase.currentUserEmail = email;

    return true;
  }

  // Login - signs in existing user
  static Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check if user exists
    if (!FakeDatabase.users.containsKey(email)) {
      throw Exception('No account found with this email');
    }

    // Check password
    if (FakeDatabase.users[email] != password) {
      throw Exception('Incorrect password');
    }

    FakeDatabase.currentUserEmail = email;
    return true;
  }

  // Logout - signs out current user
  static Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    FakeDatabase.currentUserEmail = null;
  }

  // Get current logged in user email
  static String? getCurrentUserEmail() {
    return FakeDatabase.currentUserEmail;
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    return FakeDatabase.currentUserEmail != null;
  }
}

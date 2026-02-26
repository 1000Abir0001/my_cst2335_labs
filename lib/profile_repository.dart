import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
// Using the repository pattern to store user's data
class ProfileRepository {
  final EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();

  // variables to hold loaded data
  String firstName = '';
  String lastName = '';
  String phone = '';
  String email = '';

  // loadData() - this function loads the variables
  Future<void> loadData() async {
    firstName = await _encryptedData.getString('firstName');
    lastName = await _encryptedData.getString('lastName');
    phone = await _encryptedData.getString('phone');
    email = await _encryptedData.getString('email');
  }

  // saveData() - this function saves the variables
  Future<void> saveData(String key, String value) async {
    await _encryptedData.setString(key, value);
  }
}

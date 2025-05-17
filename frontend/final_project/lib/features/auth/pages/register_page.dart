import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  bool _showPassword = false;
  int _step = 1;
  String _selectedGender = 'Nam';
  String? _selectedDay;
  String? _selectedMonth;

  int _getDaysInMonth(String? month) {
    switch (month) {
      case '2':
        return 28; // Note: Not handling leap years for simplicity
      case '4':
      case '6':
      case '9':
      case '11':
        return 30;
      default:
        return 31;
    }
  }

  void _nextStep() {
    // Basic validation before moving to the next step
    if (_step == 1 && _firstNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tên.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_step == 2 && (_dayController.text.isEmpty || _monthController.text.isEmpty || _yearController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ ngày sinh.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_step == 3 && _usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tên tài khoản.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_step == 4 && (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập mật khẩu và xác nhận mật khẩu.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      if (_step < 5) _step++;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu xác nhận không khớp'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập số điện thoại.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Create user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: '${_usernameController.text.trim()}@gmail.com',
        password: _passwordController.text.trim(),
      );

      // Update display name
      await userCredential.user?.updateDisplayName(
        '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'.trim(),
      );

      // Save user information to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': '${_usernameController.text.trim()}@gmail.com',
        'phone': _phoneController.text.trim(),
        'dateOfBirth': {
          'day': _dayController.text,
          'month': _monthController.text,
          'year': _yearController.text,
        },
        'gender': _selectedGender,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký thành công!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to LoginPage after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email đã được sử dụng.';
          break;
        case 'weak-password':
          message = 'Mật khẩu quá yếu.';
          break;
        case 'invalid-email':
          message = 'Email không hợp lệ.';
          break;
        default:
          message = 'Đăng ký thất bại: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi không xác định: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> days = List.generate(
      _selectedMonth != null ? _getDaysInMonth(_selectedMonth) : 31,
      (index) => (index + 1).toString(),
    );
    List<String> months = List.generate(12, (index) => (index + 1).toString());

    return Scaffold(
      backgroundColor: const Color(0xFF202124),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF303134),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  width: 600,
                  constraints: const BoxConstraints(minHeight: 350, maxHeight: double.infinity),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 30,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                                  width: 36,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Register',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 18,
                                    color: Color(0xFFE8EAED),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            LinearProgressIndicator(
                              value: _step / 5,
                              backgroundColor: const Color(0xFF5F6368),
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8AB4F8)),
                              minHeight: 4,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bước $_step của 5',
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12,
                                color: Color(0xFFBDC1C6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 55,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 260,
                                  child: TextField(
                                    controller: _lastNameController,
                                    style: const TextStyle(
                                      color: Color(0xFFE8EAED),
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Họ (không bắt buộc)',
                                      hintStyle: TextStyle(color: Color(0xFFBDC1C6)),
                                      filled: true,
                                      fillColor: Color(0xFF3C4043),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xFF5F6368)),
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xFF5F6368)),
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xFF8AB4F8)),
                                        borderRadius: BorderRadius.all(Radius.circular(603))),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: 260,
                                  child: TextField(
                                    controller: _firstNameController,
                                    style: const TextStyle(
                                      color: Color(0xFFE8EAED),
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Tên',
                                      hintStyle: TextStyle(color: Color(0xFFBDC1C6)),
                                      filled: true,
                                      fillColor: Color(0xFF3C4043),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xFF5F6368)),
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xFF5F6368)),
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xFF8AB4F8)),
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (_step >= 2) ...[
                              const SizedBox(height: 16),
                              const Text(
                                'Ngày sinh',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  color: Color(0xFFE8EAED),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedDay,
                                      hint: const Text(
                                        'Ngày',
                                        style: TextStyle(color: Color(0xFFBDC1C6), fontSize: 12),
                                      ),
                                      items: days.map((String day) {
                                        return DropdownMenuItem<String>(
                                          value: day,
                                          child: Text(
                                            day,
                                            style: const TextStyle(color: Color(0xFFE8EAED), fontSize: 12),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedDay = value;
                                          _dayController.text = value ?? '';
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xFF3C4043),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF5F6368)),
                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF5F6368)),
                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF8AB4F8)),
                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                        ),
                                      ),
                                      dropdownColor: const Color(0xFF3C4043),
                                      iconEnabledColor: const Color(0xFFE8EAED),
                                      isExpanded: true,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 90,
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedMonth,
                                      hint: const Text(
                                        'Tháng',
                                        style: TextStyle(color: Color(0xFFBDC1C6), fontSize: 12),
                                      ),
                                      items: months.map((String month) {
                                        return DropdownMenuItem<String>(
                                          value: month,
                                          child: Text(
                                            month,
                                            style: const TextStyle(color: Color(0xFFE8EAED), fontSize: 12),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedMonth = value;
                                          _monthController.text = value ?? '';
                                          _selectedDay = null;
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xFF3C4043),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF5F6368)),
                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF5F6368)),
                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF8AB4F8)),
                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                        ),
                                      ),
                                      dropdownColor: const Color(0xFF3C4043),
                                      iconEnabledColor: const Color(0xFFE8EAED),
                                      isExpanded: true,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 70,
                                    child: TextField(
                                      controller: _yearController,
                                      decoration: const InputDecoration(
                                        hintText: 'Năm',
                                        hintStyle: TextStyle(color: Color(0xFFBDC1C6), fontSize: 12),
                                        filled: true,
                                        fillColor: Color(0xFF3C4043),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF5F6368)),
                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF5F6368)),
                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF8AB4F8)),
                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                        ),
                                      ),
                                      style: const TextStyle(color: Color(0xFFE8EAED), fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Text(
                                    'Giới tính:',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      color: Color(0xFFE8EAED),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Row(
                                    children: [
                                      Radio(
                                        value: 'Nam',
                                        groupValue: _selectedGender,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedGender = value as String;
                                          });
                                        },
                                        activeColor: const Color(0xFF8AB4F8),
                                      ),
                                      const Text(
                                        'Nam',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 14,
                                          color: Color(0xFFE8EAED),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Radio(
                                        value: 'Nữ',
                                        groupValue: _selectedGender,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedGender = value as String;
                                          });
                                        },
                                        activeColor: const Color(0xFF8AB4F8),
                                      ),
                                      const Text(
                                        'Nữ',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 14,
                                          color: Color(0xFFE8EAED),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                            if (_step >= 3) ...[
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 260,
                                child: TextField(
                                  controller: _usernameController,
                                  style: const TextStyle(
                                    color: Color(0xFFE8EAED),
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Tên tài khoản',
                                    hintStyle: TextStyle(color: Color(0xFFBDC1C6)),
                                    filled: true,
                                    fillColor: Color(0xFF3C4043),
                                    suffixText: '@gmail.com',
                                    suffixStyle: TextStyle(color: Color(0xFFE8EAED)),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF5F6368)),
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF5F6368)),
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF8AB4F8)),
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            if (_step >= 4) ...[
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 260,
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: !_showPassword,
                                  style: const TextStyle(
                                    color: Color(0xFFE8EAED),
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Mật khẩu',
                                    hintStyle: TextStyle(color: Color(0xFFBDC1C6)),
                                    filled: true,
                                    fillColor: Color(0xFF3C4043),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF5F6368)),
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF5F6368)),
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF8AB4F8)),
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: 260,
                                child: TextField(
                                  controller: _confirmPasswordController,
                                  obscureText: !_showPassword,
                                  style: const TextStyle(
                                    color: Color(0xFFE8EAED),
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Xác nhận mật khẩu',
                                    hintStyle: TextStyle(color: Color(0xFFBDC1C6)),
                                    filled: true,
                                    fillColor: Color(0xFF3C4043),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF5F6368)),
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF5F6368)),
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF8AB4F8)),
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _showPassword,
                                    onChanged: (value) {
                                      _togglePasswordVisibility();
                                    },
                                    activeColor: const Color(0xFF8AB4F8),
                                  ),
                                  const Text(
                                    'Hiển thị mật khẩu',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                      color: Color(0xFFE8EAED),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (_step >= 5) ...[
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 260,
                                child: TextField(
                                  controller: _phoneController,
                                  style: const TextStyle(
                                    color: Color(0xFFE8EAED),
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Số điện thoại',
                                    hintStyle: TextStyle(color: Color(0xFFBDC1C6)),
                                    filled: true,
                                    fillColor: Color(0xFF3C4043),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF5F6368)),
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF5F6368)),
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF8AB4F8)),
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: _step >= 5 ? _register : _nextStep,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8AB4F8),
                                    foregroundColor: const Color(0xFF202124),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                    _step >= 5 ? 'Đăng ký' : 'Tiếp theo',
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: _navigateToLogin,
                                child: const Text(
                                  'Đã có tài khoản? Đăng nhập',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    color: Color(0xFF8AB4F8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
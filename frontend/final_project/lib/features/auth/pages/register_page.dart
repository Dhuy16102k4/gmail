import 'package:flutter/material.dart';

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
        return 28; // Simplified, not accounting for leap years
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
    setState(() {
      if (_step < 5) _step++;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
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
                  padding: const EdgeInsets.all(32),
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
                  width: 700,
                  constraints: const BoxConstraints(minHeight: 400, maxHeight: double.infinity),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 45,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                                  width: 40,
                                ),
                                const SizedBox(width: 12),
                                
                              ],
                            ),
                            const Text(
                                  '',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                    color: Color(0xFFE8EAED),
                                  ),
                                ),
                            const Text(
                                  'Tạo Tài khoản Google',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                    color: Color(0xFFE8EAED),
                                  ),
                                ),
                            const SizedBox(height: 12),
                            const Text(
                              'Nhập thông tin của bạn',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                color: Color(0xFFBDC1C6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
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
                                  width: 300,
                                  child: TextField(
                                    controller: _lastNameController,
                                    style: const TextStyle(
                                      color: Color(0xFFE8EAED),
                                      fontFamily: 'Roboto',
                                      fontSize: 16,
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
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: 300,
                                  child: TextField(
                                    controller: _firstNameController,
                                    style: const TextStyle(
                                      color: Color(0xFFE8EAED),
                                      fontFamily: 'Roboto',
                                      fontSize: 16,
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
                              const SizedBox(height: 24),
                              const Text(
                                'Ngày sinh',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  color: Color(0xFFE8EAED),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100, // Reduced width to prevent overflow
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedDay,
                                      hint: const Text(
                                        'Ngày',
                                        style: TextStyle(color: Color(0xFFBDC1C6)),
                                      ),
                                      items: days.map((String day) {
                                        return DropdownMenuItem<String>(
                                          value: day,
                                          child: Text(
                                            day,
                                            style: const TextStyle(color: Color(0xFFE8EAED)),
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
                                      isExpanded: true, // Ensure it uses available space
                                    ),
                                  ),
                                  const SizedBox(width: 10), // Reduced spacing
                                  SizedBox(
                                    width: 100, // Reduced width to prevent overflow
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedMonth,
                                      hint: const Text(
                                        'Tháng',
                                        style: TextStyle(color: Color(0xFFBDC1C6)),
                                      ),
                                      items: months.map((String month) {
                                        return DropdownMenuItem<String>(
                                          value: month,
                                          child: Text(
                                            month,
                                            style: const TextStyle(color: Color(0xFFE8EAED)),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedMonth = value;
                                          _monthController.text = value ?? '';
                                          _selectedDay = null; // Reset day when month changes
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
                                      isExpanded: true, // Ensure it uses available space
                                    ),
                                  ),
                                  const SizedBox(width: 10), // Reduced spacing
                                  SizedBox(
                                    width: 85, // Reduced width to prevent overflow
                                    child: TextField(
                                      controller: _yearController,
                                      decoration: const InputDecoration(
                                        hintText: 'Năm',
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
                                      style: const TextStyle(color: Color(0xFFE8EAED)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  const Text(
                                    'Giới tính:',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16,
                                      color: Color(0xFFE8EAED),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
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
                                          fontSize: 16,
                                          color: Color(0xFFE8EAED),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
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
                                          fontSize: 16,
                                          color: Color(0xFFE8EAED),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                            if (_step >= 3) ...[
                              const SizedBox(height: 24),
                              SizedBox(
                                width: 300,
                                child: TextField(
                                  controller: _usernameController,
                                  style: const TextStyle(
                                    color: Color(0xFFE8EAED),
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
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
                              const SizedBox(height: 24),
                              SizedBox(
                                width: 300,
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: !_showPassword,
                                  style: const TextStyle(
                                    color: Color(0xFFE8EAED),
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
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
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 300,
                                child: TextField(
                                  controller: _confirmPasswordController,
                                  obscureText: !_showPassword,
                                  style: const TextStyle(
                                    color: Color(0xFFE8EAED),
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
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
                              const SizedBox(height: 16),
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
                                      fontSize: 14,
                                      color: Color(0xFFE8EAED),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (_step >= 5) ...[
                              const SizedBox(height: 24),
                              SizedBox(
                                width: 300,
                                child: TextField(
                                  controller: _phoneController,
                                  style: const TextStyle(
                                    color: Color(0xFFE8EAED),
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
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
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: _nextStep,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8AB4F8),
                                    foregroundColor: const Color(0xFF202124),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                    _step >= 5 ? 'Đăng ký' : 'Tiếp theo',
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
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
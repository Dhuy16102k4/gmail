import 'package:flutter/material.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPasswordField = false;
  bool _emailFieldLocked = false;

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  void _showNext() {
    if (_emailController.text.trim().endsWith('@gmail.com')) {
      setState(() {
        _showPasswordField = true;
        _emailFieldLocked = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đúng định dạng @gmail.com'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _goBack() {
    setState(() {
      _showPasswordField = false;
      _emailFieldLocked = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202124),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(40),
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
                  width: 800,
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
                                const Text(
                                  'Đăng nhập',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                    color: Color(0xFFE8EAED),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Sử dụng Tài khoản Google của bạn',
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
                            SizedBox(
                              width: 350,
                              child: TextField(
                                controller: _emailController,
                                enabled: !_emailFieldLocked,
                                style: const TextStyle(
                                  color: Color(0xFFE8EAED),
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Email hoặc số điện thoại',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFBDC1C6),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFF3C4043),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFF5F6368),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFF5F6368),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFF8AB4F8),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFF5F6368),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                            if (_showPasswordField) ...[
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 350,
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  style: const TextStyle(
                                    color: Color(0xFFE8EAED),
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Mật khẩu',
                                    hintStyle: const TextStyle(
                                      color: Color(0xFFBDC1C6),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFF3C4043),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xFF5F6368),
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xFF5F6368),
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xFF8AB4F8),
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            if (!_showPasswordField)
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Bạn quên mật khẩu?',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    color: Color(0xFF8AB4F8),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),
                            const SizedBox(
                              width: 350,
                              child: Text(
                                'Đây không phải máy tính của bạn? Hãy sử dụng Chế độ khách để đăng nhập một cách riêng tư. Tìm hiểu thêm về Chế độ khách',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  color: Color(0xFFBDC1C6),
                                  height: 1.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (_showPasswordField)
                                  TextButton(
                                    onPressed: _goBack,
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF8AB4F8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                    ),
                                    child: const Text(
                                      'Trở về',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                TextButton(
                                  onPressed: _navigateToRegister,
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF8AB4F8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                  ),
                                  child: const Text(
                                    'Tạo tài khoản',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: _showNext,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8AB4F8),
                                    foregroundColor: const Color(0xFF202124),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 8,
                                    ),
                                  ),
                                  child: const Text(
                                    'Tiếp theo',
                                    style: TextStyle(
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
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Tiếng Việt',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: Color(0xFFBDC1C6),
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  'Trợ giúp',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: Color(0xFFBDC1C6),
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  'Quyền riêng tư',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: Color(0xFFBDC1C6),
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  'Điều khoản',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: Color(0xFFBDC1C6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
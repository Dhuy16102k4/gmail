import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Fetch user data from Firestore
  Future<Map<String, dynamic>?> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      return null;
    }
  }

  // Get avatar text (first letter of first name or 'U' as fallback)
  String _getAvatarText(Map<String, dynamic>? userData) {
    if (userData != null && userData['firstName'] != null) {
      final firstName = userData['firstName'] as String;
      return firstName.isNotEmpty ? firstName[0].toUpperCase() : 'U';
    }
    return 'U';
  }

  // Show profile dialog
  void _showProfileDialog(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await _fetchUserData();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF303134),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Hồ sơ',
          style: TextStyle(
            color: Color(0xFFE8EAED),
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display name
            Text(
              userData != null
                  ? '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'.trim()
                  : user?.displayName ?? 'Không có tên',
              style: const TextStyle(
                color: Color(0xFFE8EAED),
                fontFamily: 'Roboto',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            // Email
            Text(
              user?.email ?? 'Không có email',
              style: const TextStyle(
                color: Color(0xFFBDC1C6),
                fontFamily: 'Roboto',
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            // Logout button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8AB4F8),
                  foregroundColor: const Color(0xFF202124),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  'Đăng xuất',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Logout function
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi đăng xuất: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C4043),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFFE8EAED)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Tìm trong thư',
              hintStyle: TextStyle(color: Color(0xFFBDC1C6)),
              border: InputBorder.none,
            ),
            style: TextStyle(color: Color(0xFFE8EAED)),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FutureBuilder<Map<String, dynamic>?>(
              future: _fetchUserData(),
              builder: (context, snapshot) {
                final avatarText = snapshot.hasData
                    ? _getAvatarText(snapshot.data)
                    : 'U';
                return GestureDetector(
                  onTap: () => _showProfileDialog(context),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFF5F6368),
                    child: Text(
                      avatarText,
                      style: const TextStyle(color: Color(0xFFE8EAED)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF2A2E32),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF2A2E32),
              ),
              child: Image.asset(
                'assets/images/logo_gmail.png',
                height: 40,
                errorBuilder: (context, error, stackTrace) => const Text(
                  'Gmail',
                  style: TextStyle(
                    color: Color(0xFFE8EAED),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Divider(color: Color(0xFF3C4043)),
            _buildDrawerItem('📥', 'Tất cả thư', '10 thg 5'),
            const Divider(color: Color(0xFF3C4043)),
            _buildDrawerItem('📬', 'Chính', '99+', isActive: true),
            _buildDrawerItem('👥', 'Mạng xã hội', '24 mới'),
            _buildDrawerItem('📢', 'Quảng cáo', '28 mới'),
            _buildDrawerItem('🔔', 'Nội dung cập nhật', '28 mới'),
            const Divider(color: Color(0xFF3C4043)),
            _buildDrawerItem('⭐', 'Có gắn dấu sao', '24 mới'),
            _buildDrawerItem('👁️‍🗨️', 'Đã ẩn', '24 mới'),
            _buildDrawerItem('❗', 'Quan trọng', '99+'),
            _buildDrawerItem('📤', 'Đã gửi', '12 thg 5'),
            _buildDrawerItem('⏰', 'Đã lên lịch', '11 thg 5'),
            _buildDrawerItem('📦', 'Hộp thư đi', '10 thg 5'),
            _buildDrawerItem('📝', 'Thư nháp', '2'),
            _buildDrawerItem('🚫', 'Thư rác', '10 thg 5'),
            _buildDrawerItem('🗑️', 'Thùng rác', '10 thg 5'),
            const Divider(color: Color(0xFF3C4043)),
            _buildDrawerItem('➕', 'Tạo mới', ''),
            const Divider(color: Color(0xFF3C4043)),
            _buildDrawerItem('⚙️', 'Cài đặt', ''),
            _buildDrawerItem('💬', 'Gửi ý kiến phản hồi', ''),
            _buildDrawerItem('❓', 'Trợ giúp', ''),
          ],
        ),
      ),
      body: ListView(
        children: [
          _buildEmailItem(
            '🔥',
            'Khoa công nghệ thông tin',
            'V/v Tham gia Buổi 2 - Đối thoại sinh viên...',
            '12:04',
          ),
          const Divider(color: Color(0xFF3C4043)),
          _buildEmailItem(
            '🔥',
            'Khoa công nghệ thông tin',
            'V/v Cần báo điểm rèn luyện và cô hội cải thi...',
            '16 thg 5',
          ),
          _buildEmailItem(
            '🔥',
            'Khoa công nghệ thông tin',
            'LINK ĐỐI THOAI SINH VIEN LẦN 2 HK2/2024-...',
            '15 thg 5',
          ),
          _buildEmailItem(
            '🔥',
            'Khoa công nghệ thông tin 2',
            '[Bắt buộc tham gia] ĐỐI THOAI SINH VIEN KH...',
            '15 thg 5',
          ),
          _buildEmailItem(
            'N',
            'Nguyen Thanh An (Classroom)',
            'New material: "[2425-HK2][Process 1 Score -...',
            '15 thg 5',
          ),
          const Divider(color: Color(0xFF3C4043)),
          _buildEmailItem(
            '📧',
            'Văn phòng Đoàn hội 2',
            'Hoạt động dành ứng viên chi trông xét Đam...',
            '14 thg 5',
          ),
          _buildEmailItem(
            'G',
            'Google Forms',
            'Đăng ký bộ sung Duy án Công nghệ thông ti...',
            '14 thg 5',
          ),
          _buildEmailItem(
            '👗',
            'English Group',
            '🎉 Funky Friday in May 20🎉...',
            '14 thg 5',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF1A73E8),
        label: const Text(
          'Soạn thư',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildDrawerItem(String icon, String title, String count, {bool isActive = false}) {
    return ListTile(
      leading: Text(icon, style: const TextStyle(fontSize: 18)),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? const Color(0xFF8AB4F8) : const Color(0xFFE8EAED),
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
          if (count.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF5F6368),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count,
                style: const TextStyle(
                  color: Color(0xFFE8EAED),
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      tileColor: isActive ? const Color(0xFF3C4043) : null,
      onTap: () {},
    );
  }

  Widget _buildEmailItem(String avatar, String title, String message, String time) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: const Color(0xFF5F6368),
        child: Text(
          avatar,
          style: const TextStyle(
            color: Color(0xFFE8EAED),
            fontSize: 20,
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFE8EAED),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        message,
        style: const TextStyle(
          color: Color(0xFFBDC1C6),
          fontSize: 13,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        time,
        style: const TextStyle(
          color: Color(0xFFBDC1C6),
          fontSize: 12,
        ),
      ),
      onTap: () {},
    );
  }
}
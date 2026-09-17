import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/firebase_service.dart';

class LeaderboardScreen extends StatefulWidget {
  LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<LeaderboardEntry>? _leaderboard;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    final data = await FirebaseService.getLeaderboard();
    if (mounted) {
      setState(() {
        _leaderboard = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'LİDERLİK TABLOSU',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppColors.textMain,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textMain),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: AppColors.primaryShadow, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.emoji_events_rounded, color: AppColors.warning, size: 32),
                        SizedBox(width: 8),
                        Text(
                          'Haftanın En İyileri',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ).animate().slideY(begin: -0.2, end: 0).fadeIn(),
                  SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _leaderboard!.length,
                      itemBuilder: (context, index) {
                        final entry = _leaderboard![index];
                        final isTop3 = index < 3;
                        
                        Color rankColor;
                        if (index == 0) rankColor = Color(0xFFFFD700); // Gold
                        else if (index == 1) rankColor = Color(0xFFC0C0C0); // Silver
                        else if (index == 2) rankColor = Color(0xFFCD7F32); // Bronze
                        else rankColor = AppColors.textLight;

                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isTop3 ? rankColor : Color(0xFFE5E5E5),
                              width: isTop3 ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isTop3 ? rankColor.withOpacity(0.2) : Color(0xFFF0F0F0),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    entry.rank,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: isTop3 ? rankColor : AppColors.textMain,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  entry.nickname,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textMain,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${entry.score}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.star_rounded, color: AppColors.warning, size: 20),
                                ],
                              ),
                            ],
                          ),
                        ).animate().slideX(begin: 0.2, end: 0, delay: Duration(milliseconds: 100 * index)).fadeIn();
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

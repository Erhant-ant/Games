import 'package:flutter/material.dart';

import '../services/multiplayer_service.dart';
import '../theme/app_theme.dart';
import 'game_screen.dart';

class MultiplayerSetupScreen extends StatefulWidget {
  const MultiplayerSetupScreen({super.key});

  @override
  State<MultiplayerSetupScreen> createState() => _MultiplayerSetupScreenState();
}

class _MultiplayerSetupScreenState extends State<MultiplayerSetupScreen> {
  final MultiplayerService _mpService = MultiplayerService();
  bool _isPermissionsGranted = false;
  bool _isScanning = false;
  bool _isHosting = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    bool granted = await _mpService.requestPermissions();
    setState(() {
      _isPermissionsGranted = granted;
    });

    if (granted) {
      await _mpService.initService();
      // Otomatik olarak bağlı cihazları dinleyelim, eğer biri bize bağlanırsa oyuna geçelim
      _mpService.devicesStream.listen((devices) {
        if (!mounted) return;
        for (var d in devices) {
          if (d.state == SessionState.connected) {
            // Bağlantı kuruldu, oyuna geç
            _goToGame();
            break;
          }
        }
      });
    }
  }

  void _startHost() async {
    setState(() => _isHosting = true);
    await _mpService.startHosting();
  }

  void _startScan() async {
    setState(() => _isScanning = true);
    await _mpService.startBrowsing();
  }
  
  void _stopScan() {
    setState(() {
      _isScanning = false;
      _isHosting = false;
    });
    _mpService.stopAll();
  }

  void _goToGame() {
    _mpService.stopAll(); // Reklam/Taramayı durdur, oyuna geç
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const GameScreen(isMultiplayer: true)),
    );
  }

  @override
  void dispose() {
    // Sadece bu ekrandan çıkarken eğer bağlantı yoksa servisi kapat
    if (_mpService.connectedDevice == null) {
      _mpService.stopAll();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isPermissionsGranted) {
      return Scaffold(
        backgroundColor: AppTheme.surfaceDark,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: AppTheme.gold),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bluetooth_disabled, color: Colors.redAccent, size: 64),
              const SizedBox(height: 24),
              const Text(
                'Bluetooth ve Konum izinleri gereklidir.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _checkPermissions,
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldDark),
                child: const Text('İZİNLERİ VER', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      appBar: AppBar(
        title: const Text('BLUETOOTH İLE OYNA', style: TextStyle(color: AppTheme.goldBright, letterSpacing: 2)),
        backgroundColor: AppTheme.surfaceMid,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(
          color: AppTheme.gold,
          onPressed: () {
            _stopScan();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Row(
        children: [
          // Sol Panel: Mod Seçimi
          Expanded(
            flex: 1,
            child: Container(
              color: AppTheme.surfaceMid.withValues(alpha: 0.3),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _BigButton(
                    title: 'ODA KUR',
                    subtitle: 'Beyaz Taş (İlk Başlar)',
                    icon: Icons.cell_wifi,
                    isActive: _isHosting,
                    onTap: () {
                      _stopScan();
                      _startHost();
                    },
                  ),
                  const SizedBox(height: 24),
                  _BigButton(
                    title: 'ODAYA KATIL',
                    subtitle: 'Siyah Taş (İkinci Başlar)',
                    icon: Icons.radar,
                    isActive: _isScanning,
                    onTap: () {
                      _stopScan();
                      _startScan();
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Sağ Panel: Cihaz Listesi
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isHosting ? 'BAĞLANTI BEKLENİYOR...' : (_isScanning ? 'CİHAZLAR ARANIYOR...' : 'LÜTFEN BİR MOD SEÇİN'),
                    style: const TextStyle(
                      color: AppTheme.goldBright,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isHosting)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(48.0),
                        child: CircularProgressIndicator(color: AppTheme.gold),
                      ),
                    ),
                  if (_isScanning)
                    Expanded(
                      child: StreamBuilder<List<Device>>(
                        stream: _mpService.devicesStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('Yakında cihaz bulunamadı...', style: TextStyle(color: AppTheme.textMuted)),
                            );
                          }
                          
                          final devices = snapshot.data!;
                          return ListView.builder(
                            itemCount: devices.length,
                            itemBuilder: (context, index) {
                              final device = devices[index];
                              return Card(
                                color: AppTheme.surfaceMid,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: AppTheme.gold.withValues(alpha: 0.3)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Text(device.deviceName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                    device.state == SessionState.connected ? 'Bağlanıldı' : (device.state == SessionState.connecting ? 'Bağlanıyor...' : 'Müsait'),
                                    style: TextStyle(color: device.state == SessionState.connected ? Colors.greenAccent : AppTheme.textMuted),
                                  ),
                                  trailing: ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldDark),
                                    onPressed: device.state == SessionState.connected ? null : () => _mpService.invitePeer(device),
                                    child: const Text('BAĞLAN', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BigButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _BigButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.goldDark.withValues(alpha: 0.3) : AppTheme.surfaceMid,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? AppTheme.goldBright : AppTheme.boardFrameDark,
            width: 2,
          ),
          boxShadow: isActive ? [BoxShadow(color: AppTheme.gold.withValues(alpha: 0.2), blurRadius: 16)] : [],
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: isActive ? AppTheme.goldBright : AppTheme.textSecondary),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : AppTheme.textSecondary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: isActive ? AppTheme.gold : AppTheme.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

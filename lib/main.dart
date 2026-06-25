import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/assistant_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/vault_screen.dart';
import 'services/storage_service.dart';
import 'state/app_state.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = StorageService();
  await storage.init();
  final appState = AppState(storage);
  await appState.load();
  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: const CampusGptApp(),
    ),
  );
}

class CampusGptApp extends StatelessWidget {
  const CampusGptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusGPT',
      debugShowCheckedModeBanner: false,
      theme: CampusGptTheme.darkTheme,
      home: const AppRoot(),
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((results) {
      final online = results.any((r) => r != ConnectivityResult.none);
      if (mounted) context.read<AppState>().setOnline(online);
    });
    Connectivity().checkConnectivity().then((results) {
      final online = results.any((r) => r != ConnectivityResult.none);
      if (mounted) context.read<AppState>().setOnline(online);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    if (appState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (appState.user == null) {
      return const LoginScreen();
    }
    return const MainShell();
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    NotesScreen(),
    AssistantScreen(),
    VaultScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.5,
                colors: [
                  Color(0xFF1A1F3C),
                  CampusGptTheme.surfaceContainerLowest,
                ],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
          if (!appState.isOnline)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Material(
                color: CampusGptTheme.error.withOpacity(0.92),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.wifi_off, size: 18),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text('Offline — AI uses local responses until you reconnect.'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 80 + 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () => setState(() => _currentIndex = 2),
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [CampusGptTheme.primary, CampusGptTheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: CampusGptTheme.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.bolt, color: CampusGptTheme.onPrimary, size: 28),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: CampusGptTheme.surface.withOpacity(0.6),
          border: Border(
            top: BorderSide(
              color: CampusGptTheme.onSurface.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              indicatorColor: CampusGptTheme.secondaryContainer.withOpacity(0.2),
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.description_outlined),
                  selectedIcon: Icon(Icons.description),
                  label: 'Notes',
                ),
                NavigationDestination(
                  icon: Icon(Icons.auto_stories_outlined),
                  selectedIcon: Icon(Icons.auto_stories),
                  label: 'Study',
                ),
                NavigationDestination(
                  icon: Icon(Icons.folder_outlined),
                  selectedIcon: Icon(Icons.folder),
                  label: 'Vault',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

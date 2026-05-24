import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const TransporteApp());
}

class TransporteApp extends StatelessWidget {
  const TransporteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Transporte',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1), // Azul institucional oscuro
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        // Configuración global para que todos los botones se vean modernos
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
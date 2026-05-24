import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Temporizador: Espera 3 segundos y luego salta a la pantalla de Welcome
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1), // Fondo azul institucional
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Círculo blanco con el ícono del bus
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.directions_bus, size: 70, color: Color(0xFF0D47A1)),
            ),
            const SizedBox(height: 30),
            // Nombre del sistema
            const Text(
              'SIGTRANSPORTE',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
            ),
            const SizedBox(height: 10),
            const Text(
              'Cochabamba - Bolivia',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 50),
            // Ruedita de carga nativa
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
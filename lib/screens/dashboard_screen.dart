import 'package:flutter/material.dart';
import 'recharge_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Variable de estado que cambiará dinamicamente
  double _saldo = 0.00;

  void _ejecutarRecarga() async {
    // Navegamos a la nueva pantalla de recargas y ESPERAMOS (await) a que devuelva un resultado
    final montoRecargado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RechargeScreen()),
    );

    // Verificamos si el usuario confirmo y devolvió un numero
    if (montoRecargado != null && montoRecargado is double) {
      setState(() {
        _saldo += montoRecargado; 
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Recarga de ${montoRecargado.toStringAsFixed(2)} Bs. realizada con éxito!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Billetera', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Tarjeta de Saldo con degradado y sombras modernas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade800, Colors.blue.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'SALDO DISPONIBLE:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  // Muestra el valor de la variable formateado a 2 decimales
                  Text(
                    '${_saldo.toStringAsFixed(2)} Bs.',
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Panel de botones de acción interactivos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionCard(
                  icon: Icons.phone_android,
                  label: 'Recarga tu\nTarjeta',
                  onTap: _ejecutarRecarga, // Vinculado a la función de sumar dinero
                ),
                _buildActionCard(
                  icon: Icons.currency_exchange,
                  label: 'Realizar\nTransferencias',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Módulo de transferencias en desarrollo')),
                    );
                  },
                ),
                _buildActionCard(
                  icon: Icons.history,
                  label: 'Historial\n',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Historial de viajes vacío')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Estructura visual para las tarjetas de acciones del menú
  Widget _buildActionCard({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 105,
        height: 125,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF0D47A1).withOpacity(0.3), width: 1.5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 38, color: const Color(0xFF0D47A1)),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
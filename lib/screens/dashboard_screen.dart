import 'package:flutter/material.dart';
import 'recharge_screen.dart';
import 'link_card_screen.dart';
import 'history_screen.dart';
import 'monitoring_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double _saldo = 0.00;
  bool _tarjetaVinculada = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIGTRANSPORTE', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        // Al quitar automaticallyImplyLeading: false, Flutter maneja automáticamente 
        // la apertura del menú lateral con el ícono de la hamburguesa.
      ),
      
      // IMPLEMENTACIÓN DEL MENÚ LATERAL (DRAWER)
      drawer: Drawer(
        child: Column(
          children: [
            // Encabezado de la cuenta con la foto simulada y datos del usuario
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF0D47A1), // Color azul institucional
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Color(0xFF0D47A1)),
              ),
              accountName: const Text(
                'Usuario Administrador',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: const Text('admin@sigtransporte.com'),
            ),
            
            // Opción: Ajustes de cuenta
            ListTile(
              leading: const Icon(Icons.manage_accounts, color: Color(0xFF0D47A1)),
              title: const Text('Ajustes de cuenta', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context); // Cierra el menú lateral
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Módulo de Ajustes de Cuenta en desarrollo')),
                );
              },
            ),
            
            // Opción: Términos y condiciones
            ListTile(
              leading: const Icon(Icons.description, color: Color(0xFF0D47A1)),
              title: const Text('Términos y condiciones', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Módulo de Términos y Condiciones en desarrollo')),
                );
              },
            ),
            
            // Opción: Soporte técnico
            ListTile(
              leading: const Icon(Icons.contact_support, color: Color(0xFF0D47A1)),
              title: const Text('Soporte técnico', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Soporte técnico: soporte@sigtransporte.com')),
                );
              },
            ),
            
            const Divider(),
            const Spacer(), // Empuja el botón de salida hacia la parte inferior del panel
            
            // Opción: Cerrar Sesión trasladado de manera elegante al menú lateral
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Cerrar Sesión', 
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.redAccent),
              ),
              onTap: () {
                // Limpia el árbol de navegación y regresa a la pantalla de login (AuthScreen)
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Tarjeta de Saldo Principal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue.shade900, Colors.blue.shade600]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  const Text('SALDO DISPONIBLE', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('${_saldo.toStringAsFixed(2)} Bs.', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Cuadrícula de Acciones (2x2)
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildMenuCard(
                  'Recarga Virtual', 
                  Icons.account_balance_wallet, 
                  Colors.orange, 
                  () async {
                    final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => const RechargeScreen()));
                    if (res != null) setState(() => _saldo += res);
                  }
                ),
                _buildMenuCard(
                  _tarjetaVinculada ? 'Plástico Vinculado' : 'Vincular Tarjeta', 
                  _tarjetaVinculada ? Icons.check_circle : Icons.nfc, 
                  _tarjetaVinculada ? Colors.green : Colors.blue, 
                  () async {
                    if (_tarjetaVinculada) return;
                    final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => const LinkCardScreen()));
                    if (res == true) setState(() => _tarjetaVinculada = true);
                  }
                ),
                _buildMenuCard(
                  'Monitoreo Rutas', 
                  Icons.map, 
                  Colors.purple, 
                  () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MonitoringScreen()))
                ),
                _buildMenuCard(
                  'Historial Viajes', 
                  Icons.history, 
                  Colors.blueGrey, 
                  () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()))
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: color),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
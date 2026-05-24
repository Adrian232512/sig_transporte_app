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
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
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
                  _tarjetaVinculada ? 'Tarjeta Vinculada' : 'Vincular Tarjeta', 
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
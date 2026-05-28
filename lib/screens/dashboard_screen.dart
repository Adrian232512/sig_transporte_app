import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'recharge_screen.dart';
import 'link_card_screen.dart';
import 'history_screen.dart';
import 'monitoring_screen.dart';

class DashboardScreen extends StatefulWidget {
  // Variables que recibe desde el Login
  final String nombreUsuario;
  final bool esEstudiante;

  const DashboardScreen({
    super.key, 
    this.nombreUsuario = 'Usuario Administrador', 
    this.esEstudiante = false
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double _saldo = 0.00;
  bool _tarjetaVinculada = false;

  void _generarPasajeQR() {
    // 1. APLICAMOS LA REGLA DE NEGOCIO PARA EL PRECIO Y EL COLOR
    double costoPasaje = widget.esEstudiante ? 2.50 : 3.00;
    String tipoBoleto = widget.esEstudiante ? 'ESTUDIANTE (2.50 Bs)' : 'NORMAL (3.00 Bs)';
    Color colorTema = widget.esEstudiante ? Colors.green.shade700 : const Color(0xFF0D47A1);

    String datosDelBoleto = "SIGTRANSPORTE|USER:${widget.nombreUsuario}|TYPE:$tipoBoleto|TIME:${DateTime.now().toIso8601String()}";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              
              Text(
                'Pasaje $tipoBoleto',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorTema),
              ),
              const SizedBox(height: 10),
              const Text('Acerca este código QR al validador del bus.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 30),
              
              // WIDGET DEL QR CON COLOR DINÁMICO
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colorTema.withOpacity(0.3), width: 2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: colorTema.withOpacity(0.1), blurRadius: 10)],
                ),
                child: QrImageView(
                  data: datosDelBoleto,
                  version: QrVersions.auto,
                  size: 220.0,
                  gapless: false,
                  eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: colorTema),
                  dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Colors.black87),
                ),
              ),
              
              const SizedBox(height: 30),

              // BOTÓN SIMULADOR CON DESCUENTO DINÁMICO
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorTema,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.document_scanner, color: Colors.white),
                  label: Text('SIMULAR PAGO DE $costoPasaje Bs.', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    if (_saldo >= costoPasaje) {
                      Navigator.pop(context);
                      setState(() {
                        _saldo -= costoPasaje;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('¡Pasaje pagado! $costoPasaje Bs. descontados.'), backgroundColor: Colors.green),
                      );
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Saldo insuficiente. Recarga tu billetera.'), backgroundColor: Colors.red),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CERRAR', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIGTRANSPORTE', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF0D47A1)),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Color(0xFF0D47A1)),
              ),
              // MOSTRAMOS EL NOMBRE REAL DE LA BASE DE DATOS
              accountName: Text(widget.nombreUsuario, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              accountEmail: Text(widget.esEstudiante ? 'Cuenta Universitaria' : 'Cuenta Estándar'),
            ),
            _buildDrawerItem(Icons.manage_accounts, 'Ajustes de cuenta'),
            const Divider(),
            const Spacer(),
            _buildDrawerItem(Icons.logout, 'Cerrar Sesión', color: Colors.redAccent, onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  // Si es estudiante el fondo de la billetera es verde oscuro, si no, azul
                  colors: widget.esEstudiante 
                    ? [Colors.teal.shade900, Colors.green.shade600] 
                    : [Colors.blue.shade900, Colors.blue.shade600]
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)],
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
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildMenuCard('Recarga Virtual', Icons.account_balance_wallet, Colors.orange, () async {
                    final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => const RechargeScreen()));
                    if (res != null) setState(() => _saldo += res);
                  }
                ),
                _buildMenuCard(_tarjetaVinculada ? 'Plástico Vinculado' : 'Vincular Tarjeta', _tarjetaVinculada ? Icons.check_circle : Icons.nfc, _tarjetaVinculada ? Colors.green : Colors.blue, () async {
                    if (_tarjetaVinculada) return;
                    final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => const LinkCardScreen()));
                    if (res == true) setState(() => _tarjetaVinculada = true);
                  }
                ),
                _buildMenuCard('Monitoreo Rutas', Icons.map, Colors.purple, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MonitoringScreen()))),
                _buildMenuCard('Historial Viajes', Icons.history, Colors.blueGrey, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()))),
              ],
            ),
            const SizedBox(height: 80), 
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generarPasajeQR,
        // Color dinámico del botón flotante
        backgroundColor: widget.esEstudiante ? Colors.green.shade700 : const Color(0xFF0D47A1), 
        icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
        label: const Text('PAGAR PASAJE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, 
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {Color color = const Color(0xFF0D47A1), VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color == Colors.redAccent ? Colors.redAccent : Colors.black87)),
      onTap: onTap ?? () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Módulo $title en desarrollo')));
      },
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
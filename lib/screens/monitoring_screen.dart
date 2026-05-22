import 'package:flutter/material.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  // 1. Base de datos ficticia de las líneas registradas
  final List<String> _lineasRegistradas = [
    'Selecciona una línea...', // Opción por defecto
    'Línea V - Micro (Norte-Sur)',
    'Trufi 10 - Taxi (Este-Oeste)',
    'Micro 1 - Central',
    'Trufi 132 - Variante A'
  ];

  // Variable para guardar qué línea seleccionó el usuario
  String _lineaSeleccionada = 'Selecciona una línea...';

  // 2. Base de datos ficticia de las ubicaciones de los buses por línea (Simulación GPS)
  // Usamos Positioned dentro de un Stack para "moverlos" en el mapa
  final Map<String, List<Widget>> _busesEnTiempoReal = {
    'Línea V - Micro (Norte-Sur)': [
      const Positioned(top: 50, left: 100, child: Icon(Icons.directions_bus, color: Color(0xFF0D47A1), size: 35)),
      const Positioned(top: 150, left: 120, child: Icon(Icons.directions_bus, color: Color(0xFF0D47A1), size: 35)),
      const Positioned(top: 300, left: 110, child: Icon(Icons.directions_bus, color: Color(0xFF0D47A1), size: 35)),
    ],
    'Trufi 10 - Taxi (Este-Oeste)': [
      const Positioned(top: 180, left: 50, child: Icon(Icons.local_taxi, color: Colors.orange, size: 30)),
      const Positioned(top: 185, left: 150, child: Icon(Icons.local_taxi, color: Colors.orange, size: 30)),
      const Positioned(top: 175, left: 250, child: Icon(Icons.local_taxi, color: Colors.orange, size: 30)),
    ],
    'Micro 1 - Central': [
      const Positioned(top: 220, left: 180, child: Icon(Icons.directions_bus, color: Color.fromARGB(255, 223, 52, 52), size: 35)),
    ],
    'Trufi 132 - Variante A': [], // Simulación de línea sin buses activos
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoreo en Tiempo Real', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // PANEL SUPERIOR: Buscador y Dropdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Column(
              children: [
                // Buscador de dirección
                TextField(
                  decoration: InputDecoration(
                    hintText: '¿A dónde quieres ir hoy?',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 15),
                // LA LISTA DESPLEGABLE (Dropdown)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D47A1).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF0D47A1).withOpacity(0.3)),
                  ),
                  child: DropdownButton<String>(
                    value: _lineaSeleccionada,
                    isExpanded: true, // Ocupa todo el ancho
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0D47A1)),
                    underline: Container(), // Oculta la línea de subrayado nativa
                    style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                    onChanged: (String? nuevoValor) {
                      // Actualizamos el estado para redibujar el mapa simulado
                      setState(() {
                        _lineaSeleccionada = nuevoValor!;
                      });
                    },
                    items: _lineasRegistradas.map<DropdownMenuItem<String>>((String valor) {
                      return DropdownMenuItem<String>(
                        value: valor,
                        child: Text(valor, style: TextStyle(
                          color: valor == 'Selecciona una línea...' ? Colors.grey : Colors.black87,
                          fontWeight: valor == 'Selecciona una línea...' ? FontWeight.normal : FontWeight.bold
                        )),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // ÁREA DEL MAPA SIMULADO
          Expanded(
            child: Stack(
              children: [
                // Fondo simulando cuadrante de calles (Ya no es imagen URL vacía)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.grey.shade100,
                  child: CustomPaint(
                    painter: MapSimPainter(), // Dibujamos líneas grises para las "calles"
                  ),
                ),
                // MOSTRAR BUSES DE LA LÍNEA SELECCIONADA
                // Obtenemos la lista de buses ficticios para la línea elegida
                ...(_busesEnTiempoReal[_lineaSeleccionada] ?? []),
                
                // Mensaje si no hay línea seleccionada o no hay buses
                if (_lineaSeleccionada == 'Selecciona una línea...')
                  Container(
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: Text('Usa el selector de arriba para ver las movilidades de una línea', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
                    ),
                  ),
                if (_lineaSeleccionada != 'Selecciona una línea...' && (_busesEnTiempoReal[_lineaSeleccionada]?.isEmpty ?? true))
                   Container(
                     color: Colors.grey.shade100,
                     child: const Center(
                       child: Text('No hay unidades activas en tiempo real para esta línea', textAlign: TextAlign.center, style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                     ),
                   ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Pintor Custom para dibujar las "calles" ficticias del mapa
class MapSimPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 2;

    // Dibujar cuadrícula
    for (double i = 0; i < size.width; i += 50) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 50) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
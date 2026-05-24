import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de datos ficticios contextualizados
    final List<Map<String, dynamic>> viajes = [
      {'ruta': 'Línea V', 'tipo': 'Micro', 'fecha': 'Hoy, 14:30', 'costo': 2.00},
      {'ruta': 'Trufi 10', 'tipo': 'Trufi', 'fecha': 'Ayer, 08:15', 'costo': 2.00},
      {'ruta': 'Línea 1', 'tipo': 'Micro', 'fecha': '19 de Mayo, 18:45', 'costo': 2.00},
      {'ruta': 'Trufi 103', 'tipo': 'Trufi', 'fecha': '18 de Mayo, 07:30', 'costo': 2.00},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Viajes', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: viajes.length,
        itemBuilder: (context, index) {
          final viaje = viajes[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF0D47A1).withOpacity(0.1),
                child: Icon(
                  viaje['tipo'] == 'Micro' ? Icons.directions_bus : Icons.local_taxi,
                  color: const Color(0xFF0D47A1),
                ),
              ),
              title: Text(
                '${viaje['tipo']} - ${viaje['ruta']}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(viaje['fecha'], style: const TextStyle(color: Colors.black54)),
              trailing: Text(
                '-${viaje['costo'].toStringAsFixed(2)} Bs.',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}
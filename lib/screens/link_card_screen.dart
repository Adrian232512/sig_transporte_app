import 'package:flutter/material.dart';

class LinkCardScreen extends StatefulWidget {
  const LinkCardScreen({super.key});

  @override
  State<LinkCardScreen> createState() => _LinkCardScreenState();
}

class _LinkCardScreenState extends State<LinkCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardController = TextEditingController();

  void _vincularTarjeta() {
    if (_formKey.currentState!.validate()) {
      // Simula el envío del código a la base de datos (Backend)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Tarjeta física vinculada exitosamente a tu cuenta!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      // Cierra la pantalla y le avisa al Dashboard que la vinculación fue un éxito (true)
      Navigator.pop(context, true); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vincular Tarjeta Física', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Ícono que representa la tecnología NFC/RFID de las tarjetas
              const Icon(Icons.nfc, size: 100, color: Color(0xFF0D47A1)),
              const SizedBox(height: 20),
              const Text(
                'Conecta tu plástico al sistema',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              const Text(
                'Ingresa el código UID de 8 dígitos que se encuentra impreso en la parte posterior de tu tarjeta inteligente del transporte público.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
              const SizedBox(height: 40),
              // Campo para el UID
              TextFormField(
                controller: _cardController,
                keyboardType: TextInputType.number,
                maxLength: 8, // Limita a 8 números
                decoration: InputDecoration(
                  labelText: 'Código UID de la tarjeta',
                  hintText: 'Ej: 12345678',
                  prefixIcon: const Icon(Icons.credit_card),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Debes ingresar el código';
                  if (value.length < 8) return 'El código debe tener exactamente 8 dígitos';
                  return null;
                },
              ),
              const Spacer(),
              // Botón de confirmación
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _vincularTarjeta,
                  child: const Text('VINCULAR TARJETA', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
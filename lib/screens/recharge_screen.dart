import 'package:flutter/material.dart';

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  // Variable para guardar la tarjeta que seleccionemos
  String? _selectedCard;
  
  // Controlador para atrapar el monto que el usuario escriba
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Nuestra base de datos ficticia de tarjetas
  final List<Map<String, dynamic>> _tarjetas = [
    {'banco': 'BCP', 'tipo': 'Visa', 'terminacion': '4321', 'color': Colors.orange.shade700},
    {'banco': 'BNB', 'tipo': 'Mastercard', 'terminacion': '8765', 'color': Colors.green.shade700},
    {'banco': 'Banco Unión', 'tipo': 'Débito', 'terminacion': '1122', 'color': Colors.blue.shade700},
  ];

  // Esta funcion hace aparecer el menu emergente desde abajo (Igual al de tu foto)
  void _mostrarSelectorTarjetas() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Selecciona una tarjeta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),
              const Divider(),
              // Mapeamos nuestras tarjetas ficticias para crear la lista
              ..._tarjetas.map((tarjeta) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: tarjeta['color'],
                    child: const Icon(Icons.credit_card, color: Colors.white),
                  ),
                  title: Text('${tarjeta['tipo']} - ${tarjeta['banco']}'),
                  subtitle: Text('**** **** **** ${tarjeta['terminacion']}'),
                  onTap: () {
                    // Actualizamos la pantalla con la tarjeta elegida y cerramos el menú
                    setState(() {
                      _selectedCard = '${tarjeta['tipo']} ${tarjeta['banco']} (***${tarjeta['terminacion']})';
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
              // Opcion para agregar una nueva (ficticia por ahora)
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.add, color: Colors.white),
                ),
                title: const Text('Agregar nueva tarjeta', style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Módulo de agregar tarjeta en desarrollo')),
                  );
                },
              )
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recarga tu tarjeta', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tarjeta de origen', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
              const SizedBox(height: 10),
              // El cuadro que al tocarse abre el ModalBottomSheet
              GestureDetector(
                onTap: _mostrarSelectorTarjetas,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade50,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.credit_card, color: _selectedCard == null ? Colors.grey : const Color(0xFF0D47A1)),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          _selectedCard ?? 'Selecciona una tarjeta',
                          style: TextStyle(
                            fontSize: 16,
                            color: _selectedCard == null ? Colors.grey.shade600 : Colors.black87,
                            fontWeight: _selectedCard == null ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text('Datos para la recarga', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
              const SizedBox(height: 10),
              // Input del monto
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Monto a recargar (Bs.)',
                  hintText: 'Ej: 50.00',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Por favor ingresa un monto';
                  if (double.tryParse(value) == null || double.parse(value) <= 0) return 'Monto inválido';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Cajita de información estilo BCP
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue.shade200),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Text(
                        'El monto será debitado de la tarjeta seleccionada y se sumará a tu saldo de transporte de forma inmediata.',
                        style: TextStyle(color: Colors.black87, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Botón de Confirmación
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (_selectedCard == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor selecciona una tarjeta primero'), backgroundColor: Colors.red),
                      );
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      // Si todo está bien, cerramos esta pantalla y "devolvemos" el monto al Dashboard
                      Navigator.pop(context, double.parse(_amountController.text));
                    }
                  },
                  child: const Text('CONFIRMAR RECARGA', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
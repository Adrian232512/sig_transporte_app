import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dashboard_screen.dart';
import 'register_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false; // Control de animación de carga

  void _procesarLogin() async {
    if (_formKey.currentState!.validate()) {
      
      // 1. PUERTA TRASERA (Emergencia para la demostración)
      if (_userController.text == 'admin' && _passwordController.text == '1234') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
        return;
      }

      // 2. CONEXIÓN REAL A MYSQL
      setState(() => _isLoading = true);

      // Usamos tu IP nueva confirmada
      const String ipComputadora = '192.168.1.12'; 
      final Uri url = Uri.parse('http://$ipComputadora:8000/api/login');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
          body: jsonEncode({
            'email': _userController.text,
            'password': _passwordController.text,
          }),
        );

        setState(() => _isLoading = false);

        if (response.statusCode == 200) {
          if (!mounted) return;
          
          // Extraemos los datos del usuario que Laravel nos devolvió
          final data = jsonDecode(response.body);
          final String nombre = data['user']['name'];
          // Dependiendo del motor SQL, un boolean puede llegar como 1 o como true
          final bool esEstudiante = data['user']['is_student'] == 1 || data['user']['is_student'] == true;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sesión iniciada correctamente'), backgroundColor: Colors.green),
          );
          
          // Navegamos al Dashboard enviándole el nombre y su estado de estudiante
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(nombreUsuario: nombre, esEstudiante: esEstudiante),
            ),
          );
        } else {
          // Si Laravel rechaza las credenciales (401)
          final errorData = jsonDecode(response.body);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorData['message'] ?? 'Credenciales incorrectas'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error de red. Verifica la conexión al servidor.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text('IDENTIFÍCATE', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
                const SizedBox(height: 30),
                Container(
                  width: 130, height: 130,
                  decoration: BoxDecoration(color: const Color(0xFF0D47A1).withOpacity(0.1), shape: BoxShape.circle),
                  child: const Center(child: Icon(Icons.lock_person_rounded, size: 70, color: Color(0xFF0D47A1))),
                ),
                const SizedBox(height: 40),
                
                TextFormField(
                  controller: _userController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'Por favor, ingresa tu correo' : null,
                ),
                const SizedBox(height: 20),
                
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_open_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'Por favor, ingresa tu contraseña' : null,
                ),
                const SizedBox(height: 40),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _procesarLogin,
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('INICIAR SESIÓN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 15),
                
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                    },
                    child: const Text('REGÍSTRATE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
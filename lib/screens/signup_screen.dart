import 'package:flutter/material.dart';
import 'package:signup_app/signup_tip_coach.dart';
import 'success_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dateController = TextEditingController();

  bool _obscurePassword = true;
  bool _submitting = false;
  DateTime? _birthDate;
  String? _selectedCreatureType;

  final _coach = const SignupTipCoach();
  bool _tipLoading = false;
  bool _forceTipError = false;
  String _tipText = '';
  String _tipError = '';
  int _tipIndex = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _loadTip() async {
    setState(() {
      _tipLoading = true;
      _tipText = '';
      _tipError = '';
    });

    try {
      final tip = await _coach.loadTip(
        forceError: _forceTipError,
        index: _tipIndex,
        delay: const Duration(milliseconds: 700),
      );

      if (!mounted) return;

      setState(() {
        _tipText = tip;
        _tipIndex++;
        _tipLoading = false;
      });
    } on TipLoadException catch (error) {
      if (!mounted) return;

      setState(() {
        _tipError = error.message;
        _tipLoading = false;
      });
    }
  }

  Future<void> _submit() async {
    if (_submitting) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(
          userName: _nameController.text.trim(),
          creatureType: _selectedCreatureType!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creature Signup'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Register Your Creature',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Creature Type',
                    prefixIcon: Icon(Icons.pets),
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    'Ghost',
                    'Bat',
                    'Black Cat',
                    'Pumpkin Spirit',
                    'Witch',
                  ].map((creature) {
                    return DropdownMenuItem(
                      value: creature,
                      child: Text(creature),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCreatureType = value;
                    });
                  },
                  validator: (value) => value == null
                      ? 'Please select a creature'
                      : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Birth Date',
                    prefixIcon: Icon(Icons.cake),
                    border: OutlineInputBorder(),
                  ),
                  validator: (_) => _birthDate == null
                      ? 'Pick your birth date'
                      : null,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2008),
                      firstDate: DateTime(1920),
                      lastDate: DateTime.now(),
                    );

                    if (picked != null && mounted) {
                      setState(() {
                        _birthDate = picked;
                        _dateController.text =
                            '${picked.month}/${picked.day}/${picked.year}';
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Register Creature',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
                const SizedBox(height: 28),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Signup tip',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                const Text(
                  'This tip is a preset sample. It does not check your form.',
                ),

                SwitchListTile(
                  title: const Text('Make the tip fail'),
                  value: _forceTipError,
                  onChanged: _tipLoading
                      ? null
                      : (value) {
                          setState(() {
                            _forceTipError = value;
                          });
                        },
                ),

                OutlinedButton(
                  onPressed: _tipLoading ? null : _loadTip,
                  child: Text(
                    _tipError.isNotEmpty ? 'Retry' : 'Get a signup tip',
                  ),
                ),

                if (_tipLoading)
                  const CircularProgressIndicator(),

                if (_tipText.isNotEmpty)
                  Text(_tipText),

                if (_tipError.isNotEmpty)
                  Text(
                    _tipError,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
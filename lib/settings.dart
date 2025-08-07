import 'package:flutter/material.dart';
import 'home_screen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _timeDifferentBetweenPlayers = false;
  double _minutesPerPlayer = 4.0;
  double _extraSeconds = 0.0;
  bool _useBronstein = true;
  bool _notificationsSonores = true;
  bool _useSpacebar = true;
  String _keyboardType = 'United States (Qwerty)';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black87,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Chess clock',
                      style: TextStyle(
                        fontFamily: 'Handwritten',
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildSwitchRow(
                    'Time different between players',
                    _timeDifferentBetweenPlayers,
                    (value) =>
                        setState(() => _timeDifferentBetweenPlayers = value),
                    Colors.grey,
                  ),
                  SizedBox(height: 16),
                  _buildTextFieldSection(
                    'Minutes per player',
                    _minutesPerPlayer,
                    (value) => setState(
                      () => _minutesPerPlayer = double.tryParse(value) ?? 4.0,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildTextFieldSection(
                    'Extra seconds',
                    _extraSeconds,
                    (value) => setState(
                      () => _extraSeconds = double.tryParse(value) ?? 0.0,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildDropdownSection(
                    'Timing method',
                    _useBronstein ? 'Bronstein' : 'Simple',
                    ['Bronstein', 'Simple'],
                    (value) =>
                        setState(() => _useBronstein = value == 'Bronstein'),
                  ),
                  SizedBox(height: 16),
                  _buildSwitchRow(
                    'Notifications sonores',
                    _notificationsSonores,
                    (value) => setState(() => _notificationsSonores = value),
                    Colors.blue,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Text(
                      'A sound notification will be emitted when clock is switched from a player to another one, when there is 30 or 10 seconds left and also when game is over.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildSwitchRow(
                    'Use spacebar for clock switch',
                    _useSpacebar,
                    (value) => setState(() => _useSpacebar = value),
                    Colors.blue,
                  ),
                  SizedBox(height: 16),
                  _buildDropdownSection(
                    'Keyboard type',
                    _keyboardType,
                    ['United States (Qwerty)'],
                    (value) => setState(() => _keyboardType = value!),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.brown),
                        backgroundColor: Colors.brown[300],
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.coffee, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Buy a coffee to developer',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Go!',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow(
    String label,
    bool value,
    Function(bool) onChanged,
    Color activeColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
        Switch(value: value, onChanged: onChanged, activeColor: activeColor),
      ],
    );
  }

  Widget _buildTextFieldSection(
    String label,
    double value,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 16)),
        SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          onChanged: onChanged,
          controller: TextEditingController(text: value.toString()),
        ),
      ],
    );
  }

  Widget _buildDropdownSection(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 16)),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black87,
            border: Border.all(color: Colors.white70),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              dropdownColor: Colors.black87,
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ],
    );
  }
}

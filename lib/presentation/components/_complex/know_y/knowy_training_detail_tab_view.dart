import 'package:flutter/material.dart';

class KnowYTrainingTabView extends StatefulWidget {
  const KnowYTrainingTabView({
    super.key,
  });

  @override
  State<KnowYTrainingTabView> createState() => _KnowYTrainingTabViewState();
}

class _KnowYTrainingTabViewState extends State<KnowYTrainingTabView> {

  Color _leftColor = Colors.brown;
  Color _rightColor = Colors.white;
  bool _leftPressed = true;
  String _displayText = "";


  void _handlePress() {
    _toggleColors();
    _setDisplayText();
  }

  void _toggleColors() {
    setState(() {
      Color _temp = _leftColor;
      _leftColor = _rightColor;
      _rightColor = _temp;
    });
  }

  void _toggleLeftPressed() {
    _leftPressed = !_leftPressed;
  }

  void _setDisplayText() {
    setState(() {
      if (_leftPressed) {
        _displayText = "Here's what you'll get";
      }
      else {
        _displayText = "Here's what you'll learn";
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    // NestedTabBarView
    return Column(
      children: [
        // Tab Bar header
        SizedBox(
          height: 65,
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    if (!_leftPressed) {
                      _leftPressed = true;
                      _handlePress();
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            'What You\'ll Get',
                          ),
                        ),
                      ),
                      Container(
                        height: 5,
                        color: _leftColor,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    if (_leftPressed) {
                      _leftPressed = false;
                      _handlePress();
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            'What You\'ll Learn',
                          ),
                        ),
                      ),
                      Container(
                        height: 5,
                        color: _rightColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        /// view content
        Container(
          height: 400,
          color: Colors.grey,
          child: Center(
            child: Text(_displayText),
          ),
        )
      ],
    );
  }
}
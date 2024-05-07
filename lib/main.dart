import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '';
  String _expression = '';

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == '=') {
        try {
          // Evaluate the expression and update the output
          final eval = _evaluateExpression();
          _output = eval.toString();
          _expression = '';
        } catch (e) {
          _output = 'Error';
        }
      } else if (buttonText == 'C') {
        // Clear the output and expression
        _output = '';
        _expression = '';
      } else {
        // Append the button text to the expression
        _expression += buttonText;
        _output = _expression;
      }
    });
  }

  double _evaluateExpression() {
    List<String> tokens = [];
    String currentToken = '';
    for (int i = 0; i < _expression.length; i++) {
      if (_expression[i] == '+' || _expression[i] == '-' || _expression[i] == '*' || _expression[i] == '/') {
        // Add the current token to the list and reset it
        tokens.add(currentToken);
        tokens.add(_expression[i]);
        currentToken = '';
      } else {
        currentToken += _expression[i];
      }
    }

    tokens.add(currentToken);

    double result = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      String operator = tokens[i];
      double operand = double.parse(tokens[i + 1]);
      switch (operator) {
        case '+':
          result += operand;
          break;
        case '-':
          result -= operand;
          break;
        case '*':
          result *= operand;
          break;
        case '/':
          result /= operand;
          break;
        default:
          throw Exception('Invalid operator');
      }
    }
    return result;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _output,
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(height: 20),
            buildButtonRow(['7', '8', '9', '/']),
            buildButtonRow(['4', '5', '6', '*']),
            buildButtonRow(['1', '2', '3', '-']),
            buildButtonRow(['C', '0', '.', '+']),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _onButtonPressed('=');
              },
              child: Text('='),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonRow(List<String> texts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: texts
          .map((text) => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ElevatedButton(
            onPressed: () {
              _onButtonPressed(text);
            },
            child: Text(text),
          ),
        ),
      ))
          .toList(),
    );
  }
}

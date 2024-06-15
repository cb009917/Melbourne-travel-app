import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

class StepCounterWidget extends StatefulWidget {
  const StepCounterWidget({Key? key}) : super(key: key);

  @override
  _StepCounterWidgetState createState() => _StepCounterWidgetState();
}

class _StepCounterWidgetState extends State<StepCounterWidget> {
  double _previousMagnitude = 0.0;
  int _stepCount = 0;
  double _threshold =
      1.2; // Adjust this value to make step detection more sensitive
  double _alpha = 0.8;

  double _lastAccelX = 0.0;
  double _lastAccelY = 0.0;
  double _lastAccelZ = 0.0;

  @override
  void initState() {
    super.initState();

    accelerometerEvents.listen((AccelerometerEvent event) {
      // Apply low-pass filter
      double filteredAccelX = _alpha * _lastAccelX + (1 - _alpha) * event.x;
      double filteredAccelY = _alpha * _lastAccelY + (1 - _alpha) * event.y;
      double filteredAccelZ = _alpha * _lastAccelZ + (1 - _alpha) * event.z;

      // Calculate the magnitude of the acceleration vector
      double magnitude = sqrt(filteredAccelX * filteredAccelX +
          filteredAccelY * filteredAccelY +
          filteredAccelZ * filteredAccelZ);

      // Check if the change in magnitude exceeds the threshold
      if ((magnitude - _previousMagnitude).abs() > _threshold) {
        setState(() {
          _stepCount++;
        });
      }

      _previousMagnitude = magnitude;

      _lastAccelX = event.x;
      _lastAccelY = event.y;
      _lastAccelZ = event.z;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Color(0xFF72C6EF), Color(0xFF004E92)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This Week',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '$_stepCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Steps',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.directions_walk,
                      size: 40,
                      color: Color(0xFF004E92),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

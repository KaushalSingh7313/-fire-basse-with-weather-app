import 'dart:async'; // For Timer
import 'package:compleat_one_project/weather.dart';
import 'package:flutter/material.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txt1 = TextEditingController();
  final TextEditingController txt2 = TextEditingController();
  final TextEditingController txt3 = TextEditingController();
  final TextEditingController txt4 = TextEditingController();
  final TextEditingController txt5 = TextEditingController();
  final TextEditingController txt6 = TextEditingController();
  int _remainingTime = 30; // Timer duration in seconds
  Timer? _timer;
  String _validationMessage = ''; // To hold the validation message

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime == 0) {
        timer.cancel();
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    txt1.dispose();
    txt2.dispose();
    txt3.dispose();
    txt4.dispose();
    txt5.dispose();
    txt6.dispose();
    super.dispose();
  }

  Widget myInputBox(TextEditingController controller) {
    return SizedBox(
      height: 45,
      width: 40,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'OTP';
          }
          return null;
        },
      ),
    );
  }

  void _onVerifyOtp() {
    if (_formKey.currentState?.validate() ?? false) {
      final otp = '${txt1.text}${txt2.text}${txt3.text}${txt4.text}${txt5.text}${txt6.text}';
      if (otp.length == 6) {
        if (otp == '123456') { // Replace with actual OTP verification logic
          Navigator.pushNamed(context, '/nextScreen'); // Adjust route as needed
        } else {
          setState(() {
            _validationMessage = 'Invalid OTP';
          });
        }
      } else {
        setState(() {
          _validationMessage = 'Please enter all OTP digits';
        });
      }
    } else {
      setState(() {
        _validationMessage = 'Please enter the code';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back,color: Colors.white,),
        title: const Text('OTP Verification',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/image1.png', height: 150), // Add an image to assets folder,
              SizedBox(height: 15,),
              Text(
                'Enter the OTP sent to your phone',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  myInputBox(txt1),
                  myInputBox(txt2),
                  myInputBox(txt3),
                  myInputBox(txt4),
                  myInputBox(txt5),
                  myInputBox(txt6),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Resend code in $_remainingTime seconds',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _onVerifyOtp,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.deepPurple, backgroundColor: Colors.white,
                ),
                child: const Text('Verify OTP'),
              ),
              const SizedBox(height: 20),
              if (_validationMessage.isNotEmpty)
                Text(
                  _validationMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ElevatedButton(
                  onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherScreen(),));
                  },
                  child: Text('Random OTP')),
            ],
          ),
        ),
      ),
    );
  }
}

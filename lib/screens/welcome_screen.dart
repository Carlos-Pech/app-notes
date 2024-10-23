import 'package:flutter/material.dart';
import 'package:flutter_app/screens/notes_screen.dart';
import 'package:flutter_app/widgets/data_info.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double size = constraints.maxWidth * 0.8;
                    return SizedBox(
                      width: size,
                      height: size,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: SvgPicture.asset(
                          "assets/images/welcome.svg",
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    );
                  },
                ),
              ),
              DataInfo(
                title: "Hola Bienvenido",
                description: "Agrega tus notas",
                // button: you can pass your custom button,
                btnText: "Comenzar",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const NotesScreen(),
                    ),
                  );
                  // CreateBookDialog().show(context: context);
                },
              ),
              // const Spacer(flex: 2), // Puedes descomentar esto si necesitas espacio adicional
            ],
          ),
        ),
      ),
    );
  }
}

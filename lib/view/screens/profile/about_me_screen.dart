import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/model/constance/color_constant.dart';

import '../../../model/constance/constant.dart';
import '../authentications/login_screen.dart';

class AboutMeScreen extends ConsumerStatefulWidget {
  const AboutMeScreen({super.key});
  static const id = "/aboutMe";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends ConsumerState<AboutMeScreen> {
  late TextEditingController _controller;
  final GlobalKey<FormState> _form = GlobalKey();

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "About Me",
          style: TextStyle(
            color: KColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: KColors.black,
            )),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            AppConstants.screenBackgroundColor(),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      height: size.height * 0.3,
                      width: size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: KColors.secondaryColor,
                          )),
                      child: TextFormField(
                        controller: _controller,
                        expands: true,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        autofocus: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          } else {
                            return "Please";
                          }
                        },
                      ),
                    ),
                    AppConstants.getSpace(size.height * 0.1),
                    CustomAuthButton(
                        size: size,
                        text: "Save",
                        onPressed: () {
                          if (_form.currentState!.validate()) {}
                        })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

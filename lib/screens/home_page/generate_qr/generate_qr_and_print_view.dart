import 'dart:io';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:excel_facility/excel_facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:euro_scanner/screens/home_page/home_page_logic.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/app_managers/color_manager.dart';
import '../../../core/helper/input_validator.dart';
import '../../../widgets/arrow_clip.dart';
import 'package:pdf/pdf.dart';

class GenerateQRAndPrintPage extends StatefulWidget {
  const GenerateQRAndPrintPage({super.key});

  @override
  State<GenerateQRAndPrintPage> createState() =>
      _GGenerateQRAndPrintPageState();
}

class _GGenerateQRAndPrintPageState extends State<GenerateQRAndPrintPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageLogic>(
      builder: (logic) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(32),
            ClipPath(
              clipper: ArrowClipReversed(8),
              child: Container(
                color: Colors.red,
                child: const Padding(
                  padding:
                      EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 20),
                  child: Text(
                    "generate QR",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: _buildDropDownFormField(
                      hintText: "Coupon type",
                      // maxLength: 10,
                      inputType: TextInputType.text,
                      mainController: logic,
                      onChanged: () {
                        setState(() {});
                      },
                      controller: logic.typeController),
                ),
                const Gap(12),
                Expanded(
                    child: _buildPassEmailFormField(
                  controller: logic.couponValueController,
                  inputType: TextInputType.number,
                  maxLength: 4,
                  hintText: "Coupon value",
                  mainController: logic,
                )),
                const Gap(12),
                Expanded(
                    child: _buildPassEmailFormField(
                  maxLength: 4,
                  inputType: TextInputType.text,
                  controller: logic.productCodeController,
                  hintText: "Product Code",
                  mainController: logic,
                )),
                const Gap(12),
                Expanded(
                  child: _buildDropDownFormField(
                      hintText: "Bucket size",
                      // maxLength: 10,
                      inputType: TextInputType.text,
                      mainController: logic,
                      onChanged: () {
                        setState(() {});
                      },
                      controller: logic.qtyController),
                ),
                const Gap(12),
                Expanded(
                    child: _buildPassEmailFormField(
                  maxLength: 5,
                  controller: logic.fromController,
                  inputType: TextInputType.number,
                  hintText: "From",
                  mainController: logic,
                )),
                const Gap(12),
                Expanded(
                    child: _buildPassEmailFormField(
                  maxLength: 5,
                  controller: logic.toController,
                  inputType: TextInputType.number,
                  hintText: "To",
                  mainController: logic,
                )),
                const Gap(12),
                FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.green.shade700),
                    onPressed: () async {
                      logic.generateTempQr();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(children: [
                        Text("Generate"),
                        // const PdfPageFormat(76.2 * PdfPageFormat.mm, 50 * PdfPageFormat.mm),
                      ]),
                    )),
                const Gap(32),
              ],
            ),
            Gap(12),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Valid QR",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: logic.validQr.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    "${logic.validQr[index]}",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(8),
                  VerticalDivider(),
                  Gap(8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Duplicate QR",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: logic.invalidQr.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    "${logic.invalidQr[index]}",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(32),
                ],
              ),
            ),
            const Gap(32),
            Row(
              children: [
                FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.red.shade700),
                    onPressed: () async {
                      // logic.generateTempQr();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(children: [
                        Icon(Icons.save_outlined),
                        Gap(12),
                        Text("Save"),
                        // const PdfPageFormat(76.2 * PdfPageFormat.mm, 50 * PdfPageFormat.mm),
                      ]),
                    )),
                const Gap(12),
                FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue.shade700),
                    onPressed: () async {
                      logic.saveAndPrintGeneratedQr();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(children: [
                        Icon(Icons.print_outlined),
                        Gap(12),
                        Text("Save and print"),
                        // const PdfPageFormat(76.2 * PdfPageFormat.mm, 50 * PdfPageFormat.mm),
                      ]),
                    )),

              ],
            ),
            const Gap(12),
          ],
        );
      },
    );
  }

  Widget _buildPassEmailFormField({
    TextEditingController? controller,
    TextInputType? inputType,
    FocusNode? focusNode,
    int? maxLength,
    String? hintText,
    VoidCallback? onChanged,
    required HomePageLogic mainController,
  }) {
    return TextFormField(
        inputFormatters: inputType == TextInputType.number
            ? <TextInputFormatter>[
                // for below version 2 use this
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                FilteringTextInputFormatter.digitsOnly
              ]
            : null,
        controller: controller,
        onChanged: (a) {
          onChanged!();
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: inputType ?? TextInputType.emailAddress,
        validator: (String? value) {
          return null;
        },
        maxLength: maxLength ?? 36,
        focusNode: focusNode,
        // obscureText: controller == mainController.passwordController ||controller == mainController.newPasswordController ||controller == mainController.confirmPasswordController||controller == mainController.confirmNewPasswordController,
        decoration: InputDecoration(
          fillColor: ColorManager.white,
          filled: true,
          label: Text(hintText ?? ""),
          counterText: '',
          contentPadding: const EdgeInsets.all(16),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorManager.textDark,
              ),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(10)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorManager.errorOpacity50,
              ),
              borderRadius: BorderRadius.circular(10)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorManager.errorOpacity50,
              ),
              borderRadius: BorderRadius.circular(10)),
          hintText: hintText ?? "",
          hintStyle: TextStyle(
            color: ColorManager.hintColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        onFieldSubmitted: (String val) {});
  }
}

Widget _buildDropDownFormField({
  SingleValueDropDownController? controller,
  TextInputType? inputType,
  FocusNode? focusNode,
  String? hintText,
  VoidCallback? onChanged,
  required HomePageLogic mainController,
}) {
  return DropDownTextField(
    controller: controller,
    onChanged: (a) {
      onChanged!();
    },
    autovalidateMode: AutovalidateMode.onUserInteraction,
    keyboardType: inputType ?? TextInputType.emailAddress,
    validator: (String? value) {
      return InputValidators.simpleValidation(value);
    },
    // maxLength: maxLength ?? 36,
    textFieldFocusNode: focusNode,
    // obscureText: controller == mainController.passwordController ||controller == mainController.newPasswordController ||controller == mainController.confirmPasswordController||controller == mainController.confirmNewPasswordController,
    textFieldDecoration: InputDecoration(
      fillColor: ColorManager.white,
      filled: true,
      label: Text(hintText ?? ""),
      counterText: '',
      contentPadding: const EdgeInsets.all(16),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorManager.textDark,
          ),
          borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(10)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorManager.errorOpacity50,
          ),
          borderRadius: BorderRadius.circular(10)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorManager.errorOpacity50,
          ),
          borderRadius: BorderRadius.circular(10)),
      hintText: hintText ?? "",
      hintStyle: TextStyle(
        color: ColorManager.hintColor,
        fontWeight: FontWeight.w500,
      ),
    ),
    dropDownList: hintText!.toLowerCase().contains("type")
        ? mainController.types
        : hintText.toLowerCase().contains("size")
            ? mainController.qty
            : [],
  );
}

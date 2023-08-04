// ignore_for_file: must_be_immutable
import 'package:cinepass_owner/utils/colors.dart';
import 'package:cinepass_owner/view_models/signin_screen_bloc/login_screen_bloc.dart';
import 'package:field_suggestion/field_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../view_models/manage_movies_bloc/manage_movies_bloc.dart';

class CinePassTextFormField extends StatelessWidget {
  final String hint;
  final Icon? prefixIcon;
  final String fieldName;
  final bool? isDigitsOnly;
  final int? limit;
  final bool? isLast;
  final Function()? function;
  final TextEditingController controller;

  const CinePassTextFormField(
      {super.key,
      required this.hint,
      this.prefixIcon,
      required this.fieldName,
      this.isDigitsOnly,
      this.limit,
      this.isLast,
      this.function,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    TextInputType textInputType;
    if (function == null) {
      if (isDigitsOnly == true) {
        textInputType = TextInputType.number;
      } else {
        textInputType = TextInputType.text;
      }
    } else {
      textInputType = TextInputType.none;
    }
    return TextFormField(
      controller: controller,
      maxLines: 1,
      onTap: function,
      validator: (value) {
        if (value!.isEmpty) {
          return '$fieldName Field is Empty';
        }
        return null;
      },
      inputFormatters: [LengthLimitingTextInputFormatter(limit)],
      keyboardType: textInputType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: Adaptive.h(2)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: Adaptive.w(2), right: Adaptive.w(1)),
            child: prefixIcon,
          ),
          prefixIconColor: primaryColor,
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(color: textFormFieldColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(color: textFormFieldColor)),
          filled: true,
          fillColor: textFormFieldColor,
          hintStyle: TextStyle(color: hintColor)),
      style: const TextStyle(color: Colors.white),
      textInputAction: isLast == true ? null : TextInputAction.next,
    );
  }
}

class CinePassPasswordTextFormField extends StatelessWidget {
  final String hint;
  final Icon? prefixIcon;
  final TextEditingController passwordController;

  const CinePassPasswordTextFormField(
      {super.key,
      required this.hint,
      this.prefixIcon,
      required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginScreenBloc, LoginScreenState>(
      buildWhen: (previous, current) => current is ObscureValueChangedState,
      builder: (context, state) {
        final successState = state as ObscureValueChangedState;
        return TextFormField(
          controller: passwordController,
          maxLines: 1,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Password Field is Empty';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: successState.obscureValue,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: Adaptive.h(2)),
              prefixIcon: Padding(
                padding:
                    EdgeInsets.only(left: Adaptive.w(2), right: Adaptive.w(1)),
                child: prefixIcon,
              ),
              prefixIconColor: primaryColor,
              hintText: hint,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: textFormFieldColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: textFormFieldColor)),
              filled: true,
              fillColor: textFormFieldColor,
              hintStyle: TextStyle(color: hintColor),
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: Adaptive.w(1.5)),
                child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      BlocProvider.of<LoginScreenBloc>(context).add(
                          ObscureValueChangedEvenet(
                              currentValue: successState.obscureValue));
                    },
                    child: successState.obscureValue
                        ? Icon(
                            Icons.visibility,
                            color: hintColor,
                            size: 23,
                          )
                        : Icon(
                            Icons.visibility_off,
                            color: hintColor,
                            size: 23,
                          )),
              )),
          style: const TextStyle(color: Colors.white),
        );
      },
    );
  }
}

class CinePassTextFormFieldWithDropDown extends StatelessWidget {
  final List<String> items;
  final String hint;
  final String fieldName;
  final Icon? prefixIcon;
  final bool? isLast;
  final String? presetValue;
  final Function()? function;
  final TextEditingController controller;

  const CinePassTextFormFieldWithDropDown(
      {super.key,
      required this.items,
      required this.hint,
      required this.fieldName,
      required this.prefixIcon,
      this.presetValue,
      required this.isLast,
      this.function,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: Adaptive.h(2)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: Adaptive.w(2), right: Adaptive.w(1)),
            child: prefixIcon,
          ),
          prefixIconColor: primaryColor,
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(color: textFormFieldColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(color: textFormFieldColor)),
          filled: true,
          suffixIcon: DropdownButtonFormField(
            borderRadius: BorderRadius.circular(10),
            padding:
                EdgeInsets.only(left: Adaptive.w(13), right: Adaptive.w(3)),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(color: hintColor)),
            style: const TextStyle(color: Colors.white, fontSize: 16),
            value: presetValue,
            onChanged: (newValue) {
              controller.text = newValue.toString();
            },
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          fillColor: textFormFieldColor,
          hintStyle: TextStyle(color: hintColor)),
      style: const TextStyle(color: Colors.white),
      textInputAction: isLast == true ? null : TextInputAction.next,
    );
  }
}

class CinePassAutoFillTextFormField extends StatelessWidget {
  final String hint;
  final Icon? prefixIcon;
  final String fieldName;
  final bool? isDigitsOnly;
  final bool? isLast;
  List<String> allItemsList;
  final TextEditingController controller;

  CinePassAutoFillTextFormField(
      {super.key,
      required this.hint,
      this.prefixIcon,
      required this.fieldName,
      this.isDigitsOnly,
      this.isLast,
      required this.allItemsList,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    final boxController = BoxController();
    return BlocBuilder<ManageMoviesBloc, ManageMoviesState>(
      builder: (context, state) {
        if (state is AllMoviesNamesGotState) {
          allItemsList = [...state.allMoviesList];
        }
        return FieldSuggestion(
          boxStyle: BoxStyle(
              borderRadius: BorderRadius.circular(8),
              backgroundColor: const Color.fromRGBO(105, 109, 116, 1)),
          inputStyle: const TextStyle(color: Colors.white),
          boxController: boxController,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                controller.text = allItemsList[index];

                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length),
                );
              },
              child: Column(
                children: [
                  Text(
                    allItemsList[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Divider()
                ],
              ),
            );
          },
          textController: controller,
          suggestions: allItemsList,
          search: (item, input) {
            if (item == input) return false;

            return item.toString().toLowerCase().contains(input.toLowerCase());
          },
          maxLines: 1,
          validator: (value) {
            if (value!.isEmpty) {
              return '$fieldName Field is Empty';
            }
            return null;
          },
          inputDecoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                  top: Adaptive.h(2),
                  bottom: Adaptive.h(2),
                  right: Adaptive.w(3)),
              prefixIcon: Padding(
                padding:
                    EdgeInsets.only(left: Adaptive.w(2), right: Adaptive.w(1)),
                child: prefixIcon,
              ),
              prefixIconColor: primaryColor,
              hintText: hint,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: textFormFieldColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: textFormFieldColor)),
              filled: true,
              fillColor: textFormFieldColor,
              hintStyle: TextStyle(color: hintColor)),
        );
      },
    );
  }
}

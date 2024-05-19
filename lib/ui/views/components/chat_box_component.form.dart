// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String QueryInputValueKey = 'queryInput';

final Map<String, TextEditingController>
    _ChatBoxComponentTextEditingControllers = {};

final Map<String, FocusNode> _ChatBoxComponentFocusNodes = {};

final Map<String, String? Function(String?)?> _ChatBoxComponentTextValidations =
    {
  QueryInputValueKey: null,
};

mixin $ChatBoxComponent {
  TextEditingController get queryInputController =>
      _getFormTextEditingController(QueryInputValueKey);

  FocusNode get queryInputFocusNode => _getFormFocusNode(QueryInputValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_ChatBoxComponentTextEditingControllers.containsKey(key)) {
      return _ChatBoxComponentTextEditingControllers[key]!;
    }

    _ChatBoxComponentTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _ChatBoxComponentTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_ChatBoxComponentFocusNodes.containsKey(key)) {
      return _ChatBoxComponentFocusNodes[key]!;
    }
    _ChatBoxComponentFocusNodes[key] = FocusNode();
    return _ChatBoxComponentFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    queryInputController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    queryInputController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          QueryInputValueKey: queryInputController.text,
        }),
    );

    if (_autoTextFieldValidation || forceValidate) {
      updateValidationData(model);
    }
  }

  bool validateFormFields(FormViewModel model) {
    _updateFormData(model, forceValidate: true);
    return model.isFormValid;
  }

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    for (var controller in _ChatBoxComponentTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _ChatBoxComponentFocusNodes.values) {
      focusNode.dispose();
    }

    _ChatBoxComponentTextEditingControllers.clear();
    _ChatBoxComponentFocusNodes.clear();
  }
}

extension ValueProperties on FormStateHelper {
  bool get hasAnyValidationMessage => this
      .fieldsValidationMessages
      .values
      .any((validation) => validation != null);

  bool get isFormValid {
    if (!_autoTextFieldValidation) this.validateForm();

    return !hasAnyValidationMessage;
  }

  String? get queryInputValue =>
      this.formValueMap[QueryInputValueKey] as String?;

  set queryInputValue(String? value) {
    this.setData(
      this.formValueMap..addAll({QueryInputValueKey: value}),
    );

    if (_ChatBoxComponentTextEditingControllers.containsKey(
        QueryInputValueKey)) {
      _ChatBoxComponentTextEditingControllers[QueryInputValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasQueryInput =>
      this.formValueMap.containsKey(QueryInputValueKey) &&
      (queryInputValue?.isNotEmpty ?? false);

  bool get hasQueryInputValidationMessage =>
      this.fieldsValidationMessages[QueryInputValueKey]?.isNotEmpty ?? false;

  String? get queryInputValidationMessage =>
      this.fieldsValidationMessages[QueryInputValueKey];
}

extension Methods on FormStateHelper {
  setQueryInputValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[QueryInputValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    queryInputValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      QueryInputValueKey: getValidationMessage(QueryInputValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _ChatBoxComponentTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _ChatBoxComponentTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      QueryInputValueKey: getValidationMessage(QueryInputValueKey),
    });

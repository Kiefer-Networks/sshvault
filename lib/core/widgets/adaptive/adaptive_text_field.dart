import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/utils/platform_utils.dart';

/// A platform-adaptive text field.
///
/// On iOS/macOS: [CupertinoTextField] with matching styling.
/// On Android/Desktop: [TextFormField] with Material styling.
class AdaptiveTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? placeholder;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool readOnly;
  final bool autofocus;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;

  const AdaptiveTextField({
    super.key,
    this.controller,
    this.labelText,
    this.placeholder,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.autofocus = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    if (useCupertinoDesign) {
      return _buildCupertino(context);
    }
    return _buildMaterial(context);
  }

  Widget _buildCupertino(BuildContext context) {
    final effectivePlaceholder = placeholder ?? labelText ?? hintText;

    // Wrap with FormField if validator is provided
    if (validator != null) {
      return FormField<String>(
        initialValue: controller?.text ?? '',
        validator: validator,
        builder: (field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoTextField(
                controller: controller,
                placeholder: effectivePlaceholder,
                prefix: prefixIcon != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: prefixIcon,
                      )
                    : null,
                suffix: suffixIcon != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: suffixIcon,
                      )
                    : null,
                obscureText: obscureText,
                readOnly: readOnly,
                autofocus: autofocus,
                enabled: enabled,
                maxLines: maxLines,
                minLines: minLines,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                onChanged: (v) {
                  field.didChange(v);
                  onChanged?.call(v);
                },
                onSubmitted: onSubmitted,
                onTap: onTap,
                focusNode: focusNode,
                textCapitalization: textCapitalization,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: CupertinoDynamicColor.resolve(
                    CupertinoColors.tertiarySystemFill,
                    context,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Text(
                    field.errorText!,
                    style: const TextStyle(
                      color: CupertinoColors.destructiveRed,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          );
        },
      );
    }

    return CupertinoTextField(
      controller: controller,
      placeholder: effectivePlaceholder,
      prefix: prefixIcon != null
          ? Padding(padding: const EdgeInsets.only(left: 8), child: prefixIcon)
          : null,
      suffix: suffixIcon != null
          ? Padding(padding: const EdgeInsets.only(right: 8), child: suffixIcon)
          : null,
      obscureText: obscureText,
      readOnly: readOnly,
      autofocus: autofocus,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      focusNode: focusNode,
      textCapitalization: textCapitalization,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: CupertinoDynamicColor.resolve(
          CupertinoColors.tertiarySystemFill,
          context,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildMaterial(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText ?? placeholder,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText,
      readOnly: readOnly,
      autofocus: autofocus,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      focusNode: focusNode,
      textCapitalization: textCapitalization,
    );
  }
}

library reactive_image_picker;

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

export 'package:image_picker/image_picker.dart';

typedef Widget ImageViewBuilder(Uint8List image);

typedef Widget InputButtonBuilder(VoidCallback onPressed);

typedef void ErrorPickBuilder(ImageSource source, {BuildContext context});

typedef void DeleteDialogBuilder(BuildContext context, VoidCallback onConfirm);

typedef void PopupDialogBuilder(
  BuildContext context,
  ImagePickCallback pickImage,
);

typedef Future<Uint8List> OnBeforeChangeCallback(
    BuildContext context, Uint8List image);

enum ImagePickerMode { image, video, multiImage }

typedef void ImagePickCallback(BuildContext context, ImageSource source);

/// A [ReactiveImagePicker] that contains a [DropdownSearch].
///
/// This is a convenience widget that wraps a [DropdownSearch] widget in a
/// [ReactiveImagePicker].
///
/// A [ReactiveForm] ancestor is required.
///
class ReactiveImagePicker extends ReactiveFormField<Uint8List, Uint8List> {
  /// Creates a [ReactiveImagePicker] that contains a [DropdownSearch].
  ///
  /// Can optionally provide a [formControl] to bind this widget to a control.
  ///
  /// Can optionally provide a [formControlName] to bind this ReactiveFormField
  /// to a [FormControl].
  ///
  /// Must provide one of the arguments [formControl] or a [formControlName],
  /// but not both at the same time.
  ///
  /// Can optionally provide a [validationMessages] argument to customize a
  /// message for different kinds of validation errors.
  ///
  /// Can optionally provide a [valueAccessor] to set a custom value accessors.
  /// See [ControlValueAccessor].
  ///
  /// Can optionally provide a [showErrors] function to customize when to show
  /// validation messages. Reactive Widgets make validation messages visible
  /// when the control is INVALID and TOUCHED, this behavior can be customized
  /// in the [showErrors] function.
  ///
  /// ### Example:
  /// Binds a text field.
  /// ```
  /// final form = fb.group({'email': Validators.required});
  ///
  /// ReactiveUpload(
  ///   formControlName: 'image',
  /// ),
  ///
  /// ```
  ///
  /// Binds a text field directly with a *FormControl*.
  /// ```
  /// final form = fb.group({'image': Validators.required});
  ///
  /// ReactiveUpload(
  ///   formControl: form.control('image'),
  /// ),
  ///
  /// ```
  ///
  /// Customize validation messages
  /// ```dart
  /// ReactiveUpload(
  ///   formControlName: 'image',
  ///   validationMessages: {
  ///     ValidationMessage.required: 'The image must not be empty',
  ///   }
  /// ),
  /// ```
  ///
  /// Customize when to show up validation messages.
  /// ```dart
  /// ReactiveUpload(
  ///   formControlName: 'image',
  ///   showErrors: (control) => control.invalid && control.touched && control.dirty,
  /// ),
  /// ```
  ///
  /// For documentation about the various parameters, see the [ImagePicker] class
  /// and [new ImagePicker], the constructor.
  ReactiveImagePicker({
    Key? key,
    String? formControlName,
    FormControl<Uint8List>? formControl,
    ValidationMessagesFunction<Uint8List>? validationMessages,
    ControlValueAccessor<Uint8List, Uint8List>? valueAccessor,
    ShowErrorsFunction? showErrors,
    InputDecoration? decoration,
    InputButtonBuilder? inputBuilder,
    ImageViewBuilder? imageViewBuilder,
    DeleteDialogBuilder? deleteDialogBuilder,
    ErrorPickBuilder? errorPickBuilder,
    PopupDialogBuilder? popupDialogBuilder,
    BoxDecoration? imageContainerDecoration,
    OnBeforeChangeCallback? onBeforeChange,
    Widget? editIcon,
    Widget? deleteIcon,
    bool enabled = true,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    Duration? maxDuration,
  }) : super(
          key: key,
          formControl: formControl,
          formControlName: formControlName,
          valueAccessor: valueAccessor,
          showErrors: showErrors,
          validationMessages: (control) {
            final error = validationMessages?.call(control) ?? {};

            if (error.containsKey(ImageSource.camera.toString()) != true) {
              error.addEntries([
                MapEntry(ImageSource.camera.toString(),
                    'Error while taking image from camera')
              ]);
            }

            if (error.containsKey(ImageSource.gallery.toString()) != true) {
              error.addEntries([
                MapEntry(ImageSource.gallery.toString(),
                    'Error while taking image from gallery')
              ]);
            }

            return error;
          },
          builder: (field) {
            final InputDecoration effectiveDecoration = (decoration ??
                    const InputDecoration())
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);

            return Listener(
              onPointerDown: (_) => field.control.markAsTouched(),
              child: ImagePickerWidget(
                imageViewBuilder: imageViewBuilder,
                popupDialogBuilder: popupDialogBuilder,
                onBeforeChange: onBeforeChange,
                errorPickBuilder: errorPickBuilder ??
                    (source, {BuildContext? context}) {
                      if (source == ImageSource.camera) {
                        field.control.setErrors(<String, Object>{
                          ImageSource.camera.toString(): true,
                        });
                      }

                      if (source == ImageSource.gallery) {
                        field.control.setErrors(<String, Object>{
                          ImageSource.gallery.toString(): true,
                        });
                      }
                    },
                valueChanged: (Uint8List image) {},
                inputBuilder: inputBuilder,
                imageContainerDecoration: imageContainerDecoration,
                deleteDialogBuilder: deleteDialogBuilder,
                editIcon: editIcon,
                deleteIcon: deleteIcon,
                decoration:
                    effectiveDecoration.copyWith(errorText: field.errorText),
                onChanged: field.didChange,
                value: field.value ?? Uint8List(0),
                maxHeight: maxHeight,
                maxWidth: maxWidth,
                imageQuality: imageQuality,
                preferredCameraDevice: preferredCameraDevice,
                maxDuration: maxDuration,
              ),
            );
          },
        );
}

class ImagePickerWidget extends StatelessWidget {
  final InputDecoration decoration;
  final OnBeforeChangeCallback? onBeforeChange;
  final BoxDecoration? imageContainerDecoration;
  final Widget? editIcon;
  final Widget? deleteIcon;
  final InputButtonBuilder? inputBuilder;
  final ImageViewBuilder? imageViewBuilder;
  final DeleteDialogBuilder? deleteDialogBuilder;
  final ErrorPickBuilder? errorPickBuilder;
  final PopupDialogBuilder? popupDialogBuilder;
  final Uint8List value;
  final bool enabled;
  final double? maxWidth;
  final double? maxHeight;
  final int? imageQuality;
  final CameraDevice preferredCameraDevice;
  final ValueChanged<Uint8List?> onChanged;
  final Duration? maxDuration;
  final Function(Uint8List) valueChanged;

  // final ImagePickerMode mode;

  const ImagePickerWidget({
    Key? key,
    required this.value,
    this.enabled = true,
    required this.onChanged,
    required this.decoration,
    this.imageViewBuilder,
    this.inputBuilder,
    this.imageContainerDecoration,
    this.editIcon,
    this.deleteIcon,
    this.deleteDialogBuilder,
    this.errorPickBuilder,
    this.popupDialogBuilder,
    this.onBeforeChange,
    this.maxWidth,
    this.maxHeight,
    this.imageQuality,
    this.preferredCameraDevice = CameraDevice.rear,
    this.maxDuration,
    required this.valueChanged,
  }) : super(key: key);

  void _onImageButtonPressed(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        imageQuality: imageQuality,
        preferredCameraDevice: preferredCameraDevice,
      );

      if (pickedFile != null) {
        final newVal = await pickedFile.readAsBytes();

        onChanged(await onBeforeChange?.call(context, newVal) ??
            await _onBeforeChange(newVal));
      }
    } catch (e) {
      errorPickBuilder?.call(source, context: context);
    }
  }

  Future<Uint8List> _onBeforeChange(Uint8List image) => Future.value(image);

  void _buildPopupMenu(BuildContext context) {
    if (popupDialogBuilder != null) {
      popupDialogBuilder?.call(context, _onImageButtonPressed);
      return;
    }

    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (context) => Row(
        children: <Widget>[
          Expanded(
              flex: 3,
              child: Container(
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.photo_camera),
                        title: const Text('Take photo'),
                        onTap: () {
                          Navigator.of(context).pop();
                          _onImageButtonPressed(
                            context,
                            ImageSource.camera,
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo),
                        title: const Text('Choose from library'),
                        onTap: () {
                          Navigator.of(context).pop();
                          _onImageButtonPressed(
                            context,
                            ImageSource.gallery,
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.clear),
                        title: const Text('Cancel'),
                        onTap: Navigator.of(context).pop,
                      )
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  void _handleDelete(BuildContext context) {
    final onConfirm = () => onChanged(null);

    if (deleteDialogBuilder != null) {
      deleteDialogBuilder?.call(context, onConfirm);
      return;
    }

    onConfirm();

    // showDialog<void>(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text("Delete image"),
    //       content: Text("This action could not be undone"),
    //       actions: [
    //         TextButton(
    //           child: Text("CLOSE"),
    //           onPressed: () => Navigator.of(context).pop(),
    //         ),
    //         TextButton(
    //           child: Text("CONFIRM"),
    //           onPressed: () {
    //             onConfirm();
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  Widget _buildImage(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: imageContainerDecoration ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          imageViewBuilder?.call(value) ??
              Container(
                height: 250,
                child: _ImageView(image: value),
              ),
          if (enabled)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  onPressed: () => _buildPopupMenu(context),
                  icon: editIcon ?? Icon(Icons.edit),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: () => _handleDelete(context),
                  icon: deleteIcon ?? Icon(Icons.delete),
                )
              ],
            )
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _buildPopupMenu(context),
      icon: Icon(Icons.add, color: Color(0xFF00A7E1)),
      label: Text('Pick image'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: decoration,
      child: value.isNotEmpty == true
          ? _buildImage(context)
          : inputBuilder?.call(() => _buildPopupMenu(context)) ??
              _buildInput(context),
    );
  }
}

class _ImageView extends StatelessWidget {
  final Uint8List? image;

  const _ImageView({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (image?.isNotEmpty ?? false) {
      return Image.memory(image!, fit: BoxFit.cover);
    }

    return Container();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';

class DescriptionEditor extends StatelessWidget {
  const DescriptionEditor({
    super.key,
    required QuillController editorController,
    required ScrollController scrollController,
    required this.focusNode,
  })  : _editorController = editorController,
        _scrollController = scrollController;
  final FocusNode focusNode;
  final QuillController _editorController;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    CTheme themeMode = getThemeMode(context);
    return DefaultTextStyle(
      style: TextStyle(color: themeMode.primTextColor),
      child: Column(
        children: [
          QuillEditor(
            controller: _editorController,
            scrollController: _scrollController,
            focusNode: focusNode,
            configurations: const QuillEditorConfigurations(
              scrollable: true,
              autoFocus: false,
              expands: false,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          QuillToolbar.simple(
            controller: _editorController,
            configurations: QuillSimpleToolbarConfigurations(
              multiRowsDisplay: true,
              showBackgroundColorButton: true,
              showUndo: true,
              showRedo: true,
              showListNumbers: true,
              showCodeBlock: true,
              showQuote: true,
              showDirection: true,
              showSearchButton: false,
              showFontSize: true,
              dialogTheme: QuillDialogTheme(
                  labelTextStyle: TextStyle(color: themeMode.primTextColor),
                  buttonTextStyle: TextStyle(color: themeMode.primTextColor),
                  buttonStyle: ButtonStyle(
                      textStyle: WidgetStateProperty.resolveWith(
                          (_) => TextStyle(color: themeMode.primTextColor)))),
              buttonOptions: QuillSimpleToolbarButtonOptions(
                base: QuillToolbarBaseButtonOptions(
                  iconTheme: QuillIconTheme(
                    iconButtonSelectedData:
                        IconButtonData(color: themeMode.primTextColor),
                    iconButtonUnselectedData:
                        IconButtonData(color: themeMode.primTextColor),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

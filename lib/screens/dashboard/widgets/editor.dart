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
          Expanded(
            child: QuillEditor(
              controller: _editorController,
              scrollController: _scrollController,
              focusNode: focusNode,
              configurations: const QuillEditorConfigurations(
                scrollable: true,
                autoFocus: false,
                expands: false,
                padding: EdgeInsets.only(top: 10),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class ToolBar extends StatelessWidget {
  final QuillController editorController;
  final CTheme themeMode;
  const ToolBar(
      {super.key, required this.editorController, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return QuillToolbar.simple(
      controller: editorController,
      configurations: QuillSimpleToolbarConfigurations(
        multiRowsDisplay: true,
        showBackgroundColorButton: true,
        showUndo: true,
        showRedo: true,
        showListNumbers: true,
        showCodeBlock: false,
        showQuote: true,
        showDirection: true,
        showSearchButton: false,
        showFontSize: true,
        showFontFamily: false,
        showHeaderStyle: false,
        dialogTheme: QuillDialogTheme(
            labelTextStyle: TextStyle(color: themeMode.primTextColor),
            buttonTextStyle: TextStyle(color: themeMode.primTextColor),
            buttonStyle: ButtonStyle(
                textStyle: WidgetStateProperty.resolveWith(
                    (_) => TextStyle(color: themeMode.primTextColor)))),
        buttonOptions: QuillSimpleToolbarButtonOptions(
          fontSize: QuillToolbarFontSizeButtonOptions(
              style: TextStyle(color: themeMode.primTextColor)),
          base: QuillToolbarBaseButtonOptions(
            iconTheme: QuillIconTheme(
              iconButtonSelectedData: IconButtonData(
                  color: themeMode.iconColor,
                  style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.resolveWith(
                          (_) => themeMode.primTextColor))),
              iconButtonUnselectedData: IconButtonData(
                color: themeMode.primTextColor,
                style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.resolveWith(
                        (_) => themeMode.primTextColor)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

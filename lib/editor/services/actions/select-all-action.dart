import 'package:flutter/material.dart';

import '../../widgets/raw-editor.dart';

// +++ DOC
class SelectAllAction extends ContextAction<SelectAllTextIntent> {
  SelectAllAction(this.state);

  final RawEditorState state;

  @override
  Object? invoke(SelectAllTextIntent intent, [BuildContext? context]) {
    return Actions.invoke(
      context!,
      UpdateSelectionIntent(
        state.textEditingValue,
        TextSelection(
          baseOffset: 0,
          extentOffset: state.textEditingValue.text.length,
        ),
        intent.cause,
      ),
    );
  }

  @override
  bool get isActionEnabled => state.widget.selectionEnabled;
}

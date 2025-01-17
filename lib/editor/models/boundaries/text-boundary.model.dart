import 'package:flutter/material.dart';

// +++ REVIEW
// An interface for retrieving the logical text boundary (left-closed-right-open) at a given location in a document.
// Depending on the implementation of the TextBoundaryM, the input TextPosition can either point to a code unit, 
// or a position between 2 code units (which can be visually represented by the caret 
// if the selection were to collapse to that position).
//
// For example, _LineBreak interprets the input TextPosition as a caret location, 
// since in Flutter the caret is generally painted between the character the TextPosition points to and its previous character, 
// and _LineBreak cares about the affinity of the input TextPosition. 
// 
// Most other text boundaries however, interpret the input TextPosition as the location of a code unit in the document,
// since it's easier to reason about the text boundary given a code unit in the text.
// To convert a "code-unit-based" TextBoundaryM to "caret-location-based", use the _CollapsedSelectionBoundary combinator.
abstract class TextBoundaryM {
  const TextBoundaryM();

  TextEditingValue get textEditingValue;

  // Returns the leading text boundary at the given location, inclusive.
  TextPosition getLeadingTextBoundaryAt(TextPosition position);

  // Returns the trailing text boundary at the given location, exclusive.
  TextPosition getTrailingTextBoundaryAt(TextPosition position);

  TextRange getTextBoundaryAt(TextPosition position) {
    return TextRange(
      start: getLeadingTextBoundaryAt(position).offset,
      end: getTrailingTextBoundaryAt(position).offset,
    );
  }
}

Option Explicit

Sub FormulasToValues()
    '
    ' Convert formula cells to their values.
    '
    If TypeName(Selection) <> "Range" Then Exit Sub

    Selection.Value2 = Selection.Value2
End Sub

Sub AutoFillHyperlinkValues()
    '
    ' Excel autofill is broken when updating a column of hyperlinked
    ' cells with the cell value from another column. For example, you
    ' may have hyperlinks in column A but want to use column B as the
    ' new display text. This should be achievable by entering the
    ' formula `=B2` in cell A2 except autofill will overwrite all the
    ' following hyperlinks in column A with the hyperlink from A2. This
    ' macro provides a workaround to this behavior.
    '
    Dim r As Long

    For r = 1 To Selection.Rows.Count
        With Selection.Cells(r, 1)
            If .Hyperlinks.Count > 0 Then
                .Hyperlinks(1).TextToDisplay = Selection.Cells(r, 2).Value
            Else
                .Value = Selection.Cells(r, 2).Value
            End If
        End With
    Next r
End Sub


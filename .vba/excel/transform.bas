Sub FormulasToValues()
    '
    ' Convert formula cells to their values.
    '
    If TypeName(Selection) <> "Range" Then Exit Sub

    Selection.Value2 = Selection.Value2
End Sub


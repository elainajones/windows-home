Option Explicit


Private Function HasDiffHighlight(rng As Range) As Boolean
    '
    ' Check if selected cells have specific condition formatting
    ' highlights.
    '
    Dim c As Range
    Dim col As Long

    For Each c In rng.Cells
        col = c.DisplayFormat.Interior.Color

        If col = RGB(255, 200, 200) Or col = RGB(200, 200, 255) Then
            HasDiffHighlight = True
            Exit Function
        End If
    Next c
End Function


Sub DiffHighlightedRows()
    '
    ' Add condition formatting highlights for diff between two
    ' selected columns.
    '
    Dim sel As Range
    Dim r1 As Range, r2 As Range

    ' Must select exactly 2 areas
    If Selection.Areas.Count <> 2 Then
        MsgBox "Select exactly two column ranges (Ctrl + Click)."
        Exit Sub
    End If

    Set r1 = Selection.Areas(1)
    Set r2 = Selection.Areas(2)

    ' Clear existing CF?
    ' r1.FormatConditions.Delete
    ' r2.FormatConditions.Delete

    ' Rule 1: values in r1 NOT in r2
    With r1.FormatConditions.Add( _
        Type:=xlExpression, _
        Formula1:="=COUNTIF(" & r2.Address(True, True) & ", " & r1.Cells(1, 1).Address(False, False) & ")=0")

        ' light red
        .Interior.Color = RGB(255, 200, 200)
    End With

    ' Rule 2: values in r2 NOT in r1
    With r2.FormatConditions.Add( _
        Type:=xlExpression, _
        Formula1:="=COUNTIF(" & r1.Address(True, True) & ", " & r2.Cells(1, 1).Address(False, False) & ")=0")

        ' light blue
        .Interior.Color = RGB(200, 200, 255)
    End With
End Sub

Sub CompactHighlightedRows()
    '
    ' Clear and compact (move up) rows in selection if they contain the
    ' specific condition highlights (i.e. remove diff lines).
    '

    Dim area As Range
    Dim readRow As Long, writeRow As Long
    Dim rowRng As Range
    Dim hit As Boolean

    If TypeName(Selection) <> "Range" Then Exit Sub

    Application.ScreenUpdating = False
    Application.EnableEvents = False

    For Each area In Selection.Areas
        writeRow = 1

        For readRow = 1 To area.Rows.Count
            Set rowRng = area.Rows(readRow)

            hit = HasDiffHighlight(rowRng)
            If Not hit Then
                ' Keep and move this row up (values only, formats stay put)
                If writeRow <> readRow Then
                    area.Rows(writeRow).Value2 = rowRng.Value2
                End If
                writeRow = writeRow + 1
            End If
        Next readRow

        ' Clear the leftover tail inside the selection
        If writeRow <= area.Rows.Count Then
            area.Rows(writeRow & ":" & area.Rows.Count).ClearContents
        End If
    Next area

CleanUp:
    Application.EnableEvents = True
    Application.ScreenUpdating = True
End Sub


Sub DiffOrCompact()
    '
    ' Remove diff lines if selection contains specific condition
    ' formatting highlights, otherwise add a diff.
    '
    If TypeName(Selection) <> "Range" Then Exit Sub

    If HasDiffHighlight(Selection) Then
        ' Already highlighted. Remove rows and clear condition formats
        CompactHighlightedRows
        Selection.FormatConditions.Delete
    Else
        ' No condition format highlight. Apply diff highlighting
        DiffHighlightedRows
    End If
End Sub

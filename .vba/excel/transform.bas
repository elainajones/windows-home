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

Sub CombineCellValues()
    '
    ' Combines selected cell values into the top leftmost cell. This is
    ' similar to "Merge Cells" except data is combined, not truncated.
    '
    ' When combining a vertical selection of cells, newlines will be
    ' added. If entire columns are selected, individual rows will be
    ' combined together for each row. In both cases, each group of
    ' combined cells will preserve any existing hyperlinks.
    '
    ' Merging columns is useful after using SplitCellValues across a
    ' column selection or to append/prepend text to values in a column.
    '
    Dim cell As Range
    Dim rowRange As Range
    Dim firstCell As Range
    Dim out As String
    Dim separator As String
    Dim hyperlink As String
    Dim row As Long
    Dim lastRow As Long

    If TypeName(Selection) <> "Range" Then Exit Sub

    ' If entire columns are selected, combine each row horizontally.
    If Selection.Rows.Count = Rows.Count And Selection.Columns.Count > 1 Then
        lastRow = 0

        For Each cell In Selection.Cells
            If cell.Value <> "" Then
                If cell.Row > lastRow Then lastRow = cell.Row
            End If
        Next

        For row = 1 To lastRow
            Set rowRange = Intersect(Selection, Rows(row))

            out = ""
            hyperlink = ""
            For Each cell In rowRange
                out = out & cell.Text

                If cell.Hyperlinks.Count > 0 Then
                    hyperlink = cell.Hyperlinks(1).Address
                End If
            Next

            Set firstCell = rowRange.Cells(1, 1)
            firstCell.Value = out

            If hyperlink <> "" Then
                firstCell.Hyperlinks.Add _
                    Anchor:=firstCell, _
                    Address:=hyperlink, _
                    TextToDisplay:=out
            End If

            For Each cell In rowRange
                If cell.Address <> firstCell.Address Then
                    cell.ClearContents
                    cell.Hyperlinks.Delete
                End If
            Next
        Next
        Exit Sub
    End If

    Set firstCell = Selection.Cells(1, 1)

    ' Add a newline for vertical selections
    If Selection.Rows.Count > Selection.Columns.Count Then
        separator = vbCrLf
    End If

    For Each cell In Selection.Cells
        out = out & cell.Text & separator

        ' Save any hyperlinks. If more than one, the last found
        ' hyperlink will be used.
        If cell.Hyperlinks.Count > 0 Then
            hyperlink = cell.Hyperlinks(1).Address
        End If
    Next

    If separator <> "" Then
        out = Left$(out, Len(out) - Len(separator))
    End If

    firstCell.Value = out

    If hyperlink <> "" Then
        firstCell.Hyperlinks.Add _
            Anchor:=firstCell, _
            Address:=hyperlink, _
            TextToDisplay:=out
    End If

    For Each cell In Selection.Cells
        If cell.Address <> firstCell.Address Then
            cell.ClearContents
            cell.Hyperlinks.Delete
        End If
    Next
End Sub

Sub SplitCellValue()
    '
    ' Splits the selected cell(s) by the first case-sensitive match of the
    ' provided string. Similar to Text-to-Columns except the delimiter is
    ' preserved in the split text.
    '
    Dim p As String
    Dim t As String
    Dim i As Long
    Dim c As Range

    p = InputBox("Split after:")
    If p = "" Then Exit Sub

    Columns(Selection.Column).Insert

    For Each c In Selection
        t = c.Offset(0, 1).Value
        i = InStr(1, t, p, vbBinaryCompare)

        If i > 0 Then
            c.Value = Left$(t, i + Len(p) - 1)
            c.Offset(0, 1).Value = Mid$(t, i + Len(p))
        End If
    Next c
End Sub

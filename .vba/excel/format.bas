Sub HyperlinkTicketIDs()
    '
    ' Adds hyperlinks to a row of IDs using a given base URL.
    ' Useful for adding hyperlinks to a list of ticket IDs in a report.
    '
    Dim c As Range
    Dim baseUrl As String

    baseUrl = InputBox("Enter base URL:")
    If baseUrl = "" Then Exit Sub

    For Each c In Selection
        If Trim(c.Value) <> "" Then
            c.Hyperlinks.Add _
                Anchor:=c, _
                Address:=baseUrl & CStr(c.Value), _
                TextToDisplay:=CStr(c.Value)
        End If
    Next c
End Sub

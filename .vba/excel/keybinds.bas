Public Sub BindKeys()
    '
    ' Reserved macro. Runs automatically when starting Excel.
    '

    ' Reload macros
    Application.OnKey "^+R", "LoadPlugins"
    Application.OnKey "^+M", "MergeSelectedCellValues"
    Application.OnKey "^+K", "HyperlinkTicketIDs"
    Application.OnKey "^+D", "DiffOrCompact"
    Application.OnKey "^+V", "FormulasToValues"
    Application.OnKey "^+C", "CopySelectedCellsToClipboard"
    Application.OnKey "^+A", "AutoFillHyperlinkValues"
End Sub

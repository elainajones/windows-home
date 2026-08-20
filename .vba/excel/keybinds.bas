Public Sub BindKeys()
    '
    ' Reserved macro. Runs automatically when starting Excel.
    '

    ' Reload macros
    Application.OnKey "^+R", "LoadPlugins"
    Application.OnKey "^+M", "CombineCellValues"
    Application.OnKey "^+K", "HyperlinkTicketIDs"
    Application.OnKey "^+D", "DiffOrCompact"
    Application.OnKey "^+V", "FormulasToValues"
    Application.OnKey "^+C", "CopySelectedCellsToClipboard"
    Application.OnKey "^+A", "AutoFillHyperlinkValues"
    Application.OnKey "^+S", "SplitCellValue"
End Sub

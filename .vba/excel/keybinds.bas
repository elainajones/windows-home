Public Sub BindKeys()
    '
    ' Reserved macro. Runs automatically when starting Excel.
    '

    ' Reload macros
    Application.OnKey "^+R", "LoadPlugins"
    Application.OnKey "^+K", "HyperlinkTicketIDs"
    Application.OnKey "^+D", "DiffOrCompact"
End Sub

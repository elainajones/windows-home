' Reserved macro. Runs automatically when starting Excel.
Public Sub BindKeys()
    ' Reload macros
    Application.OnKey "^+R", "LoadPlugins"
End Sub

Option Explicit

' Needed for clipboard access
Private Declare PtrSafe Function OpenClipboard Lib "user32" (ByVal hwnd As LongPtr) As Long
Private Declare PtrSafe Function EmptyClipboard Lib "user32" () As Long
Private Declare PtrSafe Function SetClipboardData Lib "user32" (ByVal wFormat As Long, ByVal hMem As LongPtr) As LongPtr
Private Declare PtrSafe Function CloseClipboard Lib "user32" () As Long

Private Declare PtrSafe Function GlobalAlloc Lib "kernel32" (ByVal wFlags As Long, ByVal dwBytes As LongPtr) As LongPtr
Private Declare PtrSafe Function GlobalLock Lib "kernel32" (ByVal hMem As LongPtr) As LongPtr
Private Declare PtrSafe Function GlobalUnlock Lib "kernel32" (ByVal hMem As LongPtr) As Long
Private Declare PtrSafe Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" _
    (ByVal dest As LongPtr, ByVal src As LongPtr, ByVal bytes As LongPtr)

Private Sub CopyToClipboard(ByVal s As String)
    Const GMEM_MOVEABLE = &H2
    Const CF_UNICODETEXT = 13

    Dim hMem As LongPtr
    Dim pMem As LongPtr

    hMem = GlobalAlloc(GMEM_MOVEABLE, (Len(s) + 1) * 2)
    pMem = GlobalLock(hMem)

    CopyMemory pMem, StrPtr(s), LenB(s)

    GlobalUnlock hMem

    OpenClipboard 0
    EmptyClipboard
    SetClipboardData CF_UNICODETEXT, hMem
    CloseClipboard
End Sub

Private Sub QuickSort(arr, first As Long, last As Long)
    Dim i As Long, j As Long, pivot, t
    i = first: j = last: pivot = arr((first + last) \ 2)
    While i <= j
        While arr(i) < pivot: i = i + 1: Wend
        While arr(j) > pivot: j = j - 1: Wend
        If i <= j Then t = arr(i): arr(i) = arr(j): arr(j) = t: i = i + 1: j = j - 1
    Wend
    If first < j Then QuickSort arr, first, j
    If i < last Then QuickSort arr, i, last
End Sub

Sub CopySelectedCellsToClipboard()
    '
    ' Copies only the selected cells to the clipboard while compacting
    ' relative row/column positions. Normally when you try to copy
    ' specific cells from a table, excel copies everything in between
    ' your selection. This is useful when you want to create a sub-
    ' table.
    '
    Dim sel As Range, cell As Range
    Dim rKeys As Variant, cKeys As Variant
    Dim rList As Object, cList As Object
    Dim i As Long, r As Long, c As Long
    Dim grid() As String, out As String

    If TypeName(Selection) <> "Range" Then Exit Sub
    Set sel = Selection
    If sel.Cells.Count < 2 Then Exit Sub

    ' Collect unique rows/cols
    Set rList = CreateObject("Scripting.Dictionary")
    Set cList = CreateObject("Scripting.Dictionary")

    For Each cell In sel.Cells
        rList(cell.Row) = 1
        cList(cell.Column) = 1
    Next

    rKeys = rList.Keys
    cKeys = cList.Keys

    If UBound(rKeys) > 0 Then QuickSort rKeys, 0, UBound(rKeys)
    If UBound(cKeys) > 0 Then QuickSort cKeys, 0, UBound(cKeys)

    ReDim grid(1 To UBound(rKeys) + 1, 1 To UBound(cKeys) + 1)

    ' Fill grid (lookup index on the fly instead of maps)
    For Each cell In sel.Cells
        r = Application.Match(cell.Row, rKeys, 0)
        c = Application.Match(cell.Column, cKeys, 0)
        grid(r, c) = cell.Text
    Next

    ' Build TSV
    For r = 1 To UBound(grid, 1)
        For c = 1 To UBound(grid, 2)
            out = out & grid(r, c)
            If c < UBound(grid, 2) Then out = out & vbTab
        Next
        If r < UBound(grid, 1) Then out = out & vbCrLf
    Next

    CopyToClipboard out
End Sub

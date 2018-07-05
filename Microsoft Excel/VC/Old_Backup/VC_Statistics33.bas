Attribute VB_Name = "V_Statistics"
'(RUN 2:::::::::::::)
'This code Merging the Volvo resource files)
Sub CombineFiles()
     
    Dim Path As String
    Dim fileName As String
    Dim Wkb As Workbook
    Dim ws As Worksheet
    
ActiveSheet.Name = "Volvo_Statistik"
    intResult = Application.FileDialog(msoFileDialogFolderPicker).Show

If intResult = 0 Then

    MsgBox "User pressed cancel macro will stop!"

Exit Sub

Else

strDocPath = Application.FileDialog(msoFileDialogFolderPicker).SelectedItems(1) & "\"

End If

    Application.EnableEvents = False
    Application.ScreenUpdating = False

    fileName = Dir(strDocPath & "\*.xls", vbNormal)
    Do Until fileName = ""
        Set Wkb = Workbooks.Open(fileName:=strDocPath & "\" & fileName)
        For Each ws In Wkb.Worksheets
         Application.DisplayAlerts = False
         wbname = Replace(fileName, ".xls", "")

       'MsgBox WBname
            ws.Copy After:=ThisWorkbook.Sheets(ThisWorkbook.Sheets.Count)
            
        Next ws
        ActiveSheet.Name = (wbname)
        Wkb.Close False
        fileName = Dir()
    Loop
         
    Worksheets("Volvo_Statistik").Move Before:=Worksheets(1)
    
Application.DisplayAlerts = False
On Error Resume Next
ThisWorkbook.Sheets("Blad1").Delete
ThisWorkbook.Sheets("Orders").Delete
On Error GoTo 0
Application.DisplayAlerts = True
'     Dim sh As Worksheet
'    For Each sh In Sheets
'        If IsEmpty(sh.UsedRange) Then sh.Delete
'    Next
    Application.EnableEvents = True
    Application.ScreenUpdating = True
    
End Sub


Sub all()
' This is a Batch function instead of run all functions separately


Call GetColData
Call mYear
Call myMonth
Call CheckInstandCol
Call CheckNumOfIns
Call RemColCells
Call Company
Call NewWordsC
Call FuzzyC
Call RepsandHund
Call ConvToNum
Call AutoFilICCoE
Call myZ
Call myAA
Call ColorNegativeVal
Call InsertFirstRow

End Sub

Sub GetColData()


  Dim X As Long
  Dim Sht As Worksheet
  Dim Target As Worksheet
  Dim VS() As String
  Dim TS() As String
  'I use Const here to be able to have one string that contains many elements, and each element is seperated by a comma.
  Const Vehicles = "Volvo_3P,Volvo_Penta,Volvo_Business_Service,Volvo_Group_Trucks_Technology,Volvo_Information_Technology_AB,Volvo_Group_Sweden,Volvo_IT"
  
  Set Target = Sheets("Volvo_Statistik")
  
  'here is the columns from the company sheet
  VS = Split("A,C,D,E,G,H,I,J,K,K,M,O", ",")
  
  'here is the positioning for all columns
  TS = Split("A,D,H,I,J,K,L,M,E,F,U,AB", ",")
  
        For Each Sht In ThisWorkbook.Worksheets
            If InStr(Vehicles, "," & Sht.Name) Then
                For X = 0 To UBound(VS)
                    Sht.Columns(VS(X)).Copy Target.Cells(1, TS(X))
                Next
            End If
        Next

End Sub

Sub mYear()
'This function removes the 6 last characters from the word and then replace with the first 4 characters.Sheets("Volvo_Statistik").Activate
        For Each Sht In ThisWorkbook.Worksheets
        mysheetname = Sht.Name
        
            If Sht.Name Like "Volvo_Statistik*" Then
            
            activeWS = ActiveSheet.UsedRange.Rows.Count
            Dim cell As Range
            Dim mystring As String
                For Each cell In Range("E1:E" & activeWS)
                myResult = Left(cell.Text, Len(cell.Text) - 6)
                cell.Value = myResult
                Next
                
            Else
            MsgBox "Sheetet Volvo_Statistik Does not exists"
            End If
        Exit For

    Next Sht
    
End Sub

Sub myMonth()
Dim Sht As Worksheet
    For Each Sht In ThisWorkbook.Worksheets

        If Sht.Name Like "Volvo_Statistik*" Then
            With Sht.Range("F2:F" & Sht.Range("F" & Sht.Rows.Count).End(xlUp).Row)
            .NumberFormat = "@"
            .Cells = Evaluate("=INDEX(TEXT(MONTH('" & Sht.Name & "'!" & .Address & "+0),""00""),0)")
            End With
        End If
    
                For i = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
                    myF = Cells(i, "F").Value
                    Cells(i, "F").Value = Val(myF)
                Next i
    Next Sht
        Rows(1).EntireRow.Delete
End Sub

Sub CheckInstandCol()

  For Z = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
  'if Value in column H and I equal "MLY" then look in whole Column A for instances
  
        If Cells(Z, "H").Value = "MLY" And Cells(Z, "I").Value = "MLY" Then ' statements
        mycell = Cells(Z, "A").Value
        myOcc = Application.CountIf(Range("A1", Cells(Rows.Count, "A").End(xlUp)), mycell)
        
        
        myNumofOC = myOcc - 1 'Here is the number of instances less -1
        Cells(Z, "B").Value = myNumofOC ' set the number of how many instances on the same row
        
        Cells(Z, "B").EntireRow.Interior.ColorIndex = 4
        End If
        
            Next Z
            'END LOOP
            
            'Below it's a loop(this thime without any statements) and then use the order number (cells(Z,"B").value)
            'then look for it everywhere in same column
                For X = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
                
                    If Cells(X, "H").Value = "IND" And Cells(X, "I").Value = "IND" Then
                    
                    mycell = Cells(X, "A").Value
                    myOcc = Application.CountIf(Range("A1", Cells(Rows.Count, "A").End(xlUp)), mycell)
                    myNumofOC = myOcc - 1
                    Cells(X, "B").Value = myNumofOC
                    myOrderNr = Cells(X, "A").Value
                    myPrelCost = Cells(X, "AB").Value
                    myResult = myPrelCost / myNumofOC
                    Cells(X, "B").Value = myNumofOC
                    Cells(X, "B").EntireRow.Interior.ColorIndex = 6
                    
                    End If
                Next X

End Sub

Sub CheckNumOfIns()

  For Z = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
        If Cells(Z, "H").Value = "MLY" And Cells(Z, "I").Value = "MLY" Then
  
        mycell = Cells(Z, "A").Value
        myOcc = Application.CountIf(Range("A1", Cells(Rows.Count, "A").End(xlUp)), mycell)
        myNumofOC = myOcc - 1
        Cells(Z, "B").Value = myNumofOC
        myOrderNr = Cells(Z, "A").Value
        myPrelCost = Cells(Z, "AB").Value
        myResult = myPrelCost / myNumofOC
        Cells(Z, "B").Value = myNumofOC
     
        End If
    Next Z
    
    For i = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
    
        If Cells(i, "b").Value > 0 Then
        mycell = Cells(i, "A").Value
        myVal = Cells(i, "B").Value
        myPrel = Cells(i, "AB").Value
        mySum = Val(myPrel / myVal)
        End If
      
            For X = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
            
                If Cells(X, "A").Value = mycell Then
                Cells(X, "R").Value = mySum
                End If
                
            Next X
    
    Next i
    
End Sub

Sub RemColCells()

    For i = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
        If Cells(i, "H") = "IND" Then
        Cells(i, 1).EntireRow.Delete
        End If
    Next i
    
      
End Sub


Sub RemIND()

  For X = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
            If Cells(X, "H") = "MLY" Then
            Cells(X, 1).EntireRow.Delete
            End If
        Next X

End Sub

Sub Company()

Dim wb As Workbook
Dim ws As Worksheet
Set wb = ActiveWorkbook

Columns(2).EntireColumn.ClearContents

        For Each ws In wb.Worksheets
             
            If ws.Name = "Volvo_3P" Then
            For i = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
            Cells(i, "B") = "Volvo 3P"
            Next i
            End If
            
            If ws.Name = "Volvo_Penta" Then
            For i = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
            Cells(i, "B") = "Volvo Penta"
            Next i
            End If
            
            If ws.Name = "Volvo_Bus" Then
            For i = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
            Cells(i, "B") = "Volvo Bus"
            Next i
            End If
            
             If ws.Name = "Volvo_Group_Trucks_Technology" Then
            For i = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
            Cells(i, "B") = "Volvo Group Trucks Technology"
            Next i
            End If
            
             If ws.Name = "Volvo_Information_Technology_AB" Then
            For i = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
            Cells(i, "B") = "Volvo Information Technology AB"
            Next i
            End If
            
            
            If ws.Name = "Volvo_Business_Service" Then
            For i = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
            Cells(i, "B") = "Volvo Business Service"
            Next i
            End If
            
            If ws.Name = "Volvo_Group_Sweden" Then
            For i = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
            Cells(i, "B") = "Volvo Group Sweden"
            Next i
            End If
            
            If ws.Name = "Volvo_IT" Then
            For i = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
            Cells(i, "B") = "Volvo IT"
            Next i
        End If
    Next
    
End Sub






Sub Comjpany()


  Dim X As Long
  Dim Sht As Worksheet
  Dim Target As Worksheet
  Dim VS() As String
  Dim TS() As String
  'I use Const here to be able to have one string that contains many elements, and each element is seperated by a comma.
  Const Vehicles = "Volvo_3P,Volvo_Penta,Volvo_Business_Service,Volvo_Group_Trucks_Technology,Volvo_Information_Technology_AB,Volvo_Group_Sweden,Volvo_IT"
  
  Set Target = Sheets("Volvo_Statistik")
  
  'here is the columns from the company sheet

  
  'here is the positioning for all columns
  
       For Each Sht In ThisWorkbook.Worksheets
            If InStr(Vehicles, "," & Sht.Name) Then
            
            
             For i = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
          
          
          MsgBox Vehicles
          
          '  Cells(i, "B") = "Volvo 3P"
            Next i
            
            
'                For X = 0 To UBound(VS)
'                    Sht.Columns(VS(X)).Copy Target.Cells(1, TS(X))
'                Next
            End If
        Next

End Sub





Sub NewWordsC()
    Dim ws1 As Worksheet
    Dim ws2 As Worksheet
    Dim r As Long
    Dim m As Long
    Dim s As Long
    Dim n As Long

    Set ws1 = Worksheets("Volvo_Statistik")
    m = ws1.Range("A" & ws1.Rows.Count).End(xlUp).Row
    
    Set ws2 = Worksheets("volvo_NewPrices")
    n = ws2.Range("A" & ws2.Rows.Count).End(xlUp).Row
    
    For r = 1 To m
        For s = 1 To n
            If Trim(ws1.Range("H" & r) & ws1.Range("I" & r)) = Trim(ws2.Range("A" & s) & ws2.Range("B" & s)) Then
            
                'MsgBox "Cells " & "A" & r & " " & "B" & r & " on Sheet1 contain " & ws1.Range("A" & r) & " " & ws1.Range("B" & r) & " which matches A" & s & " " & "B" & s & " on Sheet2"
                'Sheets("Volvo_Statistik").Activate
                'Range("J" & r).Select
                'MsgBox ws1.Range("J" & r).Value
                'Sheets("volvo_NewPrices").Activate
                'Range("G" & s).Select
                'MsgBox ws2.Range("G" & s).Value
                'ws1.Range("N" & r).Value = Val(ws1.Range("J" & r)) * Val(ws2.Range("G" & s))
                                                                      
                myStringRes = Val(ws1.Range("J" & r)) * Val(ws2.Range("G" & s))
                myRes = Round(myStringRes, 2)
                ws1.Range("N" & r).Value = "" & myRes
                 
            End If
        Next s
    Next r
End Sub

Sub FuzzyC()
    Dim ws1 As Worksheet
    Dim ws2 As Worksheet
    Dim r As Long
    Dim m As Long
    Dim s As Long
    Dim n As Long

    Set ws1 = Worksheets("Volvo_Statistik")
    m = ws1.Range("A" & ws1.Rows.Count).End(xlUp).Row
    
    Set ws2 = Worksheets("volvo_NewPrices")
    n = ws2.Range("A" & ws2.Rows.Count).End(xlUp).Row
    
    For r = 1 To m
        For s = 1 To n
            If Trim(ws1.Range("H" & r) & ws1.Range("I" & r)) = Trim(ws2.Range("A" & s) & ws2.Range("B" & s)) Then
                                 
                'MsgBox "Cells " & "A" & r & " " & "B" & r & " on Sheet1 contain " & ws1.Range("A" & r) & " " & ws1.Range("B" & r) & " which matches A" & s & " " & "B" & s & " on Sheet2"
                'Sheets("Volvo_Statistik").Activate
                'Range("J" & r).Select
                'MsgBox ws1.Range("K" & r).Value
                'Sheets("volvo_NewPrices").Activate
                'Range("F" & s).Select
                'MsgBox ws2.Range("F" & s).Value
                
                myStringRes = Val(ws1.Range("K" & r)) * Val(ws2.Range("F" & s))
                myRes = Round(myStringRes, 2)
                ws1.Range("O" & r).Value = "" & myRes
                    
            End If
        Next s
    Next r
End Sub

Sub RepsandHund()
    Dim ws1 As Worksheet
    Dim ws2 As Worksheet
    Dim r As Long
    Dim m As Long
    Dim s As Long
    Dim n As Long

    Set ws1 = Worksheets("Volvo_Statistik")
    m = ws1.Range("A" & ws1.Rows.Count).End(xlUp).Row
    
    Set ws2 = Worksheets("volvo_NewPrices")
    n = ws2.Range("A" & ws2.Rows.Count).End(xlUp).Row
    
    For r = 1 To m
        For s = 1 To n
            If Trim(ws1.Range("H" & r) & ws1.Range("I" & r)) = Trim(ws2.Range("A" & s) & ws2.Range("B" & s)) Then
            
                    'MsgBox "Cells " & "A" & r & " " & "B" & r & " on Sheet1 contain " & ws1.Range("A" & r) & " " & ws1.Range("B" & r) & " which matches A" & s & " " & "B" & s & " on Sheet2"
                    'Sheets("Volvo_Statistik").Activate
                    'Range("J" & r).Select
                    'MsgBox ws1.Range("K" & r).Value
                    'Sheets("volvo_NewPrices").Activate
                    'Range("F" & s).Select
                    'MsgBox ws2.Range("F" & s).Value
                    'ws1.Range("P" & r).Value = Val(ws1.Range("L" & r)) * Val(ws2.Range("D" & s))
                                          
                    myStringRes = Val(ws1.Range("L" & r)) * Val(ws2.Range("D" & s))
                    myRes = Round(myStringRes, 2)
                    ws1.Range("P" & r).Value = "" & myRes
                        
                 
            End If
        Next s
    Next r
End Sub

Sub ConvToNum()

'This function makes each result in a cell to format of 2 decimals;;;;;;;;;;;;;;;;;;;;;;
For i = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
  
        myResN = Round((Cells(i, "N").Value), 2)
        Cells(i, "N").Value = myResN
        
        myResO = Round((Cells(i, "O").Value), 2)
        Cells(i, "O").Value = myResO
        
        myResP = Round((Cells(i, "P").Value), 2)
        Cells(i, "P").Value = myResP
   
Next i
End Sub

Sub AutoFilICCoE()

'This function makes each result in a cell to format of 2 decimals;;;;;;;;;;;;;;;;;;;;;;
For X = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
   Cells(X, "Q").Value = "0"
Next X
End Sub

Sub myZ()
 Dim ws1 As Worksheet
    Dim ws2 As Worksheet
    Dim r As Long
    Dim m As Long
    Dim s As Long
    Dim n As Long

    Set ws1 = Worksheets("Volvo_Statistik")
    m = ws1.Range("A" & ws1.Rows.Count).End(xlUp).Row
    
    Set ws2 = Worksheets("volvo_NewPrices")
    n = ws2.Range("A" & ws2.Rows.Count).End(xlUp).Row
    
    For r = 1 To m
        For s = 1 To n
            If Trim(ws1.Range("H" & r) & ws1.Range("I" & r)) = Trim(ws2.Range("A" & s) & ws2.Range("B" & s)) Then
            
                NoNWords = Val(Cells(r, "J").Value)
                FuzzyMatch = Val(Cells(r, "K").Value) ' ordantal
                HundAndRep = Val(Cells(r, "L").Value)
                   
                NowordsS2 = Val(ws2.Range("G" & s).Value)
                FuzzyMatchS2 = Val(ws2.Range("F" & s).Value) 'resp
                HundAndRepS2 = Val(ws2.Range("E" & s).Value)
                    
                NoWorsdsTotL = Round((NoNWords * NowordsS2), 2)
                FuzzyMatchTotL = Round((FuzzyMatch * FuzzyMatchS2), 2)
                HundAndRepTotL = Round((HundAndRep * HundAndRepS2), 2)
                
                myTot1 = NoWorsdsTotL + FuzzyMatchTotL + HundAndRepTotL
                
                NoWorsdsTotH = Round((NoNWords * NowordsS2), 2)
                FuzzyMatchTotH = Round((FuzzyMatch * NowordsS2), 2)
                HundAndRepTotH = Round((HundAndRep * NowordsS2), 2)
                
                myTot2 = NoWorsdsTotH + FuzzyMatchTotH + HundAndRepTotH
                
                myResult = myTot2 - myTot1
                
                
                ws1.Range("Z" & r).Value = myResult
                
              '  Debug.Print myTot2 - myTot1
   
            End If
        Next s
Next r
End Sub


Sub myAA()
 Dim ws1 As Worksheet
    Dim ws2 As Worksheet
    Dim r As Long
    Dim m As Long
    Dim s As Long
    Dim n As Long

    Set ws1 = Worksheets("Volvo_Statistik")
    m = ws1.Range("A" & ws1.Rows.Count).End(xlUp).Row
    
    Set ws2 = Worksheets("volvo_NewPrices")
    n = ws2.Range("A" & ws2.Rows.Count).End(xlUp).Row
    
    For r = 1 To m
        For s = 1 To n
            If Trim(ws1.Range("H" & r) & ws1.Range("I" & r)) = Trim(ws2.Range("A" & s) & ws2.Range("B" & s)) Then
            
                NoNWords = Val(Cells(r, "J").Value)
                FuzzyMatch = Val(Cells(r, "K").Value) ' ordantal
                HundAndRep = Val(Cells(r, "L").Value)
                
                
                NowordsS2 = Val(ws2.Range("G" & s).Value)
                FuzzyMatchS2 = Val(ws2.Range("F" & s).Value) 'resp
                HundAndRepS2 = Val(ws2.Range("E" & s).Value)
                
                
                NoWorsdsTotL = Round((NoNWords * NowordsS2), 2)
                FuzzyMatchTotL = Round((FuzzyMatch * FuzzyMatchS2), 2)
                HundAndRepTotL = Round((HundAndRep * HundAndRepS2), 2)
                
                myTot1 = NoWorsdsTotL + FuzzyMatchTotL + HundAndRepTotL
                
                
                NoWorsdsTotH = Round((NoNWords * 0.148), 2)
                FuzzyMatchTotH = Round((FuzzyMatch * 0.074), 2)
                HundAndRepTotH = Round((HundAndRep * 0.037), 2)
                
                myTot2 = NoWorsdsTotH + FuzzyMatchTotH + HundAndRepTotH
                
                myResult = myTot2 - myTot1
                ws1.Range("AA" & r).Value = myResult
   
            End If
        Next s
Next r
End Sub

Sub ColorNegativeVal()

'This function makes each result in a cell to format of 2 decimals;;;;;;;;;;;;;;;;;;;;;;
For i = 1 To ActiveSheet.UsedRange.SpecialCells(xlCellTypeLastCell).Row
  
    If Cells(i, "Z").Value < 0 Then
    Cells(i, "Z").EntireRow.Interior.ColorIndex = 3
    End If
    
Next i
End Sub

Sub InsertFirstRow()
    Sheets("Volvo_Row_one").Select
    Rows("1:1").Select
    Selection.Copy
    Sheets("Volvo_Statistik").Select
    Rows("1:1").Select
    Selection.Insert Shift:=xlDown
Rows("1:1").EntireRow.Interior.Color = xlNone

End Sub

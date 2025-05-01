$Debug
Const Game_Name = "The Labyrinth Of Time's Edge"
Const Version = "v4.1.11"

_Title Game_Name + " - " + Version

r = 1

DECLARE SUB CenterPrint (Text$)
DECLARE SUB CenterPrintWithLine (Text$) ' This function will print text center with a line on both sides of it ---Like This---

Screen 12
Color 15, 0
Cls

$ExeIcon:'LABICON.ico'

gotlantern = 1
gotsword = 1
gotshard = 0
gotrelic = 0
gotcrown = 0
gotoryn = 0
gottear = 0
gotheart = 0
gotchalice = 0
gotmirror = 0
gotshield = 0
gotgauntlet = 0
gotamuletofwhispers = 0
gotamuletofshadows = 0
gotamuletofthecelestialkey = 0
gotamuletofwildsong = 0
gotamuletoftheshiftingsands = 0
gottheechoesoflostages = 0
gottheserpentscanticle = 0
gotthearchitectsoath = 0
gotthefleshandshadow = 0
gotthelabyrinthsbreath = 0
gotthemoonthatwatches = 0
gotthegildedprison = 0
gottheunwrittentestament = 0

Dim Shared DOOM As Double
Minutes = 1439
Seconds = 59
GameTime = Minutes * 60 + Seconds

MaxRooms = 0
MaxInteractions = 0

Type CommandData
    commandString As String
    requiredRoom As Integer
    requiredItem As String
    titleLine As String
    displayText As String
End Type

Type RoomData
    title As String
    description As String
    northExit As Integer
    southExit As Integer
    eastExit As Integer
    westExit As Integer
End Type

Open "rooms.txt" For Input As #1
Line Input #1, firstLine$
MaxRooms = Val(firstLine$)
Dim Shared rooms(1 To MaxRooms) As RoomData
For roomNum = 1 To MaxRooms
    buffer$ = ""
    lineCount = 0
    foundStart = 0

    ' Find start marker
    Do While Not EOF(1)
        Line Input #1, currentLine$
        If currentLine$ = "--ROOM " + RTrim$(LTrim$(Str$(roomNum))) + " START--" Then
            foundStart = 1
            Exit Do
        End If
    Loop

    If foundStart = 0 Then Print "Error: Start marker room"; roomNum: Close #1: End

    ' Read all lines between START and END into buffer
    Do While Not EOF(1)
        Line Input #1, currentLine$
        If currentLine$ = "--ROOM " + LTrim$(Str$(roomNum)) + " END--" Then Exit Do
        buffer$ = buffer$ + currentLine$ + Chr$(0) ' Use CHR$(0) as line separator
        lineCount = lineCount + 1
    Loop

    If lineCount < 2 Then Print "Error: Missing title/exit for room"; roomNum: Close #1: End

    ' Extract Title (first line)
    nullPos = InStr(buffer$, Chr$(0))
    rooms(roomNum).title = Left$(buffer$, nullPos - 1)
    buffer$ = Mid$(buffer$, nullPos + 1) ' Remove title line
    lineCount = lineCount - 1

    ' Extract Exits (second line)
    exitLine$ = Mid$(buffer$, 1, InStr(buffer$, Chr$(0)) - 1) ' Get the first line after title
    buffer$ = Mid$(buffer$, InStr(buffer$, Chr$(0)) + 1) ' Remove exit line from buffer

    ' Parse Exits
    commaPos1 = InStr(exitLine$, ",")
    commaPos2 = InStr(commaPos1 + 1, exitLine$, ",")
    commaPos3 = InStr(commaPos2 + 1, exitLine$, ",")
    If commaPos1 > 0 And commaPos2 > 0 And commaPos3 > 0 Then
        rooms(roomNum).northExit = Val(Left$(exitLine$, commaPos1 - 1))
        rooms(roomNum).southExit = Val(Mid$(exitLine$, commaPos1 + 1, commaPos2 - commaPos1 - 1))
        rooms(roomNum).eastExit = Val(Mid$(exitLine$, commaPos2 + 1, commaPos3 - commaPos2 - 1))
        rooms(roomNum).westExit = Val(Mid$(exitLine$, commaPos3 + 1))
    Else
        Print "Error parsing exits room"; roomNum; ": "; exitLine$: rooms(roomNum).northExit = 0: rooms(roomNum).southExit = 0: rooms(roomNum).eastExit = 0: rooms(roomNum).westExit = 0
    End If

    tempDesc$ = ""
    currentPos = 1
    Do
        ' Find the next line separator (CHR$(0))
        nullPos = InStr(currentPos, buffer$, Chr$(0))

        If nullPos = 0 Then Exit Do ' No more separators found, loop finished

        ' Extract the line segment before the separator
        lineSegment$ = Mid$(buffer$, currentPos, nullPos - currentPos)

        ' Append the line segment to tempDesc$
        If Len(tempDesc$) > 0 Then
            ' Add newline before appending subsequent lines
            tempDesc$ = tempDesc$ + Chr$(13) + Chr$(10) + lineSegment$
        Else
            ' First line doesn't need a preceding newline
            tempDesc$ = lineSegment$
        End If

        ' Move the starting position past the separator for the next search
        currentPos = nullPos + 1
    Loop
    rooms(roomNum).description = tempDesc$
Next roomNum
Close #1

' Load Interactions
Open "interactions.txt" For Input As #2
Line Input #2, firstLine$
MaxInteractions = Val(firstLine$) ' Read the first line as MaxInteractions count
Dim Shared interactions(1 To MaxInteractions) As CommandData
For interactionNum = 1 To MaxInteractions
    buffer$ = ""
    lineCount = 0
    foundStart = 0


    Do While Not EOF(2)
        Line Input #2, currentLine$
        If currentLine$ = "--COMMAND START--" Then
            foundStart = 1
            Exit Do
        End If
    Loop

    If foundStart = 0 Then Print "Error: Start marker interaction"; interactionNum: Close #2: End

    Do While Not EOF(2)
        Line Input #2, currentLine$
        If currentLine$ = "--COMMAND END--" Then Exit Do
        buffer$ = buffer$ + currentLine$ + Chr$(0) ' Use CHR$(0) as line separator
        lineCount = lineCount + 1
    Loop

    If lineCount < 2 Then Print "Error: Missing command/exit for interaction"; interactionNum: Close #2: End

    ' Extract Command (first line)'
    nullPos = InStr(buffer$, Chr$(0))
    interactions(interactionNum).commandString = Left$(buffer$, nullPos - 1)
    buffer$ = Mid$(buffer$, nullPos + 1) ' Remove command line
    lineCount = lineCount - 1

    ' Extract Required Room Number (second line)
    roomLine$ = Mid$(buffer$, 1, InStr(buffer$, Chr$(0)) - 1) ' Get the first line after command
    interactions(interactionNum).requiredRoom = Val(roomLine$) ' Store the required room number
    buffer$ = Mid$(buffer$, InStr(buffer$, Chr$(0)) + 1) ' Remove room line from buffer

    ' Extract Required Item variable name (third line)
    itemLine$ = Mid$(buffer$, 1, InStr(buffer$, Chr$(0)) - 1) ' Get the first line after room
    interactions(interactionNum).requiredItem = itemLine$ ' Store the required item variable name
    buffer$ = Mid$(buffer$, InStr(buffer$, Chr$(0)) + 1) ' Remove item line from buffer

    ' Extract Required Item variable name (third line)
    titleLine$ = Mid$(buffer$, 1, InStr(buffer$, Chr$(0)) - 1) ' Get the first line after room
    interactions(interactionNum).titleLine = titleLine$ ' Store the required item variable name
    buffer$ = Mid$(buffer$, InStr(buffer$, Chr$(0)) + 1) ' Remove item line from buffer

    ' Extract Required Item variable name (third line)
    displayText$ = Mid$(buffer$, 1, InStr(buffer$, Chr$(0)) - 1) ' Get the first line after room
    interactions(interactionNum).displayText = displayText$ ' Store the required item variable name
    buffer$ = Mid$(buffer$, InStr(buffer$, Chr$(0)) + 1) ' Remove item line from buffer
Next interactionNum
Close #2
Print "Loaded "; numInteractions; " interactions."

' === Centered Maze-Madness Title Screen ===
Screen 12
Color 15, 0
Cls

' Calculate vertical centering for a 25-line display, 18-line block
blockHeight = 18
topMargin = (25 - blockHeight) \ 2

For i = 1 To topMargin
    Print
Next i

' ---- Maze border (7 lines, 56 cols) centered at col 12 ----
Print Spc(12); "+------------------------------------------------------+"
Print Spc(12); "|     .        *          .         o         .        |"
Print Spc(12); "|  *       .        *         .         *         .    |"
Print Spc(12); "|     .       *        .         *         .       o   |"
Print Spc(12); "|  *        .         *        .         o        .   *|"
Print Spc(12); "|     .         *        .         .        *        . |"
Print Spc(12); "+------------------------------------------------------+"

' ---- Centered text lines ----
Print
Print Spc(28); "WELCOME, ADVENTURER, TO"
Print
Print Spc(26); "THE LABYRINTH OF TIME'S EDGE"
Print
Print Spc(21); "A Tale of Madness & Mystery Awaits..."
Print
Print Spc(19); "Press <ENTER> to read a story of ADVENTURE"
Print

Do: Loop Until InKey$ <> "" ' single-key advance
' === Story Scroll: Page 1 ===
Cls
Screen 12
Color 15, 0 ' white on black
Print
Print
Print
Print
Print
Print Spc(6); "+" + String$(67, "-") + "+"
Print Spc(6); "�        THE LABYRINTH OF TIME'S EDGE - A SCROLL OF LEGENDS         �"
Print Spc(6); "�" + String$(67, "-") + "�"
Print Spc(6); "�                                                                   �"
Print Spc(6); "�  Summoned by the king's own hand, you stand upon the ancient      �"
Print Spc(6); "�  threshold of Time's Edge, where moonlit arches pulse with        �"
Print Spc(6); "�  starlight, and distant echoes of vanished realms beckon your     �"
Print Spc(6); "�  every step. The air trembles with arcane whispers and the glow   �"
Print Spc(6); "�  of crystal runes guides your path through corridors where shadow �"
Print Spc(6); "�  and wonder entwine. Will you, the king's chosen champion, wield  �"
Print Spc(6); "�  courage as your lantern against the lurking dread, or succumb to �"
Print Spc(6); "�  the labyrinth's living darkness and be lost to time�s embrace?   �"
Print Spc(6); "�                                                                   �"
Print Spc(6); "|" + Space$(67) + "|"
Print Spc(6); "+" + String$(67, "-") + "+"

prompt$ = "[ Press <ENTER> to begin the ADVENTURE... ]"
Print
Print Spc((80 - Len(prompt$)) \ 2); prompt$
Do: Loop Until InKey$ <> ""
Cls

DOOM = Timer(0.1) + GameTime 'change this to to desied time for the game to run

Do
    Cls
    Print ""
    Print ""
    Print ""
    Print "   " + String$(74, "[")
    Print "   �         __/^^^^\__                                    __/^^^^\__       �"
    Print "   �         /  \__/  \                                    /  \__/  \       �"
    Print "   �        |  /\||/\  |                                  |  /\||/\  |      �"
    Print "   �        |  |><><|  |   THE LABYRINTH OF TIME'S EDGE   |  |><><|  |      �"
    Print "   �        |  \____/  |                                  |  \____/  |      �"
    Print "   �         \        /                                    \        /       �"
    Print "   �          \ ____ /                                       \____/         �"
    Print "   " + String$(74, "]")
    Print ""
    Print ""
    If rooms(r).northExit > 0 Then
        CenterPrint ("N")
    Else
        CenterPrint (" ")
    End If
    PartA$ = " "
    PartB$ = " "
    If rooms(r).westExit > 0 Then PartA$ = "W"
    If rooms(r).eastExit > 0 Then PartB$ = "E"
    CenterPrintWithLine (PartA$ + " + " + PartB$)
    If rooms(r).southExit > 0 Then
        CenterPrint ("S")
    Else
        CenterPrint (" ")
    End If
    Print ""
    Print "If you are stuck just type HELP."
    Print
    GoSub ROOM
    GoSub parser
Loop

ROOM:
' Calculate padding for the title line (assuming 80 columns)
titleLen = Len(rooms(r).title)
paddingLen = 80 - 4 - titleLen ' 4 for the "__" at start and end
If paddingLen < 0 Then paddingLen = 0 ' Prevent negative padding

' Print formatted title and description
Print "____"; rooms(r).title; String$(paddingLen, "_") ' Replicates __Title______ format
PrintWrapSafe (rooms(r).description)
Print "________________________________________________________________________________"

Return

parser:
Print "> ";
cmd$ = GrabInput$
cmd$ = LTrim$(RTrim$(UCase$(cmd$)))
' Inline SAVE command
If cmd$ = "SAVE" Then
    Open "SAVEGAME.DAT" For Output As #1
    Print #1, r ' save current room number
    Close #1
    Print "Game saved."
    Do: Loop Until InKey$ <> "" ' pause for keypress
    Return
End If

'Inline LOAD command
If cmd$ = "LOAD" Then
    On Error GoTo NoSave
    Open "SAVEGAME.DAT" For Input As #1
    On Error GoTo 0
    Input #1, r ' restore room number
    Close #1
    Print "Game loaded."
    Do: Loop Until InKey$ <> ""
    Return
    NoSave:
    Print "No save file found."
    Do: Loop Until InKey$ <> ""
    Resume Next
End If
If cmd$ = "END" Or cmd$ = "QUIT" Or cmd$ = "EXIT" Or cmd$ = "Q" Then
    Cls
    Print String$(80, "*")
    Print "*" + String$(78, " ") + "*"
    Print "*  Thank you, brave adventurer, for conquering THE LABYRINTH OF TIME'S EDGE!   *"
    Print "*  Until the shadows awaken once more and untold secrets beckon you back...    *"
    Print "*" + String$(78, " ") + "*"
    Print String$(80, "*")
    End
End If
If cmd$ = "HELP" Or cmd$ = "H" Or cmd$ = "?" Then
    Cls
    Print
    Print String$(79, "_")
    Print "|                                                                             |"
    Print "|  THE LABYRINTH OF TIME'S EDGE � BASIC CONTROLS                              |"
    Print "|                                                                             |"
    Print "|  North, South, East, West    � Move in the available direction              |"
    Print "|  Examine <object>            � Examine an item or feature                   |"
    Print "|  Use <item>                  � Use an item                                  |"
    Print "|  Take <item>                 � Take or move an item                         |"
    Print "|  Talk <character>            � Speak with another character                 |"
    Print "|  Listen                      � Listen for whispers of the unseen            |"
    Print "|  Inventory                   � View your carried items                      |"
    Print "|  Help                        � Show this controls screen                    |"
    Print "|  End                         � Exit the game                                |"
    Print "|                                                                             |"
    Print String$(79, "_")
    Print
    Print "PRESS ANY KEY...": Sleep
    Do: Loop Until InKey$ = ""
End If
If cmd$ = "INVENTORY" Or cmd$ = "INV" Or cmd$ = "ITEMS" Or cmd$ = "I" Then
    Cls
    Print "INVENTORY..."
    Print
    If gotlantern = 1 Then: Print " An old dented tin lantern to vanquish the darkness."
    If gotsword = 1 Then: Print " Crafted out of only the finest steel in the region."
    If gotshard = 1 Then: Print " The Shard of Eternal Light."
    If gotrelic = 1 Then: Print " The Emberheart Relic."
    If gotcrown = 1 Then: Print " The Veilbreaker Crown."
    If gotoryn = 1 Then: Print " The Wyrmblade of Oryn."
    If gottear = 1 Then: Print " The Ashen Tear."
    If gotheart = 1 Then: Print " The Crystal Heart."
    If gotchalice = 1 Then: Print " The Ember Chalice."
    If gotmirror = 1 Then: Print " The Obsidian Mirror."
    If goteternity = 1 Then: Print " The Shield of Eternity."
    If gotgauntlet = 1 Then: Print " The Gauntlet of Dominion."
    If gotamuletofwhispers = 1 Then: Print " The Amulet of Whispers."
    If gotamuletofshadows = 1 Then: Print " The Amulet of Shadow's."
    If gotamuletofthecelestialkey = 1 Then: Print " The Amulet of the Celestial Key."
    If gotamuletofwildsong = 1 Then: Print " The Amulet of Wild Song."
    If gotamuletoftheshiftingsands = 1 Then: Print " The Amulet of the Shifting Sands."
    If gottheechoesoflostages = 1 Then: Print " Book: The Echoes Of Lost Ages."
    If gottheserpentscanticle = 1 Then: Print " Book: The Serpent's Canticle."
    If gotthearchitectsoath = 1 Then: Print " Book: The Architect's Oath."
    If gotthefleshandshadow = 1 Then: Print " Book: Of Flesh and Shadow."
    If gotthelabyrinthsbreath = 1 Then: Print " Book: The Labyrinth's Breath."
    If gotthemoonthatwatches = 1 Then: Print " Book: The Moon That Watches."
    If gotthegildedprison = 1 Then: Print " Book: The Gilded Prison."
    If gottheunwrittentestament = 1 Then: Print " Book: The Unwritten Testament."
    Print
    Print "PRESS ANY KEY..."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If

If cmd$ = "GO NORTH" Or cmd$ = "NORTH" Or cmd$ = "N" Then
    newRoom = rooms(r).northExit
    If newRoom > 0 Then
        r = newRoom
        GoTo moved
    Else
        Print "You can't go that way."
    End If
End If
If cmd$ = "GO EAST" Or cmd$ = "EAST" Or cmd$ = "E" Then
    newRoom = rooms(r).eastExit
    If newRoom > 0 Then
        r = newRoom
        GoTo moved
    Else
        Print "You can't go that way."
    End If
End If
If cmd$ = "GO SOUTH" Or cmd$ = "SOUTH" Or cmd$ = "S" Then
    newRoom = rooms(r).southExit
    If newRoom > 0 Then
        r = newRoom
        GoTo moved
    Else
        Print "You can't go that way."
    End If
End If
If cmd$ = "GO WEST" Or cmd$ = "WEST" Or cmd$ = "W" Then
    newRoom = rooms(r).westExit
    If newRoom > 0 Then
        r = newRoom
        GoTo moved
    Else
        Print "You can't go that way."
    End If
End If


''''''''''''''''''''''''''''''''''''''''''''Take Item Commands
If (cmd$ = "TAKE SHARD") And gotshard = 0 And r = 71 Then
    gotshard = 1
    Print "-You have taken 'The Shard of Eternal Light'."
End If
If (cmd$ = "TAKE RELIC") And gotrelic = 0 And r = 126 Then
    gotrelic = 1
    Print "-You have taken 'The Emberheart Relic'."
End If
If (cmd$ = "TAKE CROWN") And gotcrown = 0 And r = 186 Then
    gotcrown = 1
    Print "-You have taken 'The Veilbreaker Crown'."
End If
If (cmd$ = "TAKE ORYN") And gotoryn = 0 And r = 248 Then
    gotoryn = 1
    Print "-You have taken 'The Wyrmblade of Oryn'."
End If
If (cmd$ = "TAKE TEAR") And gottear = 0 And r = 298 Then
    gottear = 1
    Print "-You have taken 'The Ashen Tear'."
End If
If (cmd$ = "TAKE HEART") And gotheart = 0 And r = 392 Then
    gotheart = 1
    Print "-You have taken 'The Crystal Heart'."
End If
If (cmd$ = "TAKE CHALICE") And gotchalice = 0 And r = 468 Then
    gotchalice = 1
    Print "-You have taken 'The Ember Chalice'."
End If
If (cmd$ = "TAKE MIRROR") And gotmirror = 0 And r = 506 Then
    gotmirror = 1
    Print "-You have taken 'The Obsidian Mirror'."
End If
If (cmd$ = "TAKE SHIELD") And gotshield = 0 And r = 642 Then
    gotshield = 1
    Print "-You have taken 'The Shielf of Eternity'."
End If
If (cmd$ = "TAKE GAUNTLET") And gotgauntlet = 0 And r = 710 Then
    gotgauntlet = 1
    Print "-You have taken 'The Ashen Tear'."
End If
If (cmd$ = "TAKE AMULET OF WHISPERS") And gotamuletofwhispers = 0 And r = 867 Then
    gotamuletofwhispers = 1
    Print "-You have taken 'The Amulet of Whispers'."
End If
If (cmd$ = "TAKE AMULET OF SHADOWS") And gotamuletofshadows = 0 And r = 897 Then
    gotamuletofshadows = 1
    Print "-You have taken 'The Amulet of Shadow's.'"
End If
If (cmd$ = "TAKE AMULET OF THE CELESTIAL KEY") And gotamuletofthecelestialkey = 0 And r = 926 Then
    gotamuletofthecelestialkey = 1
    Print "-You have taken 'The Amulet of the Celestial Key.'"
End If
If (cmd$ = "TAKE AMULET OF WILD SONG") And gotamuletofwildsong = 0 And r = 991 Then
    gotamuletofwildsong = 1
    Print "-You have taken 'The Amulet of Wild Song.'"
End If
If (cmd$ = "TAKE AMULET OF THE SHIFTING SANDS") And gotamuletoftheshiftingsands = 0 And r = 1119 Then
    gotamuletoftheshiftingsands = 1
    Print "-You have taken 'The Amulet of the Shifting Sands.'"
End If
If (cmd$ = "TAKE BOOK") And gottheechoesoflostages = 0 And r = 47 Then
    gottheechoesoflostages = 1
    Print "-You have taken 'The Echoes Of Lost Ages, book.'"
End If
If (cmd$ = "TAKE BOOK") And gottheserpentscanticle = 0 And r = 103 Then
    gottheserpentscanticle = 1
    Print "-You have taken 'The Serpent's Canticle, book.'"
End If
If (cmd$ = "TAKE BOOK") And gotthearchitectsoath = 0 And r = 294 Then
    gotthearchitectsoath = 1
    Print "-You have taken 'The Serpent's Canticle, book.'"
End If
If (cmd$ = "TAKE BOOK") And gotthefleshandshadow = 0 And r = 407 Then
    gotthefleshandshadow = 1
    Print "-You have taken 'Of Flesh And Shadow, book.'"
End If
If (cmd$ = "TAKE BOOK") And gotthelabyrinthsbreath = 0 And r = 669 Then
    gotthelabyrinthsbreath = 1
    Print "-You have taken 'The Labyrinth's Breath, book.'"
End If
If (cmd$ = "TAKE BOOK") And gotthemoonthatwatches = 0 And r = 755 Then
    gotthemoonthatwatches = 1
    Print "-You have taken 'The Moon That Watches, book.'"
End If
If (cmd$ = "TAKE BOOK") And gotthegildedprison = 0 And r = 901 Then
    gotthegildedprison = 1
    Print "-You have taken 'The Gilded Prison, book.'"
End If
If (cmd$ = "TAKE BOOK") And gottheunwrittentestament = 0 And r = 1101 Then
    gottheunwrittentestament = 1
    Print "-You have taken 'The Unwritten Testament, book.'"
End If

' Check custom interactions
For i = 1 To MaxInteractions
    If interactions(i).commandString = cmd$ Then
        ' Check if the interaction is valid for the current room (0 means any room)
        If interactions(i).requiredRoom = -1 Or interactions(i).requiredRoom = r Then
            ' Check if a specific item is required
            Dim hasRequiredItem As Integer
            hasRequiredItem = 1 ' Assume true unless an item is required and not possessed
            If interactions(i).requiredItem <> "noitem" Then
                Select Case interactions(i).requiredItem
                    Case "gotlantern": If gotlantern = 0 Then hasRequiredItem = 0
                    Case "gotsword": If gotsword = 0 Then hasRequiredItem = 0
                    Case "gotshard": If gotshard = 0 Then hasRequiredItem = 0
                    Case "gotrelic": If gotrelic = 0 Then hasRequiredItem = 0
                    Case "gotcrown": If gotcrown = 0 Then hasRequiredItem = 0
                    Case "gotoryn": If gotoryn = 0 Then hasRequiredItem = 0
                    Case "gottear": If gottear = 0 Then hasRequiredItem = 0
                    Case "gotheart": If gotheart = 0 Then hasRequiredItem = 0
                    Case "gotchalice": If gotchalice = 0 Then hasRequiredItem = 0
                    Case "gotmirror": If gotmirror = 0 Then hasRequiredItem = 0
                    Case "gotshield": If gotshield = 0 Then hasRequiredItem = 0
                    Case "gotgauntlet": If gotgauntlet = 0 Then hasRequiredItem = 0
                    Case "gotamuletofwhispers": If gotamuletofwhispers = 0 Then hasRequiredItem = 0
                    Case "gotamuletofshadows": If gotamuletofshadows = 0 Then hasRequiredItem = 0
                    Case "gotamuletofthecelestialkey": If gotamuletofthecelestialkey = 0 Then hasRequiredItem = 0
                    Case "gotamuletofwildsong": If gotamuletofwildsong = 0 Then hasRequiredItem = 0
                    Case "gotamuletoftheshiftingsands": If gotamuletoftheshiftingsands = 0 Then hasRequiredItem = 0
                    Case "gottheechoesoflostages": If gottheechoesoflostages = 0 Then hasRequiredItem = 0
                    Case "gottheserpentscanticle": If gottheserpentscanticle = 0 Then hasRequiredItem = 0
                    Case "gotthearchitectsoath": If gotthearchitectsoath = 0 Then hasRequiredItem = 0
                    Case "gotthefleshandshadow": If gotthefleshandshadow = 0 Then hasRequiredItem = 0
                    Case "gotthelabyrinthsbreath": If gotthelabyrinthsbreath = 0 Then hasRequiredItem = 0
                    Case "gotthemoonthatwatches": If gotthemoonthatwatches = 0 Then hasRequiredItem = 0
                    Case "gotthegildedprison": If gotthegildedprison = 0 Then hasRequiredItem = 0
                    Case "gottheunwrittentestament": If gottheunwrittentestament = 0 Then hasRequiredItem = 0
                    Case Else
                        hasRequiredItem = 0
                        Print "DEBUG: Unrecognized required item variable: "; interactions(i).requiredItem
                End Select
            End If

            If hasRequiredItem = 1 Then
                Cls
                titleLen = Len(interactions(i).titleLine)
                paddingLen = 80 - 4 - titleLen ' 4 for the "__" at start and end
                If paddingLen < 0 Then paddingLen = 0 ' Prevent negative padding
                Print "____"; interactions(i).titleLine; String$(paddingLen, "_")
                PrintWrapSafe (interactions(i).displayText)
                Do: Loop Until InKey$ = ""
                Do: Loop Until InKey$ <> ""
                Exit For ' Exit loop once a valid interaction is found and executed
            End If
        End If
    End If
Next i

moved:
Return

win:
Color 15, 0
Cls
Print "============================================================================="
Print ""
Print "  CONGRATULATIONS, BRAVE ADVENTURER!"
Print ""
Print "  At long last, the final foe lies vanquished and the earth itself trembles"
Print "  in awe of your victory. The swirling portal before you, once a maelstrom of"
Print "  dread, now shimmers with pure, golden light, beckoning you onward."
Print ""
Print "  You step through and find yourself back where your quest began�only the"
Print "  world has been reborn. Streets overflow with jubilant crowds, banners soar"
Print "  on the breeze, and your name rings out in song. The dark reign has fallen,"
Print "  and freedom blossoms across the land."
Print ""
Print "  Congratulations, brave champion. You have restored balance and inscribed"
Print "  your legend into the annals of history."
Print ""
Print "  Thank you for playing THE LABYRINTH OF TIME'S EDGE"
Print ""
Print "    - The Ventureweaver"
Print ""

Do: Loop Until InKey$ <> ""
End

Function GrabInput$
    x = Pos(0)
    y = CsrLin
    maxwidth = _Width - x
    PCopy 0, 1 'make a backup copy of the screen

    Do
        k = _KeyHit
        i$ = InKey$
    Loop Until k = 0 And InKey$ = "" 'clear the keyboard buffer

    Do
        _Limit 30
        PCopy 1, 0
        Locate y, x: Print Userinput$

        k = _KeyHit
        Select Case k
            Case 8
                Userinput$ = Left$(Userinput$, Len(Userinput$) - 1)
            Case 65 To 90, 97 To 122, 32
                Userinput$ = UCase$(Userinput$ + Chr$(k))
        End Select

        timerleft## = (DOOM - Timer(0.1))
        minutes = timerleft## \ 60
        seconds = timerleft## - minutes * 60
        Locate 2, 32: Print Using " [  ####:##  ]"; minutes, seconds
        If timerleft## <= 0 Then GoTo doomed
        _Display

    Loop Until k = 13
    GrabInput$ = Userinput$
    _AutoDisplay
    Exit Function

    doomed:
    Cls
    Print
    Print String$(80, "~")
    Print "                            ***   G A M E   O V E R   ***                         "
    Print String$(80, "~")
    Print
    Print "  The Labyrinth's hungry darkness closes around you, its whispering corridors"
    Print "  claiming your final breath. All that remains are echoes of valor and the"
    Print "  relentless pull of oblivion."
    Print
    Print "       Press [ENTER] to rise again and challenge the shadows once more."
    Print
    Print String$(80, "~")
    _Display
    End
End Function

Sub CenterPrint (Text$)
    StartCol = (80 - Len(Text$)) \ 2
    If StartCol < 1 Then StartCol = 1
    Locate , StartCol
    Print Text$
End Sub

Sub CenterPrintWithLine (Text$) ' This function will print text center with a line on both sides of it ---Like This---
    Print String$(80, "-");
    CenterPrint (Text$)
End Sub

Sub PrintWrapSafe (Text$)
    Dim CurrentPos As Integer
    Dim LineWidth As Integer
    Dim MaxLength As Integer
    Dim CurrentLine As String
    Dim NextWord As String
    Dim WordStart As Integer
    Dim WordEnd As Integer
    Dim PotentialLength As Integer
    Dim FirstWordOnLine As Integer ' Boolean-like flag: 1 = True, 0 = False

    MaxLength = 80 ' Set the desired maximum line length (adjust as needed)
    LineWidth = Len(Text$)
    CurrentPos = 1
    CurrentLine = ""
    FirstWordOnLine = 1 ' True initially, prevents leading space on first line

    While CurrentPos <= LineWidth
        ' --- Step 1: Find the start of the next word (skip spaces) ---
        While CurrentPos <= LineWidth And Mid$(Text$, CurrentPos, 1) = " "
            CurrentPos = CurrentPos + 1
        Wend
        If CurrentPos > LineWidth Then Exit While ' Exit if only trailing spaces were left

        WordStart = CurrentPos

        ' --- Step 2: Find the end of the current word ---
        ' Scan until the next space or the end of the entire text string
        WordEnd = WordStart
        While WordEnd <= LineWidth And Mid$(Text$, WordEnd, 1) <> " "
            WordEnd = WordEnd + 1
        Wend
        ' WordEnd now points AT the space after the word, or just PAST the end of Text$
        WordEnd = WordEnd - 1 ' Adjust to point to the last character OF the word

        ' --- Step 3: Extract the word ---
        If WordEnd >= WordStart Then
            NextWord = Mid$(Text$, WordStart, WordEnd - WordStart + 1)
        Else
            ' This case should ideally not be reached if logic is sound
            Exit While
        End If

        ' --- Step 4: Check if the extracted word fits on the current line ---
        If FirstWordOnLine = 1 Then
            ' If it's the first word, it just needs to fit by itself
            PotentialLength = Len(NextWord)
        Else
            ' Otherwise, need space for current line, a space, and the new word
            PotentialLength = Len(CurrentLine) + 1 + Len(NextWord)
        End If

        If PotentialLength <= MaxLength Then
            ' --- Word Fits: Append it to the current line ---
            If FirstWordOnLine = 1 Then
                CurrentLine = NextWord
                FirstWordOnLine = 0 ' It's no longer the first word for the next check
            Else
                CurrentLine = CurrentLine + " " + NextWord
            End If
            ' Advance position past the word we just processed
            CurrentPos = WordEnd + 1
        Else
            ' --- Word Does NOT Fit: Print the current line and start new one ---
            Print CurrentLine

            ' The word that didn't fit becomes the start of the new line
            CurrentLine = NextWord
            FirstWordOnLine = 0 ' It's the first word added, but don't add space before next

            ' Handle edge case: A single word is longer than MaxLength
            ' In this simple version, it will be printed on its own line, exceeding MaxLength.
            ' More complex logic could break the word here if needed.
            If Len(CurrentLine) > MaxLength Then
                ' PRINT "*** Warning: Word exceeds MaxLength ***" ' Optional warning
            End If

            ' Advance position past the word we just processed
            CurrentPos = WordEnd + 1
        End If

    Wend ' Loop back to process the next word

    ' --- After the loop, print any remaining text in the CurrentLine buffer ---
    If Len(CurrentLine) > 0 Then
        Print CurrentLine
    End If

End Sub

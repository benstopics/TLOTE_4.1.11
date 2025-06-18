Const Game_Name = "The Labyrinth Of Time's Edge"

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

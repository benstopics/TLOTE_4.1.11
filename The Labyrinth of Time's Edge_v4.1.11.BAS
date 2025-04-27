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

Const MaxRooms = 1840

Type RoomData
    title As String
    description As String
    northExit As Integer
    southExit As Integer
    eastExit As Integer
    westExit As Integer
End Type
Dim Shared rooms(1 To MaxRooms) As RoomData

Open "rooms.txt" For Input As #1
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
Print Spc(6); "¦        THE LABYRINTH OF TIME'S EDGE - A SCROLL OF LEGENDS         ¦"
Print Spc(6); "¦" + String$(67, "-") + "¦"
Print Spc(6); "¦                                                                   ¦"
Print Spc(6); "¦  Summoned by the king's own hand, you stand upon the ancient      ¦"
Print Spc(6); "¦  threshold of Time's Edge, where moonlit arches pulse with        ¦"
Print Spc(6); "¦  starlight, and distant echoes of vanished realms beckon your     ¦"
Print Spc(6); "¦  every step. The air trembles with arcane whispers and the glow   ¦"
Print Spc(6); "¦  of crystal runes guides your path through corridors where shadow ¦"
Print Spc(6); "¦  and wonder entwine. Will you, the king's chosen champion, wield  ¦"
Print Spc(6); "¦  courage as your lantern against the lurking dread, or succumb to ¦"
Print Spc(6); "¦  the labyrinth's living darkness and be lost to time’s embrace?   ¦"
Print Spc(6); "¦                                                                   ¦"
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
    Print "   ¦         __/^^^^\__                                    __/^^^^\__       ¦"
    Print "   ¦         /  \__/  \                                    /  \__/  \       ¦"
    Print "   ¦        |  /\||/\  |                                  |  /\||/\  |      ¦"
    Print "   ¦        |  |><><|  |   THE LABYRINTH OF TIME'S EDGE   |  |><><|  |      ¦"
    Print "   ¦        |  \____/  |                                  |  \____/  |      ¦"
    Print "   ¦         \        /                                    \        /       ¦"
    Print "   ¦          \ ____ /                                       \____/         ¦"
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
    Print "|  THE LABYRINTH OF TIME'S EDGE – BASIC CONTROLS                              |"
    Print "|                                                                             |"
    Print "|  North, South, East, West    – Move in the available direction              |"
    Print "|  Examine <object>            – Examine an item or feature                   |"
    Print "|  Use <item>                  – Use an item                                  |"
    Print "|  Take <item>                 – Take or move an item                         |"
    Print "|  Talk <character>            – Speak with another character                 |"
    Print "|  Listen                      – Listen for whispers of the unseen            |"
    Print "|  Inventory                   – View your carried items                      |"
    Print "|  Help                        – Show this controls screen                    |"
    Print "|  End                         – Exit the game                                |"
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

'''ITEMS
If (cmd$ = "EXAMINE LANTERN") And gotlantern = 1 Then
    Cls
    Print "__Lantern______________________________________________________________________"
    Print " The lantern is a sturdy, weather-beaten device that has clearly seen better   "
    Print " days. Its metal frame is scarred with scratches and dents, evidence of        "
    Print " countless journeys through dark places. The once-bright brass has dulled to a "
    Print " murky brown, and the glass panels, though mostly intact, are chipped and      "
    Print " smudged with soot. A faint rattle escapes from within as you shift it in your "
    Print " grip, hinting at the loose components that still somehow cling together.      "
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SWORD") And gotsword = 1 Then
    Cls
    Print "__Sword________________________________________________________________________"
    Print " The sword is a sturdy, well-worn blade with a history etched into every       "
    Print " scratch and nick along its length. The steel has lost its original sheen, now "
    Print " dulled to a gray that seems to absorb the flickering lantern light rather than"
    Print " reflect it. The edge, though far from pristine, is still sharp enough to cut  "
    Print " through the vines and overgrowth that choke the temple's forgotten pathways.  "
    Print " Patches of faint rust mark the blade near the hilt, hints of past battles and "
    Print " harsh conditions endured.                                                     "
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SHARD") And gotshard = 1 Then
    Cls
    Print "__The Shard Of Eternal Light___________________________________________________"
    Print " A crystal imbued with the purest light of creation, capable of piercing       "
    Print " through the darkness of Malthera's magic."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE RELIC") And gotrelic = 1 Then
    Cls
    Print "__The Emberheart Relic_________________________________________________________"
    Print " A flaming jewel from the dragon's own chest, granting the wielder the power of"
    Print " life and death for a single moment."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CROWN") And gotcrown = 1 Then
    Cls
    Print "__The Veilbreaker Crown________________________________________________________"
    Print " An ancient circlet forged from starlight, allowing the wearer to enter the"
    Print " witch's hidden realm and shatter her protective barriers."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ORYN") And gotoryn = 1 Then
    Cls
    Print "__The Wyrmblade Of Oryn________________________________________________________"
    Print " A legendary sword crafted from one of the dragon's scales, capable of severing"
    Print " the witch's connection to the dark forces."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE TEAR") And gottear = 1 Then
    Cls
    Print "__The Ashen Tear_______________________________________________________________"
    Print " A single tear shed by the dragon in sorrow, crystallized into a gem that holds"
    Print " the power to purify Malthera's cursed soul."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE HEART") And gotheart = 1 Then
    Cls
    Print "__The Crystal Heart____________________________________________________________"
    Print " A glowing heart-shaped crystal encased in ice. This treasure radiates warmth"
    Print " despite its surroundings and is said to be the core of an ancient winter"
    Print " spirit."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CHALICE") And gotchalice = 1 Then
    Cls
    Print "__The Ember Chalice____________________________________________________________"
    Print " A goblet forged from molten lava, still warm to the touch. The chalice brims"
    Print " with liquid fire that never spills."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MIRROR") And gotmirror = 1 Then
    Cls
    Print "__The Obsidian Mirror__________________________________________________________"
    Print " A dark, polished mirror framed with twisted silver. Staring into it reveals"
    Print " hidden truths-and sometimes, visions of the past."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SHIELD") And gotshield = 1 Then
    Cls
    Print "__The Shield Of Eternity_______________________________________________________"
    Print " A radiant shield forged by celestial smiths, its surface shimmers with images"
    Print " of past, present, and future battles. Indestructible and imbued with"
    Print " protective magic, it is said to repel even the strongest of curses."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GAUNTLET") And gotgauntlet = 1 Then
    Cls
    Print "__The Gauntlet Of Dominion_____________________________________________________"
    Print " The Gauntlet of Dominion is a massive, intricately crafted glove forged from"
    Print " blackened steel and encrusted with glowing red gemstones that pulse like a"
    Print " heartbeat."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE AMULET OF WHISPERS") And gotamuletofwhispers = 1 Then
    Cls
    Print "__Amulet of Whispers___________________________________________________________"
    Print " A silver pendant shaped like an ear, with faintly glowing runes carved along"
    Print " its edges."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE AMULET OF SHADOWS") And gotamuletofshadows = 1 Then
    Cls
    Print "__Amulet of Shadow's___________________________________________________________"
    Print " A black obsidian amulet that seems to absorb light around it, making it"
    Print " faintly cold to the touch."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE AMULET OF THE CELESTIAL KEY") And gotamuletofthecelestialkey = 1 Then
    Cls
    Print "__Amulet of the Celestial Key__________________________________________________"
    Print " A golden amulet shaped like a star, with a small crystal in the center that"
    Print " glows when near hidden doors or magical locks."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE AMULET OF WILD SONG") And gotamuletofwildsong = 1 Then
    Cls
    Print "__Amulet of Wild Song__________________________________________________________"
    Print " A wooden amulet carved into the shape of a bird in flight, emitting faint,"
    Print " melodic chirps when held."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE AMULET OF THE SHIFTING SANDS") And gotamuletoftheshiftingsands = 1 Then
    Cls
    Print "__Amulet of the Shifting Sands_________________________________________________"
    Print " A glass vial on a chain, containing a swirling miniature sandstorm that"
    Print " changes color with time."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BOOK ONE") And gottheechoesoflostages = 1 Then
    Cls
    Print "__Book: The Echoes Of Lost Ages________________________________________________"
    Print " A fragile tome detailing myths of civilizations that vanished overnight"
    Print " paralleling the temple's fate with unsettling precision."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ THE ECHOES OF LOST AGES") And gottheechoesoflostages = 1 Then
    Cls
    Print "__Book: The Echoes Of Lost Ages________________________________________________"
    Print " The masses of the world saw only what their greed allowed, for avarice is ever"
    Print " mankind's downfall. Let it be known that on this day, the 24th of Giloh, 2108,"
    Print " the people shall forever be ushered into a realm of true spiritual light."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BOOK TWO") And gottheserpentscanticle = 1 Then
    Cls
    Print "__Book: The Serpent's Canticle_________________________________________________"
    Print " Bound in cracked leather, this book contains hymns and warnings of a forgotten"
    Print " god-one whose name was erased from time."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ THE SERPENTS CANTICLE") And gottheserpentscanticle = 1 Then
    Cls
    Print "__Book: The Serpent's Canticle_________________________________________________"
    Print " The guidance of life flows from the wisdom of our god, for she will shield us"
    Print " from the grasp of the dead. As we wander this world, we must only speak the"
    Print " sacred words when asked."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BOOK THREE") And gotthearchitectsoath = 1 Then
    Cls
    Print "__Book: The Architect's Oath___________________________________________________"
    Print " A journal filled with blueprints from the temple's builder, hinting at hidden"
    Print " chambers and passageways long sealed by time."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ THE ARCHITECTS OATH") And gotthearchitectsoath = 1 Then
    Cls
    Print "__Book: The Architect's Oath___________________________________________________"
    Print " The aged pages hold intricate sketches of corridors and secrets woven into the"
    Print " walls."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BOOK FOUR") And gotthefleshandshadow = 1 Then
    Cls
    Print "__Book: Of Flesh and Shadow____________________________________________________"
    Print " A disturbing study of beings that exist between moments, slipping through"
    Print " cracks in time, waiting to return."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ OF FLESH AND SHADOW") And gotthefleshandshadow = 1 Then
    Cls
    Print "__Book: Of Flesh And Shadow____________________________________________________"
    Print " The fallen order's priests have uncovered a strange ability-to drift between"
    Print " timelines, becoming lost within the sacred gaps of reality itself."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BOOK FIVE") And gotthelabyrinthsbreath = 1 Then
    Cls
    Print "__Book: The Labyrinth's Breath_________________________________________________"
    Print " A guide written by a long-dead explorer who mapped the temple's shifting"
    Print " corridors, filled with notes on traps, illusions, and unseen paths."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ THE LABYRINTHS BREATH") And gotthelabyrinthsbreath = 1 Then
    Cls
    Print "__Book: The Labyrinth's Breath_________________________________________________"
    Print " The text is written in a strange language. You can make out only a few words."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BOOK SIX") And gotthemoonthatwatches = 1 Then
    Cls
    Print "__Book: The Moon That Watches__________________________________________________"
    Print " A collection of dream records from past temple visitors, some written in"
    Print " handwriting eerily similar to your own."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ THE MOON THAT WATCHES") And gotthemoonthatwatches = 1 Then
    Cls
    Print "__Book: The Moon That Watches__________________________________________________"
    Print " 13th of Filhmeh, 2106. The entrance to the realm of the gods is prophesied to"
    Print " be created by a child. We have found the child and sent him to the temple in"
    Print " the hopes of making contact...That is where the last entry ends."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BOOK SEVEN") And gotthegildedprison = 1 Then
    Cls
    Print "__Book: The Gilded Prison______________________________________________________"
    Print " A philosophical treatise on time itself-questioning whether it is a river, a"
    Print " cage, or a living thing that feeds on memory."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ THE MOON THAT WATCHES") And gotthegildedprison = 1 Then
    Cls
    Print "__Book: The Gilded Prison______________________________________________________"
    Print " The pages seem to be blank."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BOOK EIGHT") And gottheunwrittentestament = 1 Then
    Cls
    Print "__Book: The Unwritten Testament________________________________________________"
    Print " A book with empty pages, save for a single message."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ THE MOON THAT WATCHES") And gottheunwrittentestament = 1 Then
    Cls
    Print "__Book: The Unwritten Testament________________________________________________"
    Print " You will finish what I could not. Upon touching it, you feel as though you've"
    Print " written in it before."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If

'''Objects
If (cmd$ = "EXAMINE STONE STATUE") And r = 13 Then
    Cls
    Print "__Stone Statue_________________________________________________________________"
    Print " Before you stands an imposing eight-foot stone statue. With a sword gripped in"
    Print " one hand and a lantern held aloft in the other, this great hero once saved the"
    Print " village in a time long past."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CART") And r = 18 Then
    Cls
    Print "__Cart_________________________________________________________________________"
    Print " An old, decrepit pushcart, now used to carry the remnants of someone's life."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE RUBBLE") And r = 19 Then
    Cls
    Print "__Rubble_______________________________________________________________________"
    Print " A scattered pile of stones and other debris rests at your feet, remnants of a"
    Print " structure long since forgotten."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STONE BOWLS") And r = 27 Then
    Cls
    Print "__Stone Bowls__________________________________________________________________"
    Print " Large, hand-carved bowls hold a mixture of fruits and vegetables-an offering"
    Print " to the gods."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TAKE OFFERINGS") And r = 27 Then
    Cls
    Print "__Stone Bowls__________________________________________________________________"
    Print " No adventurer with any respect for the unknown would dare take an offering"
    Print " meant for the divine."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE LUMIRATH CAVE") And r = 28 Then
    Cls
    Print "__Lumirath Cave________________________________________________________________"
    Print " A mystical cavern carved into the Earth by the hands of the divine, its walls"
    Print " whispering secrets of creation."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CEMETERY GATE") And r = 32 Then
    Cls
    Print "__Cemetery Gate________________________________________________________________"
    Print " This rusted gate stands as a somber reminder of what remains when all life has"
    Print " faded from the village."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BRIDGE") And r = 40 Then
    Cls
    Print "__Bridge_______________________________________________________________________"
    Print " An elegant bridge, crafted by master builders of centuries past, spans the"
    Print " divide."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE HIDDEN DOOR") And r = 58 Then
    Cls
    Print "__Hidden Door__________________________________________________________________"
    Print " Crafted from wood and stone, the hidden door reveals itself to you, a"
    Print " testament to masterful craftsmanship."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GOLDEN STATUE") And r = 60 Then
    Cls
    Print "__Golden Statue________________________________________________________________"
    Print " Towering above you, this statue, cast in solid gold, stands as a gleaming"
    Print " tribute to the glory of ages past."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "CONVERSATION") And r = 66 Then
    Cls
    Print "__Conversation_________________________________________________________________"
    Print " A hushed conversation unfolds about a plan to escape. Fear grips them, for"
    Print " they dread joining the others lost within the labyrinth."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MOTHRAT NEST") And r = 71 Then
    Cls
    Print "__Mothrat Nest_________________________________________________________________"
    Print " An alien-like nest radiates intense heat, making you feel as though you're"
    Print " trapped in an oven."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ MESSAGE") And r = 72 Then
    Cls
    Print "__Message______________________________________________________________________"
    Print " The message reads as a sharp insult to the King's family-a brazen act of"
    Print " defiance."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SILVER BOWL") And r = 88 Then
    Cls
    Print "__Silver Bowl__________________________________________________________________"
    Print " A bowl of exquisite craftsmanship, made from the finest silver by a master"
    Print " silversmith."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TEMPLE OF SOLACE") And r = 90 Then
    Cls
    Print "__Temple Of Solace_____________________________________________________________"
    Print " A sanctuary hewn from stone by miners, this temple is said to lead to the"
    Print " doorway of salvation."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STATUE") And r = 92 Then
    Cls
    Print "__Statue_______________________________________________________________________"
    Print " The statue of Saint Lubok watches over travelers within the realm of light,"
    Print " offering solace to the weary."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "PRAY") And r = 92 Then
    Cls
    Print "__Praying______________________________________________________________________"
    Print " You utter a quick prayer in a nearly forgotten tongue, its words resonating"
    Print " faintly in the silence."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BED") And r = 93 Then
    Cls
    Print "__Bed__________________________________________________________________________"
    Print " A simple bed made of straw and stone offers a stark but functional place to"
    Print " rest."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "SLEEP IN BED") And r = 93 Then
    Cls
    Print "__Sleeping_____________________________________________________________________"
    Print " You drift into a deep slumber. The burdens of the world fade, and for the"
    Print " first time in ages, you sleep in peace."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PORTAITS") And r = 94 Then
    Cls
    Print "__Portraits____________________________________________________________________"
    Print " Moments captured in history, these portraits are vivid reminders of a world"
    Print " long gone, immortalized on canvas."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE URNS") And r = 97 Then
    Cls
    Print "__Urns_________________________________________________________________________"
    Print " These urns hold the remains of high-ranking officials from the King's Guard,"
    Print " their legacies reduced to ashes."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "OPEN URNS") And r = 97 Then
    Cls
    Print "__Urns_________________________________________________________________________"
    Print " You find nothing but ashes, a quiet reminder of the impermanence of power."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE KITCHEN") And r = 99 Then
    Cls
    Print "__Portraits____________________________________________________________________"
    Print " A modest kitchen where meals are prepared, its simplicity speaks of humble"
    Print " living."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE INGREDIENTS") And r = 99 Then
    Cls
    Print "__Ingredients__________________________________________________________________"
    Print " A collection of freshly picked herbs and vegetables lies neatly arranged."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STEW") And r = 99 Then
    Cls
    Print "__Stew_________________________________________________________________________"
    Print " A stew simmers over the fire, its savory aroma stirring thoughts of home."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EAT STEW") And r = 99 Then
    Cls
    Print "__Stew_________________________________________________________________________"
    Print " You take up a wooden spoon, blow gently on the steaming broth, and savor the"
    Print " flavorful mix."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ANCIENT SCROLLS") And r = 101 Then
    Cls
    Print "__Ancient Scrolls______________________________________________________________"
    Print " Old scrolls filled with the sacred knowledge of ancient worshippers."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ ANCIENT SCROLLS") And r = 101 Then
    Cls
    Print "__Ancient Scrolls______________________________________________________________"
    Print " The text is written in an ancient language, indecipherable without a glyph"
    Print " reader."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ANCIENT TEXTS") And r = 103 Then
    Cls
    Print "__Ancient Texts________________________________________________________________"
    Print " Timeworn books bound in cracked leather, their pages yellowed with age."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ ANCIENT TEXTS") And r = 103 Then
    Cls
    Print "__Ancient Texts________________________________________________________________"
    Print " The symbols are incomprehensible without the aid of a glyph reader."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SYMBOLS") And r = 103 Then
    Cls
    Print "__Symbols______________________________________________________________________"
    Print " Strange symbols adorn the walls, telling a story lost to time."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CELLS") And r = 106 Then
    Cls
    Print "__Cells________________________________________________________________________"
    Print " Empty prison cells, their stone walls echoing the absence of life."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CRATES") And r = 109 Then
    Cls
    Print "__Crates_______________________________________________________________________"
    Print " Dust-covered wooden crates, draped in cobwebs, sit neglected in the corner."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "OPEN CRATE") And r = 109 Then
    Cls
    Print "__Crates_______________________________________________________________________"
    Print " The crates are disappointingly empty, their contents long gone."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BOOKS") And r = 111 Then
    Cls
    Print "__Books________________________________________________________________________"
    Print " A collection of ancient books, written in a time when the world was different,"
    Print " containing the secrets of the ancients."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ BOOKS") And r = 111 Then
    Cls
    Print "__Books________________________________________________________________________"
    Print " The pages describe a doorway to the outer realm, shrouded in mystery and"
    Print " wonder."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SCROLLS") And r = 111 Then
    Cls
    Print "__Scrolls______________________________________________________________________"
    Print " Fragile scrolls, aged and brittle, crumble at the slightest touch."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TOUCH SCROLLS") And r = 111 Then
    Cls
    Print "__Scrolls______________________________________________________________________"
    Print " As your fingers graze the parchment, it disintegrates into dust, lost forever."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BANNERS") And r = 112 Then
    Cls
    Print "__Banners______________________________________________________________________"
    Print " Faded and weathered banners bear the crest of the King's family, their glory"
    Print " now a distant memory."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GRAVE STONES") And r = 118 Then
    Cls
    Print "__Grave Stones_________________________________________________________________"
    Print " Many hand-carved stones stand solemnly, marking the final resting places of"
    Print " the departed."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ GRAVE STONES") And r = 118 Then
    Cls
    Print "__Grave Stones_________________________________________________________________"
    Print " The inscriptions are written in a language unfamiliar to you, their secrets"
    Print " lost to time."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE HEAD STONES") And r = 122 Then
    Cls
    Print "__Head Stones__________________________________________________________________"
    Print " Each headstone is uniquely designed, shaped by the wishes of the grieving"
    Print " families who left their mark."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ HEAD STONES") And r = 122 Then
    Cls
    Print "__Head Stones__________________________________________________________________"
    Print " The names and epitaphs are etched in a language you cannot decipher."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE APPLE TREE") And r = 126 Then
    Cls
    Print "__Apple Tree___________________________________________________________________"
    Print " The tree stands in full bloom, its vibrant blossoms a poignant reminder of"
    Print " life's enduring beauty amidst mortality."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FUNERAL SERVICE") And r = 128 Then
    Cls
    Print "__Funeral Service______________________________________________________________"
    Print " A small group gathers somberly, witnessing the descent of a casket into the"
    Print " earth."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "OBSERVE") And r = 128 Then
    Cls
    Print "__Observing____________________________________________________________________"
    Print " You watch as mourners bow their heads in prayer, offering farewells to their"
    Print " loved one."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WILLOW TREE") And r = 132 Then
    Cls
    Print "__Willow Tree__________________________________________________________________"
    Print " This ancient willow stretches skyward, nourished by the memories and remains"
    Print " of the departed beneath its roots."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BRIDGE") And r = 138 Then
    Cls
    Print "__Bridge_______________________________________________________________________"
    Print " A sturdy wooden bridge spans the area, a testament to the craftsmanship and"
    Print " resilience of the living."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE OPEN GRAVE") And r = 142 Then
    Cls
    Print "__Open Grave___________________________________________________________________"
    Print " An ominous, empty grave yawns before you, its purpose yet to be fulfilled."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GRAVE MARKER") And r = 143 Then
    Cls
    Print "__Grave Marker_________________________________________________________________"
    Print " An old granite slab, weathered by time, bears no readable name-the identity of"
    Print " the deceased now forgotten."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE OWL") And r = 143 Then
    Cls
    Print "__Owl__________________________________________________________________________"
    Print " A striking bird resembling a small barn owl perches nearby, its mystical eyes"
    Print " gleaming with untold wisdom."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BRIDGE") And r = 138 Then
    Cls
    Print "__Bridge_______________________________________________________________________"
    Print " A sturdy wooden bridge spans the area, a testament to the craftsmanship and"
    Print " resilience of the living."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE OPEN GRAVE") And r = 142 Then
    Cls
    Print "__Open Grave___________________________________________________________________"
    Print " An ominous, empty grave yawns before you, its purpose yet to be fulfilled."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GRAVE MARKER") And r = 143 Then
    Cls
    Print "__Grave Marker_________________________________________________________________"
    Print " An old granite slab, weathered by time, bears no readable name-the identity of"
    Print " the deceased now forgotten."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE OWL") And r = 143 Then
    Cls
    Print "__Owl__________________________________________________________________________"
    Print " A striking bird resembling a small barn owl perches nearby, its mystical eyes"
    Print " gleaming with untold wisdom."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BROKEN SHOVEL") And r = 145 Then
    Cls
    Print "__Broken Shovel________________________________________________________________"
    Print " The shattered remains of a wooden-handled shovel lie discarded, snapped"
    Print " clean at the center."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FLOWER") And r = 149 Then
    Cls
    Print "__Flower_______________________________________________________________________"
    Print " A single red flower rests delicately before you, its waxy petals almost too"
    Print " perfect to be real."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE TOY") And r = 149 Then
    Cls
    Print "__Toy__________________________________________________________________________"
    Print " An old wooden horse, carved from a single block and painted with rudimentary"
    Print " materials, stands as a relic of simpler times."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ORBS OF LIGHT") And r = 154 Then
    Cls
    Print "__Orbs of Light________________________________________________________________"
    Print " Ephemeral orbs of light flicker and drift, as though glimpses into a forgotten"
    Print " era."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FIRE") And r = 158 Then
    Cls
    Print "__Fire_________________________________________________________________________"
    Print " A small fire crackles softly, its embers glowing from what seems like an"
    Print " eternal burn."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE RABBIT") And r = 158 Then
    Cls
    Print "__Rabbit_______________________________________________________________________"
    Print " Above the fire hangs a skewer of rabbit meat, slow-cooking over the embers."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EAT RABBIT") And r = 158 Then
    Cls
    Print "__Rabbit Meat__________________________________________________________________"
    Print " It's unwise to take what clearly belongs to someone else."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SMALL BONES") And r = 159 Then
    Cls
    Print "__Rabbit Bones_________________________________________________________________"
    Print " A scattering of small bones lies abandoned, the remnants of a meal once"
    Print " enjoyed."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE JEWELRY") And r = 164 Then
    Cls
    Print "__Jewelry______________________________________________________________________"
    Print " A collection of tarnished necklaces and bracelets, once worn by the departed,"
    Print " now rests here."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE DISTURBED GRAVES") And r = 165 Then
    Cls
    Print "__Disturbed Graves_____________________________________________________________"
    Print " The soil around these graves has been recently churned, with scattered piles"
    Print " hinting at foul deeds."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GRAVE") And r = 170 Then
    Cls
    Print "__Grave________________________________________________________________________"
    Print " This grave shows clear signs of desecration, its soil disturbed by hands with"
    Print " dark intent."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE TABLES") And r = 174 Then
    Cls
    Print "__Tables_______________________________________________________________________"
    Print " Gruesome remains lie scattered across wooden tables, their blood-stained"
    Print " surfaces bearing witness to grisly deeds."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ALTAR") And r = 175 Then
    Cls
    Print "__Altar________________________________________________________________________"
    Print " A weathered stone altar, its surface etched with the markings of a forgotten"
    Print " people, stands solemn and foreboding."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PORTRAITS") And r = 177 Then
    Cls
    Print "__Portraits____________________________________________________________________"
    Print " The walls are adorned with hand-painted portraits, each depicting notable"
    Print " locations from across the kingdom. One showcases the shadowy depths of the"
    Print " High Point Forest, where sunlight never touches the ground. Another captures"
    Print " the chilling expanse of the Lake of the Hive, its icy waters shrouded in"
    Print " mystery."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "HIGH POINT FOREST") And r = 177 Then
    Cls
    Print "__High Point Forest____________________________________________________________"
    Print " A place of eternal twilight, the High Point Forest is so densely packed with"
    Print " ancient trees that the sun's rays never penetrate. Shadows twist and turn in"
    Print " this dark, foreboding woodland, cloaking its secrets in perpetual darkness."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "LAKE OF THE HIVE") And r = 177 Then
    Cls
    Print "__Lake Of The Hive_____________________________________________________________"
    Print " This expansive lake is so frigid that its waters seem perpetually on the brink"
    Print " of freezing. Local legends speak of the Merkahns, enigmatic beings who are"
    Print " said to dwell near its icy shores, their secrets hidden in the depths."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CREST") And r = 184 Then
    Cls
    Print "__Crest________________________________________________________________________"
    Print " Prominently displayed on the wall, the royal family's crest emanates a sense"
    Print " of authority and tradition. A shield bearing intricate heraldry is crossed by"
    Print " spears, their shafts glowing with an amber-like hue that seems almost alive in"
    Print " the flickering light."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE THRONE") And r = 186 Then
    Cls
    Print "__Throne_______________________________________________________________________"
    Print " Standing an imposing twelve feet tall, the throne is a testament to the"
    Print " craftsmanship of generations past. Carved from the finest wood and adorned"
    Print " with gold accents, it is upholstered in luxurious red fabric, still radiant"
    Print " with the dignity of its storied history."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE HUSHED TONES") And r = 188 Then
    Cls
    Print "__Hushed Tones_________________________________________________________________"
    Print " The chamber hums with quiet, urgent whispers. Small groups converse in low"
    Print " tones, casting wary glances toward the King's loyal supporters. Each word is"
    Print " measured, every sentence weighed against the risk of discovery."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PAINTINGS") And r = 195 Then
    Cls
    Print "__Paintings____________________________________________________________________"
    Print " Oil-painted portraits of long-deceased royals hang solemnly on the walls,"
    Print " their eyes seemingly following your every movement. Each painting serves as a"
    Print " silent reminder of the family's storied history and the weight of their"
    Print " legacy."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE OLD BOOKS") And r = 205 Then
    Cls
    Print "__Old Books____________________________________________________________________"
    Print " The tables are strewn with old, leather-bound tomes, their pages yellowed and"
    Print " fragile with age. These books, relics of a desperate past, hold fragments of"
    Print " knowledge-a glimmer of hope amidst the surrounding despair."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ OLD BOOKS") And r = 205 Then
    Cls
    Print "__Old Books____________________________________________________________________"
    Print " You carefully pick up a crumbling volume and leaf through its delicate pages."
    Print " It recounts a fleeting encounter with the tribes that once roamed this cursed"
    Print " land, offering little more than fragmented tales of survival and conflict."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BEAMS") And r = 213 Then
    Cls
    Print "__Beams________________________________________________________________________"
    Print " The room's ancient wooden beams, weakened and rotted by years of exposure,"
    Print " have succumbed to time. They now lie scattered and broken, a stark reminder of"
    Print " the relentless decay and fragility of even the sturdiest structures."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CRATES") And r = 229 Then
    Cls
    Print "__Crates_______________________________________________________________________"
    Print " A stack of old sealed-off crates, covered in a layer of dust."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BEDS") And r = 230 Then
    Cls
    Print "__Beds_________________________________________________________________________"
    Print " Old hay-filled beds that have been forgotten."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "SLEEP") And r = 230 Then
    Cls
    Print "__Sleep________________________________________________________________________"
    Print " Best not to. You have an adventure to go on."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FIREPIT") And r = 241 Then
    Cls
    Print "__Firepit______________________________________________________________________"
    Print " Soot-stained stones are all you see."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STONE") And r = 244 Then
    Cls
    Print "__Stone________________________________________________________________________"
    Print " You look over the edge to see just where the stone fell, but it's lost in the"
    Print " brush and trees."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SCRATCHES") And r = 247 Then
    Cls
    Print "__Scratches____________________________________________________________________"
    Print " Many scratches scar the rocks. Just the thought of what caused this sends"
    Print " shivers down your spine."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MESSAGE") And r = 250 Then
    Cls
    Print "__Message______________________________________________________________________"
    Print " A message scrawled in the ash from the firepit by someone in a time of panic."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ MESSAGE") And r = 250 Then
    Cls
    Print "__Message______________________________________________________________________"
    Print " It reads, We are doomed."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE LOOKOUT POINT") And r = 251 Then
    Cls
    Print "__Lookout Point________________________________________________________________"
    Print " You stand before the lookout point and see, off in the distance, the clearing"
    Print " to the mighty forest. From that point, there is a majestic mountain range."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BEDS") And r = 291 Then
    Cls
    Print "__Beds_________________________________________________________________________"
    Print " Old beds, untouched by the hands of time, remain here as silent witnesses to"
    Print " the years gone by."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "SLEEP") And r = 291 Then
    Cls
    Print "__Beds_________________________________________________________________________"
    Print " You lay down and close your eyes. The world around you spins, dissolving into"
    Print " an endless void of darkness. Suddenly, the piercing sound of screams jolts you"
    Print " awake."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WOODEN DISHES") And r = 292 Then
    Cls
    Print "__Wooden Dishes________________________________________________________________"
    Print " Roughly carved wooden dishes lie scattered about, fashioned from whatever"
    Print " materials could be scavenged."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STATUES") And r = 307 Then
    Cls
    Print "__Statues of Fallen Gods_______________________________________________________"
    Print " These towering statues loom over you, depicting the gods who once shaped all"
    Print " life within this realm. Their grandeur speaks of an age long past."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MUSHROOMS") And r = 324 Then
    Cls
    Print "__Mushrooms____________________________________________________________________"
    Print " A foul smell of decay emanates from the mushrooms and slime, filling you with"
    Print " unease and a sense of foreboding."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PORTAL") And r = 355 Then
    Cls
    Print "__Portal_______________________________________________________________________"
    Print " The portal looms before you, towering overhead like a blurry, shifting mirror"
    Print " that distorts reality."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STATUES") And r = 359 Then
    Cls
    Print "__Statues______________________________________________________________________"
    Print " Weathered statues, crafted centuries ago, are all that remain after the"
    Print " relentless hands of time claimed the rest."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CRATES") And r = 359 Then
    Cls
    Print "__Statues______________________________________________________________________"
    Print " Fragments of what once formed sturdy crates now lie scattered across the area,"
    Print " remnants of a forgotten purpose."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GEARS") And r = 401 Then
    Cls
    Print "__Gears________________________________________________________________________"
    Print " Old metal gears turn, breathing life into this ancient mechanical clock."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE DRAWINGS") And r = 402 Then
    Cls
    Print "__Drawings_____________________________________________________________________"
    Print " Drawings depict the various components of the clock, as if its construction"
    Print " were still in progress."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TAKE DRAWINGS") And r = 402 Then
    Cls
    Print "__Drawings_____________________________________________________________________"
    Print " It's best to leave them here."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WALLPAPER") And r = 414 Then
    Cls
    Print "__Wallpaper____________________________________________________________________"
    Print " Faded, tattered wallpaper clings desperately to the walls, a last vestige of"
    Print " the past."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BED") And r = 414 Then
    Cls
    Print "__Bed__________________________________________________________________________"
    Print " A plain, empty bed. Nothing remarkable."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "SLEEP") And r = 414 Then
    Cls
    Print "__Bed__________________________________________________________________________"
    Print " It's not the right time to sleep here."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE DESK") And r = 414 Then
    Cls
    Print "__Desk_________________________________________________________________________"
    Print " An old writing desk, held together by mismatched pieces of wood scavenged over"
    Print " the years."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "SEARCH DESK") And r = 414 Then
    Cls
    Print "__Desk_________________________________________________________________________"
    Print " You find nothing of use."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE OLD CLOCK PARTS") And r = 422 Then
    Cls
    Print "__Old Clock Parts______________________________________________________________"
    Print " A graveyard of rusted clock parts, coated in dust and as large as wagons."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CARPET") And r = 435 Then
    Cls
    Print "__Carpet_______________________________________________________________________"
    Print " An aged, worn carpet, woven by the hands of village artisans long ago."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TAKE CARPET") And r = 435 Then
    Cls
    Print "__Carpet_______________________________________________________________________"
    Print " What would I do with it?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BED") And r = 435 Then
    Cls
    Print "__Bed__________________________________________________________________________"
    Print " A patchwork bed stitched from salvaged scraps, carrying the faint smell of a"
    Print " barn."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "SLEEP") And r = 435 Then
    Cls
    Print "__Bed__________________________________________________________________________"
    Print " You'd rather not."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STOVE") And r = 436 Then
    Cls
    Print "__Stove________________________________________________________________________"
    Print " An old stove once used for cooking. But why is it here?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "OPEN STOVE") And r = 436 Then
    Cls
    Print "__Stove________________________________________________________________________"
    Print " The stove is locked."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE HOLES") And r = 443 Then
    Cls
    Print "__Holes________________________________________________________________________"
    Print " Where they lead is anyone's guess."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WAGONS") And r = 445 Then
    Cls
    Print "__Wagons_______________________________________________________________________"
    Print " Scattered before you are the remnants of wagons that once served a purpose in"
    Print " everyday life. Now, they lie abandoned and rotting, a silent testament to the"
    Print " passage of time."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE TAVERN SIGN") And r = 448 Then
    Cls
    Print "__Tavern Sign__________________________________________________________________"
    Print " A hand-carved wooden sign creaks gently in the breeze. Painted upon it is the"
    Print " image of a proud owl, its sharp eyes seemingly watching all who pass. Beneath"
    Print " the bird, the words -The Wise Owl Tavern- are etched with care, though the"
    Print " paint has begun to fade with age."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WELL") And r = 453 Then
    Cls
    Print "__Well_________________________________________________________________________"
    Print " Standing at the center of the clearing, the old stone well plunges deep into"
    Print " the earth. A sturdy rope is looped through a weathered pulley, and a wooden"
    Print " bucket hangs at its end, ready to be lowered into the depths."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "USE BUCKET") And r = 453 Then
    Cls
    Print "__Well_________________________________________________________________________"
    Print " You grip the rope firmly and lower the bucket into the well. After a moment,"
    Print " you hear a soft splash. Pulling the bucket back up, you reveal it brimming"
    Print " with cool, clear water."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FENCE") And r = 456 Then
    Cls
    Print "__Fence________________________________________________________________________"
    Print " An aged wooden fence stretches along the edge of the path, its once-proud"
    Print " posts now weathered and brittle. It seems as though a single strong wind might"
    Print " send it crumbling into dust."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SKELETON") And r = 483 Then
    Cls
    Print "__Skeleton_____________________________________________________________________"
    Print " The decayed remains of a forgotten soul, left to rot beneath this once-holy"
    Print " house."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "SEARCH SKELETON") And r = 483 Then
    Cls
    Print "__Skeleton_____________________________________________________________________"
    Print " You find nothing of interest."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE IRON DOOR") And r = 484 Then
    Cls
    Print "__Iron Door____________________________________________________________________"
    Print " A heavily rusted iron door stands before you, its surface mottled with age."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "OPEN IRON DOOR") And r = 484 Then
    Cls
    Print "__Iron Door____________________________________________________________________"
    Print " The door refuses to budge. It's locked."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BONES") And r = 501 Then
    Cls
    Print "__Bones________________________________________________________________________"
    Print " Weathered and stained bones lie scattered across the ground, grim remnants of"
    Print " those who have succumbed to this hellish place."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TAKE BONES") And r = 501 Then
    Cls
    Print "__Bones________________________________________________________________________"
    Print " You pause, your hand hovering over the remains. A question lingers in your"
    Print " mind: Why?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "WHY") And r = 501 Then
    Cls
    Print "__Bones________________________________________________________________________"
    Print " Because it feels wrong."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ALTAR") And r = 510 Then
    Cls
    Print "__Altar________________________________________________________________________"
    Print " A stone altar, weathered by time, stands solemnly in the clearing. Built to"
    Print " honor the gods with the finest harvest offerings, it now sits empty and"
    Print " forgotten."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WHEAT") And r = 515 Then
    Cls
    Print "__Wheat________________________________________________________________________"
    Print " A golden expanse of wheat stretches before you, reaching up to your knees. The"
    Print " stalks sway gently with the rhythm of the wind, whispering secrets of the"
    Print " fields."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BED") And r = 519 Then
    Cls
    Print "__Bed__________________________________________________________________________"
    Print " A freshly made bed, stark against the room's layer of dust and soot, seems"
    Print " oddly out of place, as though untouched by time."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE DRESSER") And r = 519 Then
    Cls
    Print "__Dresser______________________________________________________________________"
    Print " A plain wooden dresser, unassuming and utilitarian, likely holds the simple"
    Print " clothing of a farmer's life."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "OPEN DRESSER") And r = 519 Then
    Cls
    Print "__Dresser______________________________________________________________________"
    Print " Inside, you discover a modest collection of neatly folded shirts and pants."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TAKE CLOTHES") And r = 519 Then
    Cls
    Print "__Dresser______________________________________________________________________"
    Print " It's best not to steal from those who work the land."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WEBBING") And r = 527 Then
    Cls
    Print "__Webbing______________________________________________________________________"
    Print " The webs are ancient, their once intricate patterns now dissolving with the"
    Print " passage of time."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WEBS") And r = 534 Then
    Cls
    Print "__Webs_________________________________________________________________________"
    Print " The webs span the divide, their sticky strands glistening ominously in the dim"
    Print " light."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SPIDER WEBS") And r = 544 Then
    Cls
    Print "__Spider Webs__________________________________________________________________"
    Print " Massive spider webs, intricately crafted, stretch across the area, hoping to"
    Print " ensnare anyone or anything unfortunate enough to get caught."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BONES") And r = 549 Then
    Cls
    Print "__Bones________________________________________________________________________"
    Print " A scattered collection of bones from numerous souls who lost their lives in"
    Print " this forsaken place."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TAKE BONES") And r = 549 Then
    Cls
    Print "__Bones________________________________________________________________________"
    Print " It's best not to disturb this resting place."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAINE ALTAR") And r = 550 Then
    Cls
    Print "__Altar________________________________________________________________________"
    Print " Crafted from pieces of wood and stone, the altar stands as a solemn place of"
    Print " worship for a forgotten god."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BED") And r = 550 Then
    Cls
    Print "__Bed__________________________________________________________________________"
    Print " The bed consists of a pile of straw topped with a few tattered, hole-ridden"
    Print " blankets."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "SLEEP") And r = 550 Then
    Cls
    Print "__Bed__________________________________________________________________________"
    Print " It's best not to sleep in someone else's bed."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE HOLY SPIRIT") And r = 551 Then
    Cls
    Print "__Holy Spirit__________________________________________________________________"
    Print " A grotesque makeshift creature, the Holy Spirit prowls these parts, feasting"
    Print " on the flesh of the living. It has eight legs fashioned from scraps of wood"
    Print " and a body formed from a human skull."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STONE BRIDGE") And r = 723 Then
    Cls
    Print "__Stone Bridge_________________________________________________________________"
    Print " An ancient stone bridge built centuries ago, its weathered stones standing as"
    Print " a testament to the craftsmanship of a bygone era."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE RIVER") And r = 723 Then
    Cls
    Print "__River________________________________________________________________________"
    Print " A wide, gently flowing river, moving at a leisurely pace. Its crystal-clear"
    Print " waters sparkle invitingly under the sunlight."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "JUMP IN") And r = 723 Then
    Cls
    Print "__River________________________________________________________________________"
    Print " You resist the temptation; there's an adventure to focus on, and a cold is the"
    Print " last thing you need."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE TORCHES") And r = 726 Then
    Cls
    Print "__Torches______________________________________________________________________"
    Print " Large stone bowls perched atop sturdy stone pillars. They cast a warm, steady"
    Print " light and radiate comforting heat."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SIGN") And r = 742 Then
    Cls
    Print "__Sign_________________________________________________________________________"
    Print " It reads: The Life of the Holy."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CRATES") And r = 749 Then
    Cls
    Print "__Crates_______________________________________________________________________"
    Print " Old wooden crates rest here, covered in a thin layer of dust."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CRATES") And r = 754 Then
    Cls
    Print "__Crates_______________________________________________________________________"
    Print " Wooden crates brimming with pickaxes and other mining tools."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TAKE PICKAXES") And r = 754 Then
    Cls
    Print "__Pickaxes_____________________________________________________________________"
    Print " It's probably best not to steal."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ROCKS") And r = 755 Then
    Cls
    Print "__Rocks________________________________________________________________________"
    Print " Nothing more than worthless chunks of stone."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE DEBRIS") And r = 755 Then
    Cls
    Print "__Crates_______________________________________________________________________"
    Print " The carts are filled with broken wood and rusted metal fragments."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE OLD RAIL CARS") And r = 762 Then
    Cls
    Print "__Crates_______________________________________________________________________"
    Print " The decaying rail cars lie abandoned, left to rot in this desolate place."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WORSHIP") And r = 766 Then
    Cls
    Print "__Worship______________________________________________________________________"
    Print " A towering statue of Vaelthoryn looms above, its presence commanding and"
    Print " awe-inspiring."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CLOTHES") And r = 767 Then
    Cls
    Print "__Clothes______________________________________________________________________"
    Print " Torn garments are scattered across the ground, remnants of a life now"
    Print " forgotten."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BROKEN TABLES") And r = 767 Then
    Cls
    Print "__Broken Tables________________________________________________________________"
    Print " The decayed remains of tables are strewn about, their purpose long lost to"
    Print " time."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE DESK") And r = 768 Then
    Cls
    Print "__Desk_________________________________________________________________________"
    Print " An old writing desk stands here, worn but still sturdy."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GREEN ORE") And r = 770 Then
    Cls
    Print "__Green Ore____________________________________________________________________"
    Print " A pile of freshly mined green ore glimmers faintly in the dim light."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BEDS") And r = 774 Then
    Cls
    Print "__Beds_________________________________________________________________________"
    Print " The beds, belonging to those who call this place home, are neatly made."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "SLEEP") And r = 774 Then
    Cls
    Print "__Beds_________________________________________________________________________"
    Print " You're not tired."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CRATES") And r = 775 Then
    Cls
    Print "__Crates_______________________________________________________________________"
    Print " Crates filled with supplies essential for the miners' survival stand neatly"
    Print " stacked, ensuring they can work underground without interruption."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BOOKS") And r = 785 Then
    Cls
    Print "__Books________________________________________________________________________"
    Print " A vast collection of books lines the walls, chronicling the history of a"
    Print " long-forgotten people."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ BOOKS") And r = 785 Then
    Cls
    Print "__Books________________________________________________________________________"
    Print " The books are written in a language lost to time. You cannot decipher them."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE TEXTS") And r = 788 Then
    Cls
    Print "__Texts________________________________________________________________________"
    Print " An assortment of ancient texts rests here, their subjects shrouded in eternal"
    Print " mystery."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ TEXTS") And r = 788 Then
    Cls
    Print "__Texts________________________________________________________________________"
    Print " The language is unfamiliar, and you cannot make sense of the writings."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PORTRAIT") And r = 801 Then
    Cls
    Print "__Portrait_____________________________________________________________________"
    Print " The portrait depicts the Custodian, clad in regal armor and standing tall,"
    Print " exuding an aura of authority and purpose."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PLATFORM") And r = 805 Then
    Cls
    Print "__Platform_____________________________________________________________________"
    Print " A peculiar metallic platform rests here, silent and unmoving, as though"
    Print " waiting for its purpose to be fulfilled."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "USE PLATFORM") And r = 805 Then
    Cls
    Print "__Platform_____________________________________________________________________"
    Print " You can't."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WALL") And r = 829 Then
    Cls
    Print "__Wall_________________________________________________________________________"
    Print " It's been built to keep you out-or perhaps to keep something in."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CRATES") And r = 832 Then
    Cls
    Print "__Crates_______________________________________________________________________"
    Print " Old wooden crates, filled with supplies-or so you think."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "OPEN CRATES") And r = 832 Then
    Cls
    Print "__Crates_______________________________________________________________________"
    Print " They're sealed shut."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SUPPLIES") And r = 832 Then
    Cls
    Print "__Supplies_____________________________________________________________________"
    Print " A vast collection of provisions for those who live within this place."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TAKE SUPPLIES") And r = 832 Then
    Cls
    Print "__Supplies_____________________________________________________________________"
    Print " It's best not to take what isn't yours."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BLANKET") And r = 840 Then
    Cls
    Print "__Blanket______________________________________________________________________"
    Print " An old, stained blanket covers something you fear to uncover."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "REMOVE BLANKET") And r = 840 Then
    Cls
    Print "__Blanket______________________________________________________________________"
    Print " You slowly pull it back to reveal the putrefied remains of a corpse, partially"
    Print " eaten."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE COFFINS") And r = 844 Then
    Cls
    Print "__Coffins______________________________________________________________________"
    Print " Aged wooden coffins, marked by dirt and the relentless passage of time. An"
    Print " uneasy feeling washes over you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "OPEN COFFINS") And r = 844 Then
    Cls
    Print "__Coffins______________________________________________________________________"
    Print " They're empty."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WOODEN GATE") And r = 845 Then
    Cls
    Print "__Wooden Gate__________________________________________________________________"
    Print " A handcrafted gate, cobbled together from whatever scraps of wood could be"
    Print " salvaged."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WRITINGS") And r = 852 Then
    Cls
    Print "__Writings_____________________________________________________________________"
    Print " Frantic scribbles etched into the walls with blood, the work of a mind far"
    Print " from sanity."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ WRITINGS") And r = 852 Then
    Cls
    Print "__Writings_____________________________________________________________________"
    Print " The only part you can decipher is a single, chilling warning: -Keep out.-"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STATUE") And r = 853 Then
    Cls
    Print "__Statue_______________________________________________________________________"
    Print " A stone statue, crafted as part of some forgotten religious worship. It"
    Print " depicts a woman standing tall, her gaze fixed downward, arms raised high in"
    Print " silent supplication."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SCRATCH MARKS") And r = 873 Then
    Cls
    Print "__Scratch Marks________________________________________________________________"
    Print " Massive claw marks are etched deep into the walls, evidence of a beast that"
    Print " must have towered at least twelve feet tall."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STATUE") And r = 894 Then
    Cls
    Print "__Statue_______________________________________________________________________"
    Print " Carved from pure marble, the statue stands before you, a tribute to an ancient"
    Print " god who once descended upon this world, bestowing a great and mysterious"
    Print " power."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STATUE") And r = 895 Then
    Cls
    Print "__Statue_______________________________________________________________________"
    Print " Carved from pure marble, the statue stands before you, a tribute to an ancient"
    Print " god who once descended upon this world, bestowing a great and mysterious"
    Print " power."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE DOORWAY") And r = 897 Then
    Cls
    Print "__Doorway______________________________________________________________________"
    Print " The towering doorway crackles with an electric hum, the air around it charged"
    Print " and alive. Its surface ripples like a flowing river, glinting with a metallic"
    Print " sheen that feels almost otherworldly."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STONE PILLAR") And r = 898 Then
    Cls
    Print "__Stone Pillar_________________________________________________________________"
    Print " Constructed from a material that seems unearthly and timeless, the pillar hums"
    Print " softly as it powers the ancient doorway with its enigmatic energy."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STONE PILLAR") And r = 899 Then
    Cls
    Print "__Stone Pillar_________________________________________________________________"
    Print " Constructed from a material that seems unearthly and timeless, the pillar hums"
    Print " softly as it powers the ancient doorway with its enigmatic energy."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE TAPESTRIES") And r = 902 Then
    Cls
    Print "__Tapestries___________________________________________________________________"
    Print " Crimson and gold tapestries hang high upon the walls, their intricate designs"
    Print " weaving the tale of a great hero who once vanquished the evil that plagued the"
    Print " land."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BODIES") And r = 907 Then
    Cls
    Print "__Bodies_______________________________________________________________________"
    Print " A grim collection of long-departed bodies lies before you. Their flesh bears"
    Print " strange carvings, symbols etched with unsettling precision. Was this some"
    Print " desperate attempt to bring them back to life?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STEAM") And r = 929 Then
    Cls
    Print "__Steam________________________________________________________________________"
    Print " Strong jets of steam hiss from beneath the grated floor, nearly blocking your"
    Print " path."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE TAPESTRIES") And r = 902 Then
    Cls
    Print "__Tapestries___________________________________________________________________"
    Print " Crimson and gold tapestries hang high upon the walls, their intricate designs"
    Print " weaving the tale of a great hero who once vanquished the evil that plagued the"
    Print " land."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BODIES") And r = 907 Then
    Cls
    Print "__Bodies_______________________________________________________________________"
    Print " A grim collection of long-departed bodies lies before you. Their flesh bears"
    Print " strange carvings, symbols etched with unsettling precision. Was this some"
    Print " desperate attempt to bring them back to life?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BENCH") And r = 979 Then
    Cls
    Print "__Bench________________________________________________________________________"
    Print " Handcrafted with care, the bench stands as a place for quiet reflection."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "SIT") And r = 979 Then
    Cls
    Print "__Bench________________________________________________________________________"
    Print " You sit down, letting the silence wash over you. For a brief moment, peace"
    Print " finds you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GRAVE") And r = 981 Then
    Cls
    Print "__Grave________________________________________________________________________"
    Print " The scent of freshly turned earth lingers in the air. Peering into the grave,"
    Print " you see nothing out of the ordinary."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SAW") And r = 986 Then
    Cls
    Print "__Saw__________________________________________________________________________"
    Print " A patched-together contraption hums with life, its large belt whirring as the"
    Print " saw blade spins relentlessly."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BENCH") And r = 992 Then
    Cls
    Print "__Bench________________________________________________________________________"
    Print " Simple, sturdy benches, built for all to rest and take in the world around"
    Print " them."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "SIT") And r = 979 Then
    Cls
    Print "__Bench________________________________________________________________________"
    Print " You settle onto the bench, allowing yourself a moment to admire the beauty of"
    Print " the land."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WAGON") And r = 1001 Then
    Cls
    Print "__Wagon________________________________________________________________________"
    Print " A rusted iron frame with rotting wood barely holding on, stubbornly clinging"
    Print " to existence in this world."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FARMHOUSE") And r = 1002 Then
    Cls
    Print "__Farmhouse____________________________________________________________________"
    Print " The windows are boarded up, the wood is weathered, and the entire structure"
    Print " looks as though it could collapse at any moment."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SCRATCHES") And r = 1006 Then
    Cls
    Print "__Scratches____________________________________________________________________"
    Print " Deep gashes mar the wood-left behind by some desperate creature, either trying"
    Print " to escape... or force its way in."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE DOORS") And r = 1014 Then
    Cls
    Print "__Doors________________________________________________________________________"
    Print " A faint wailing drifts from an unknown location, sending a shiver down your"
    Print " spine."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SCREAM") And r = 1015 Then
    Cls
    Print "__Scream_______________________________________________________________________"
    Print " A bloodcurdling scream-a woman's voice-pierces the silence. Then, just as"
    Print " suddenly, it stops."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CLOTHES") And r = 1019 Then
    Cls
    Print "__Clothes______________________________________________________________________"
    Print " A neatly folded pile of farmers' clothes-men's and women's-rests here, as if"
    Print " waiting for their owners to return."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TAKE CLOTHES") And r = 1019 Then
    Cls
    Print "__Clothes______________________________________________________________________"
    Print " Best not to steal someone else's laundry."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BED") And r = 1050 Then
    Cls
    Print "__Bed__________________________________________________________________________"
    Print " Its stuffing spills out from the broken seams of the mattress."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "SLEEP") And r = 1002 Then
    Cls
    Print "__Bed__________________________________________________________________________"
    Print " Best not to do that."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CHAINS") And r = 1051 Then
    Cls
    Print "__Chains_______________________________________________________________________"
    Print " Old, rusted chains hang throughout this place. But for what purpose?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE TABLE") And r = 1032 Then
    Cls
    Print "__Table________________________________________________________________________"
    Print " An old, blood-stained table-used either to feed the beast or to create it."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BED") And r = 1054 Then
    Cls
    Print "__Bed__________________________________________________________________________"
    Print " A simple pile of hay. Nothing worth noting."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "SLEEP") And r = 1054 Then
    Cls
    Print "__Table________________________________________________________________________"
    Print " You undress and sleep for a few hours. Suddenly, you awaken, dress, and"
    Print " prepare for adventure."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PLATE") And r = 1055 Then
    Cls
    Print "__Plate________________________________________________________________________"
    Print " A wooden plate holds a vile meal of rancid organs."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EAT") And r = 1055 Then
    Cls
    Print "__Plate________________________________________________________________________"
    Print " You'd rather not."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BUCKET") And r = 1056 Then
    Cls
    Print "__Bucket_______________________________________________________________________"
    Print " A warm bucket of water, its surface covered by a thick layer of slime."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "DRINK") And r = 1056 Then
    Cls
    Print "__Bucket_______________________________________________________________________"
    Print " What is wrong with you?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STONE") And r = 1091 Then
    Cls
    Print "__Stone________________________________________________________________________"
    Print " Massive stone slabs, seemingly extracted from a reality beyond comprehension,"
    Print " stand ominously. Their purpose is uncertain, though they may have once powered"
    Print " some unknown machine."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE METAL PIPE") And r = 1096 Then
    Cls
    Print "__Metal Pipe___________________________________________________________________"
    Print " A peculiar metal pipe juts from the earth, its surface corroded with age,"
    Print " hinting at years of neglect and exposure."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE RUSTED PARTS") And r = 1097 Then
    Cls
    Print "__Rusted Parts_________________________________________________________________"
    Print " A vast collection of rusted fragments-once integral to mechanized workers-now"
    Print " lies in a state of complete disrepair, their function long forgotten."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STRANGE WRITINGS") And r = 1104 Then
    Cls
    Print "__Strange Writings_____________________________________________________________"
    Print " Etched deep into the wall, cryptic inscriptions form patterns in a language"
    Print " lost to time, their meaning obscured by the ages."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ANCIENT RELICS") And r = 1108 Then
    Cls
    Print "__Ancient Relics_______________________________________________________________"
    Print " A series of aged busts, depicting figures from a forgotten era, stand as"
    Print " silent sentinels. Their once-proud visages remain, remnants of a civilization"
    Print " lost to history."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE COPPER SPHERE") And r = 1110 Then
    Cls
    Print "__Copper Sphere________________________________________________________________"
    Print " A massive copper sphere glides eerily through the air, its surface undulating"
    Print " like liquid metal. A low, resonant hum emanates from within, stirring an"
    Print " inexplicable unease."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE DOORWAY") And r = 1113 Then
    Cls
    Print "__Doorway______________________________________________________________________"
    Print " A sudden gust of wind rushes past, vanishing into the doorway-a shimmering,"
    Print " fluid-like surface that ripples as though composed of liquid itself."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CARVINGS") And r = 1117 Then
    Cls
    Print "__Carvings_____________________________________________________________________"
    Print " Strange images are etched into the walls-otherworldly beings dragging the"
    Print " souls of the innocent into a dark and unknowable realm."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STATUE") And r = 1121 Then
    Cls
    Print "__Statue_______________________________________________________________________"
    Print " A towering figure stands before you, frozen in an attack stance, gripping a"
    Print " staff. Once worshipped by the masses, its reverence faded lifetimes ago."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CARVED FACES") And r = 1134 Then
    Cls
    Print "__Carved Faces_________________________________________________________________"
    Print " Featureless faces stare back at you-void of emotion, void of life. They feel"
    Print " utterly alien, as if belonging to something beyond this world."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CARVED FACES") And r = 1135 Then
    Cls
    Print "__Carved Faces_________________________________________________________________"
    Print " Chiseled into the walls, these faces remain as silent monuments. Were they"
    Print " once gods, or mere echoes of those who lived here long ago?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PORTRAITS") And r = 1140 Then
    Cls
    Print "__Portraits____________________________________________________________________"
    Print " Ancient portraits of long-forgotten leaders of the faith. Each painting"
    Print " depicts sacred places that once stood at the heart of their mighty society."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ALTAR") And r = 1142 Then
    Cls
    Print "__Altar________________________________________________________________________"
    Print " A large stone altar adorned with gold and silver, a place where the gods"
    Print " accept the meager offerings left in their honor."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE RUBBLE") And r = 1147 Then
    Cls
    Print "__Rubble_______________________________________________________________________"
    Print " A large pile of jagged rocks, covered in a thick layer of dust and soot."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MINING EQUIPMENT") And r = 1150 Then
    Cls
    Print "__Mining Equipment_____________________________________________________________"
    Print " Old pickaxes and shovels lay scattered about, rotting away-a silent reminder"
    Print " of what once was."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TAKE MINING EQUIPMENT") And r = 1150 Then
    Cls
    Print "__Mining Equipment_____________________________________________________________"
    Print " You have no use for such things. Perhaps later."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CROSSES") And r = 1155 Then
    Cls
    Print "__Crosses______________________________________________________________________"
    Print " Massive crosses, constructed from bones of all sizes, stand as grim warnings"
    Print " to outsiders."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PAINTINGS") And r = 1158 Then
    Cls
    Print "__Paintings____________________________________________________________________"
    Print " Faded paintings depict strange stories of how the world around you came to be."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STATUES") And r = 1159 Then
    Cls
    Print "__Statues______________________________________________________________________"
    Print " Ancient statues, sculpted by hands long since turned to dust, stand in solemn"
    Print " silence."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE POT") And r = 1163 Then
    Cls
    Print "__Pot__________________________________________________________________________"
    Print " A simmering concoction of spices and unknown ingredients fills the air with a"
    Print " tantalizing aroma. Your mouth waters at the thought of a hot meal."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EAT") And r = 1163 Then
    Cls
    Print "__Pot__________________________________________________________________________"
    Print " The flavors dance across your tongue in perfect harmony. But from the corner"
    Print " of your eye, you spot something-a human bone, half-submerged in the broth."
    Print " Nausea grips you as realization sets in."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STATUES") And r = 1171 Then
    Cls
    Print "__Statues______________________________________________________________________"
    Print " Standing in imposing stances, these statues depict the gods of an ancient"
    Print " world order."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BEDS") And r = 1181 Then
    Cls
    Print "__Beds_________________________________________________________________________"
    Print " A haphazard collection of beds, cobbled together from whatever scraps could be"
    Print " salvaged."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "SLEEP") And r = 1181 Then
    Cls
    Print "__Beds_________________________________________________________________________"
    Print " You lay down and drift into sleep almost instantly. Then, a voice-unfamiliar"
    Print " yet urgent-whispers in your ear: You are Drakhan, the great adventurer who has"
    Print " faced evil. Please, meet me at the Tomb of the Unborn King. There, you will"
    Print " find the answer."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BOAT") And r = 1215 Then
    Cls
    Print "__Boat_________________________________________________________________________"
    Print " An old boat, its surface stained by years of mineral-rich water. It is small,"
    Print " meant for a single soul."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BLANKETS") And r = 1228 Then
    Cls
    Print "__Blankets_____________________________________________________________________"
    Print " Tattered yet beautiful, the weathered blankets of a forgotten society hang"
    Print " before you, their patterns whispering of a lost past."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PAINTED SKULLS") And r = 1230 Then
    Cls
    Print "__Painted Skulls_______________________________________________________________"
    Print " Skulls, painted in deep blue and adorned with colorful stones and emeralds,"
    Print " stand as solemn relics of what once was."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FOUNTAIN") And r = 1245 Then
    Cls
    Print "__Fountain_____________________________________________________________________"
    Print " An old stone fountain, its original purpose lost to time. What it was once"
    Print " meant to hold remains a mystery."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE DOLL") And r = 1246 Then
    Cls
    Print "__Doll_________________________________________________________________________"
    Print " Carved hands made of wood, the body draped in ragged clothing. The"
    Print " craftsmanship is both crude and unsettling."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WINDOW") And r = 1251 Then
    Cls
    Print "__Window_______________________________________________________________________"
    Print " The glass is weathered, stained by the endless rains of this forsaken land."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "LOOKOUT WINDOW") And r = 1251 Then
    Cls
    Print "__Window_______________________________________________________________________"
    Print " You press your face against the glass and peer into the abyss. From the"
    Print " darkness, a strange figure watches you from the wilderness."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WORSHIPPERS") And r = 1252 Then
    Cls
    Print "__Worshippers__________________________________________________________________"
    Print " A gathering of figures, lost in prayer. You raise your lantern to get a better"
    Print " look, and in unison, they turn their heads to face you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE DOLL") And r = 1258 Then
    Cls
    Print "__Doll_________________________________________________________________________"
    Print " A creation, draped in dust and cobwebs. Its presence is eerily still, frozen"
    Print " in time."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CLOAKED FIGURE") And r = 1260 Then
    Cls
    Print "__Cloaked Figure_______________________________________________________________"
    Print " You stumble into a cloaked figure, and something about it feels wrong,"
    Print " different from the others. You reach out and yank at the robe-beneath it,"
    Print " nothing."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE DOLLS") And r = 1261 Then
    Cls
    Print "__Dolls________________________________________________________________________"
    Print " Dolls stacked upon one another, arranged as if swapped out at regular"
    Print " intervals. They seem to watch you, each more lifelike than the last."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE DOOR") And r = 1264 Then
    Cls
    Print "__Door_________________________________________________________________________"
    Print " An old wooden door, nailed shut with heavy boards. From the other side comes"
    Print " the sound of labored breathing-something forsaken waits within."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "OPEN DOOR") And r = 1264 Then
    Cls
    Print "__Door_________________________________________________________________________"
    Print " You reach for the barricades, but before you can act, the air fills with the"
    Print " screams of madness. After a moment, all that remains is the sound of soft,"
    Print " mournful crying."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ORB") And r = 1269 Then
    Cls
    Print "__Orb__________________________________________________________________________"
    Print " A green orb hovers in the air, casting an eerie glow. Though it appears"
    Print " harmless, something about it feels... off."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STATUE") And r = 1274 Then
    Cls
    Print "__Statue_______________________________________________________________________"
    Print " Carved from marble, the statue depicts a grieving mother, her face buried in"
    Print " her hands, frozen in eternal sorrow."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE OFFERING DISH") And r = 1274 Then
    Cls
    Print "__Offering Dish________________________________________________________________"
    Print " A stone dish sits before you, filled with an unsettling mix of children's"
    Print " dolls and other worn toys."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TAKE DOLLS") And r = 1274 Then
    Cls
    Print "__Offering Dish________________________________________________________________"
    Print " Best not to do that."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TAKE TOYS") And r = 1274 Then
    Cls
    Print "__Offering Dish________________________________________________________________"
    Print " You have no need for toys."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "LOOKOUT VOID") And r = 1279 Then
    Cls
    Print "__Void_________________________________________________________________________"
    Print " Beyond the darkness, you glimpse the faint image of a lone figure hunched"
    Print " before a dim light, tirelessly working away."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SLIME") And r = 1283 Then
    Cls
    Print "__Slime________________________________________________________________________"
    Print " A thick, clear slime oozes from the cracks in the walls, its origin unknown."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MIRRORS") And r = 1294 Then
    Cls
    Print "__Mirrors______________________________________________________________________"
    Print " You pull back a sheet, but just as your reflection is about to appear, an"
    Print " unseen force stops you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PORTRAITS") And r = 1295 Then
    Cls
    Print "__Portraits____________________________________________________________________"
    Print " Family portraits line the walls, but their faces have been crudely painted"
    Print " over. Their identities, now lost, will remain unknown forever."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WOODEN MARKERS") And r = 1331 Then
    Cls
    Print "__Wooden Markers_______________________________________________________________"
    Print " Crude, handmade grave markers stand solemnly, placed by the hands of those who"
    Print " buried their own loved ones."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ WOODEN MARKERS") And r = 1331 Then
    Cls
    Print "__Wooden Markers_______________________________________________________________"
    Print " The inscriptions are indecipherable, written in a language you do not"
    Print " understand."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE COFFINS") And r = 1334 Then
    Cls
    Print "__Coffins______________________________________________________________________"
    Print " Each coffin is handcrafted with care, their black surfaces dulled by a thick"
    Print " layer of dust, untouched by time."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "OPEN COFFINS") And r = 1334 Then
    Cls
    Print "__Coffins______________________________________________________________________"
    Print " You hesitate, and ultimately decide against it."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PEOPLE") And r = 1337 Then
    Cls
    Print "__People_______________________________________________________________________"
    Print " A mass of people moves with purpose, each one seemingly bound for some unknown"
    Print " destination. A strange odor clings to them-faint, yet unmistakable, like the"
    Print " scent of death."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE RUSTED GEARS") And r = 1343 Then
    Cls
    Print "__Rusted Gears_________________________________________________________________"
    Print " A scattered collection of gears, their various sizes hinting at past purpose."
    Print " Now, rust consumes them, leaving only remnants of a forgotten machine."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ANIMAL REMAINS") And r = 1377 Then
    Cls
    Print "__Animal Remains_______________________________________________________________"
    Print " The severed legs of various animals lie scattered before you. But why? What"
    Print " purpose could they serve?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PORTRAITS") And r = 1378 Then
    Cls
    Print "__Portraits____________________________________________________________________"
    Print " Each portrait features a different young woman, yet they all wear the same"
    Print " dress. The eyes seem to watch you, their expressions eerily similar."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ALTAR") And r = 1379 Then
    Cls
    Print "__Altar________________________________________________________________________"
    Print " Crafted from wood and stone, the altar cradles an offering-waiting, expectant."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE OFFERING") And r = 1379 Then
    Cls
    Print "__Altar________________________________________________________________________"
    Print " A heart, slick and glistening. Human or animal? You can only hope it's the"
    Print " latter."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "CONSUME OFFERING") And r = 1379 Then
    Cls
    Print "__Altar________________________________________________________________________"
    Print " That's not going to happen."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BODIES") And r = 1400 Then
    Cls
    Print "__Bodies_______________________________________________________________________"
    Print " Decaying corpses lie motionless, their presence a grim testament to the past."
    Print " How long they have been here is anyone's guess. A pungent stench hangs heavy"
    Print " in the air."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CARVINGS") And r = 1403 Then
    Cls
    Print "__Carvings_____________________________________________________________________"
    Print " The ancient carvings depict a strange creature being offered the bodies of the"
    Print " recently deceased. How long this ritual has taken place is unknown, but one"
    Print " thing is clear-the beast has developed a taste for human flesh."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GLOBE") And r = 1432 Then
    Cls
    Print "__Globe________________________________________________________________________"
    Print " A hand-carved wooden globe, its surface painted to depict vast and varied"
    Print " terrains."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "SPIN GLOBE") And r = 1432 Then
    Cls
    Print "__Globe________________________________________________________________________"
    Print " You give it a gentle spin, watching as it slowly comes to a stop."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STATUE") And r = 1433 Then
    Cls
    Print "__Statue_______________________________________________________________________"
    Print " A towering statue of a warrior, his sword raised high to the heavens, as if"
    Print " calling others to follow his lead."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CARVINGS") And r = 1452 Then
    Cls
    Print "__Carving______________________________________________________________________"
    Print " The carvings depict a tale of a cruel creator who toyed with the lives of its"
    Print " followers, indulging in feasts and laughter as they suffered."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CELLS") And r = 1461 Then
    Cls
    Print "__Cells________________________________________________________________________"
    Print " The old cells are bare, each containing nothing more than a pile of hay for a"
    Print " bed and a bucket for... well, best left unsaid."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CELLS") And r = 1462 Then
    Cls
    Print "__Cells________________________________________________________________________"
    Print " Beyond the usual pile of hay and the bucket, you notice deep scratch marks"
    Print " etched into the walls-desperate, uneven, and numerous."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ARCHWAY") And r = 1464 Then
    Cls
    Print "__Archway______________________________________________________________________"
    Print " The surface shimmers like crystal-clear water, perfectly still, like the"
    Print " surface of a tranquil lake."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MIRRORS") And r = 1478 Then
    Cls
    Print "__Mirrors______________________________________________________________________"
    Print " Old mirrors of various shapes and sizes cover the walls, their surfaces eerily"
    Print " well-maintained."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FOUNTAIN") And r = 1484 Then
    Cls
    Print "__Fountain_____________________________________________________________________"
    Print " You gaze upon the once-lively fountain, a relic of the past that once"
    Print " sustained these people."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SKULLS") And r = 1489 Then
    Cls
    Print "__Skulls_______________________________________________________________________"
    Print " A mound of skulls rises before you, arranged with unsettling precision. Is"
    Print " this an act of reverence for the dead-or devotion to a god?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE TOMB") And r = 1500 Then
    Cls
    Print "__Tomb_________________________________________________________________________"
    Print " Carved from stone and adorned with gold and silver, this tomb speaks of a life"
    Print " that ended in wealth and reverence."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "OPEN TOMB") And r = 1500 Then
    Cls
    Print "__Tomb_________________________________________________________________________"
    Print " Best not to disturb the spirits."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE COFFINS") And r = 1501 Then
    Cls
    Print "__Coffins______________________________________________________________________"
    Print " Wooden coffins rise from the ground, their surfaces untouched by time."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PRAYER GLYPH") And r = 1504 Then
    Cls
    Print "__Prayer Glyph_________________________________________________________________"
    Print " Etched into stone and adorned with intricate designs, this glyph is said to be"
    Print " where travelers of the gods seek protection."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "PRAY FOR PROTECTION") And r = 1504 Then
    Cls
    Print "__Prayer Glyph_________________________________________________________________"
    Print " You close your eyes and offer a prayer. A sudden warmth washes over you,"
    Print " followed by a blinding flash of blue light."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ARCHWAY") And r = 1507 Then
    Cls
    Print "__Archway______________________________________________________________________"
    Print " Once a masterpiece of stone and precious metals, the archway now stands broken"
    Print " and forgotten."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE DRINKING WELL") And r = 1522 Then
    Cls
    Print "__Drinking Well________________________________________________________________"
    Print " Built from stone and well maintained, a bucket hangs from a weathered rope"
    Print " just above the opening."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "DRINK") And r = 1522 Then
    Cls
    Print "__Drinking Well________________________________________________________________"
    Print " You lower the bucket into the dark water, slowly pulling it up to take a"
    Print " refreshing sip of cold, crisp water."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SPEARS") And r = 1534 Then
    Cls
    Print "__Spears_______________________________________________________________________"
    Print " Handmade spears, fashioned from whatever scraps of wood could be found."
    Print " Sharpened to a fine point, they await their use."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TAKE SPEARS") And r = 1534 Then
    Cls
    Print "__Spears_______________________________________________________________________"
    Print " You don't need any."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE AXES") And r = 1534 Then
    Cls
    Print "__Axes_________________________________________________________________________"
    Print " Old battle-worn axes, crudely crafted from whatever materials were at hand."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TAKE AXES") And r = 1534 Then
    Cls
    Print "__Axes_________________________________________________________________________"
    Print " You consider it for a moment but decide it's best to leave them be."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BOOK") And r = 1538 Then
    Cls
    Print "__Book_________________________________________________________________________"
    Print " Bound in old leather from an unknown time, its contents remain a mystery to"
    Print " you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ BOOK") And r = 1538 Then
    Cls
    Print "__Book_________________________________________________________________________"
    Print " The fifth day of the month. The cries of the wolves at night-they call to us,"
    Print " one by one. Those foolish enough to listen are often taken before morning."
    Print " Just the other day, I recall the children playing near the well. They were"
    Print " never seen again."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE RUSTED POT") And r = 1552 Then
    Cls
    Print "__Rusted Pot___________________________________________________________________"
    Print " An old, rusted steel pot, long abandoned and left to decay in this forsaken"
    Print " place."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GATE") And r = 1564 Then
    Cls
    Print "__Gate_________________________________________________________________________"
    Print " A grim structure of iron bars, draped in spiderwebs and adorned with the skulls"
    Print " of the forgotten."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WEBBING") And r = 1569 Then
    Cls
    Print "__Webbing______________________________________________________________________"
    Print " The webbing sways in an unseen current, shifting as though possessed by a"
    Print " silent, eerie will."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BONES") And r = 1571 Then
    Cls
    Print "__Bones________________________________________________________________________"
    Print " A scattering of ancient bones-remnants of lost souls whose names have faded"
    Print " into oblivion."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WEBS") And r = 1572 Then
    Cls
    Print "__Webs_________________________________________________________________________"
    Print " The webs quiver and slither unnaturally, as if seeking the warmth of living"
    Print " flesh."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ANCIENT SEPULCHER") And r = 1575 Then
    Cls
    Print "__Ancient Sepulcher____________________________________________________________"
    Print " A relic of immense religious significance, it stands before you, a barrier"
    Print " between realms beyond mortal understanding."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "MAKE OFFERING") And r = 1575 Then
    Cls
    Print "__Ancient Sepulcher____________________________________________________________"
    Print " A deep sense of peace washes over you as a blessing is bestowed upon you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE COFFIN") And r = 1588 Then
    Cls
    Print "__Coffin_______________________________________________________________________"
    Print " Crafted from the finest materials gathered from across the world, it serves as"
    Print " a solemn reminder of the fate that awaits all."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "OPEN COFFIN") And r = 1588 Then
    Cls
    Print "__Coffin_______________________________________________________________________"
    Print " You hold your breath, fingers grazing the lid-just as a ghostly voice"
    Print " whispers, warning you to stop."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BASKETS") And r = 1593 Then
    Cls
    Print "__Baskets______________________________________________________________________"
    Print " Old woven baskets, long abandoned, now left to gather dust in the still air."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STATUE") And r = 1604 Then
    Cls
    Print "__Statue_______________________________________________________________________"
    Print " A statue of a woman stands before you, arms outstretched in silent welcome."
    Print " Then, with stiff, unnatural movements, it begins to stir-as if roused from a"
    Print " thousand-year slumber."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO STATUE") And r = 1604 Then
    Cls
    Print "__Statue_______________________________________________________________________"
    Print " It does not speak. Instead, it moves in a slow, deliberate dance."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE VIEW") And r = 1640 Then
    Cls
    Print "__View_________________________________________________________________________"
    Print " You gaze upon the untamed beauty of the wilderness. The sky is a mesmerizing"
    Print " blend of blue and purple, while a wall of thick trees looms before a vast"
    Print " valley."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FOUNTAIN") And r = 1646 Then
    Cls
    Print "__Fountain_____________________________________________________________________"
    Print " A stone fountain trickles with crystal-clear water-the lifeblood of"
    Print " civilization."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ARCHWAY") And r = 1650 Then
    Cls
    Print "__Archway______________________________________________________________________"
    Print " A stone archway, its origins lost to time. Carved by unseen hands, it hums"
    Print " with an energy woven from forgotten magic."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FURNITURE") And r = 1668 Then
    Cls
    Print "__Furniture____________________________________________________________________"
    Print " A thin layer of dust coats them, undisturbed by time or touch."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MESSAGE") And r = 1669 Then
    Cls
    Print "__Message______________________________________________________________________"
    Print " It is etched into the wall, carved by rough stone with desperate precision."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "READ MESSAGE") And r = 1669 Then
    Cls
    Print "__Message______________________________________________________________________"
    Print " Time does not forget, nor does it forgive. Step where they have stepped, and"
    Print " you shall share their fate."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WELL") And r = 1677 Then
    Cls
    Print "__Stone Well___________________________________________________________________"
    Print " An old stone well, its depths vanishing into darkness below."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "LOWER BUCKET") And r = 1677 Then
    Cls
    Print "__Stone Well___________________________________________________________________"
    Print " You lower the bucket, its rope unspooling into the abyss."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "PULL BUCKET") And r = 1677 Then
    Cls
    Print "__Stone Well___________________________________________________________________"
    Print " You haul the bucket back upï¿½empty."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BENCH") And r = 1692 Then
    Cls
    Print "__Bench________________________________________________________________________"
    Print " Nothing more than a simple, weathered bench."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "SIT") And r = 1692 Then
    Cls
    Print "__Bench________________________________________________________________________"
    Print " You sit for a moment, allowing yourself a brief rest."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BONES") And r = 1715 Then
    Cls
    Print "__Bones________________________________________________________________________"
    Print " A scattered collection of brittle bones lies half-buried in the dirt,"
    Print " weathered by time and stripped clean by unknown forces. They serve as silent"
    Print " reminders of lives once lived, now forgotten."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE LAMBS") And r = 1734 Then
    Cls
    Print "__Lambs________________________________________________________________________"
    Print " A small pen holds gentle lambs peacefully grazing, their soft wool catching"
    Print " the sun's golden rays. Innocent and unaware, they symbolize tranquility in an"
    Print " otherwise uncertain world."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SHACKS") And r = 1735 Then
    Cls
    Print "__Shacks_______________________________________________________________________"
    Print " Rows of humble shacks stand haphazardly constructed from weathered wood,"
    Print " rusted metal, and scavenged materials. Despite their fragile appearance, they"
    Print " provide shelter to souls living on the margins."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GARDEN") And r = 1743 Then
    Cls
    Print "__Garden_______________________________________________________________________"
    Print " A modest community garden flourishes here, abundant with vegetables, herbs,"
    Print " and vibrant flowers. This patch of earth represents hope and unity, cultivated"
    Print " with care by unseen hands."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE HOME") And r = 1753 Then
    Cls
    Print "__Home_________________________________________________________________________"
    Print " This crumbling home, once warm with life and laughter, now lies abandoned and"
    Print " forgotten. Its walls whisper of memories long faded and joys that no longer"
    Print " echo within."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CARVINGS") And r = 1767 Then
    Cls
    Print "__Carvings_____________________________________________________________________"
    Print " Intricate carvings adorn the stone walls, depicting strange symbols and"
    Print " cryptic scenes. Their unsettling imagery suggests forgotten rituals, stories"
    Print " meant to remain hidden from prying eyes."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STONE SARCOPHAGI") And r = 1774 Then
    Cls
    Print "__Stone Sarcophagi_____________________________________________________________"
    Print " A row of stone sarcophagi stands solemnly in the shadows, their cold surfaces"
    Print " etched with faded runes. Silent guardians of secrets long buried, they exude"
    Print " an aura of reverence and dread."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If

'''Npc's
If (cmd$ = "EXAMINE KINGS GUARD") And r = 7 Then
    Cls
    Print "__King's Guard_________________________________________________________________"
    Print " Dressed in an old suit of armor marked by scuffs and dents, the guard's weary"
    Print " eyes peer through the narrow visor of the helmet. You sense he has stood watch"
    Print " at his post for an uncountable span of time."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO KINGS GUARD") And r = 7 Then
    Cls
    Print "__King's Guard_________________________________________________________________"
    Print " He ignores you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE OLD MAN") And r = 18 Then
    Cls
    Print "__Old Man______________________________________________________________________"
    Print " Wearing tattered robes, the old man seems out of place in a world that has"
    Print " decayed beyond repair. His face bears a tired expression, as though he hasn't"
    Print " known peace in years."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO OLD MAN") And r = 18 Then
    Cls
    Print "__Old Man______________________________________________________________________"
    Print " It's been a lifetime since I've seen an outsider. If I were you, I'd leave"
    Print " before it's too late."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TOO LATE") And r = 18 Then
    Cls
    Print "__Old Man______________________________________________________________________"
    Print " The longer you stay here, the sooner you'll fall prey to Malthera."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "MALTHERA") And r = 18 Then
    Cls
    Print "__Old Man______________________________________________________________________"
    Print " She walks among us, seeing all. She'll feast on you if you're not careful."
    Print " Don't trust a soul. Now leave me alone."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CHILDREN") And r = 21 Then
    Cls
    Print "__Children_____________________________________________________________________"
    Print " The children play among themselves, seemingly oblivious to the fact that their"
    Print " games unfold in the ruins of a fallen kingdom. They pay no attention to anyone"
    Print " else."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO CHILDREN") And r = 21 Then
    Cls
    Print "__Children_____________________________________________________________________"
    Print " They run away and continue playing."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ELDERLY WOMAN") And r = 22 Then
    Cls
    Print "__Elderly Woman________________________________________________________________"
    Print " An elderly woman greets you with an eerie smile. Though the world around her"
    Print " has crumbled, her disapproval of your presence is palpable."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO ELDERLY WOMAN") And r = 22 Then
    Cls
    Print "__Elderly Woman________________________________________________________________"
    Print " An outsider? Looking for treasures that haven't been plundered? You're wasting"
    Print " your time. Everything's been taken by those greedy fools."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WOMAN") And r = 30 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " Dressed in white, this forlorn woman wanders aimlessly, muttering to herself"
    Print " as if trapped in a trance."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO WOMAN") And r = 30 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " I'm sorry, my baby... I'm sorry I let her take you away..."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "BABY") And r = 30 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " I gave her my baby because she claimed it was possessed by a demon."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "DEMON") And r = 30 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " I can't talk now. Go away."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GUARD") And r = 34 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " Standing watch in silence, the guard's statue-like demeanor is betrayed only"
    Print " by the way their eyes track your every move."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO GUARD") And r = 34 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " Move along, non-citizen."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FORTUNE TELLER") And r = 36 Then
    Cls
    Print "__Fortune Teller_______________________________________________________________"
    Print " Dressed in vibrant, colorful robes, the fortune teller greets you warmly. She"
    Print " cradles a crystal ball, claiming to channel the spirits of another realm."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO FORTUNE TELLER") And r = 36 Then
    Cls
    Print "__Fortune Teller_______________________________________________________________"
    Print " You have traveled far to reach this forgotten land. I have spoken to the"
    Print " spirits, and they have given me your fortune."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "PRICE") And r = 36 Then
    Cls
    Print "__Fortune Teller_______________________________________________________________"
    Print " It has been determined that you will receive it for free."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "FORTUNE") And r = 36 Then
    Cls
    Print "__Fortune Teller_______________________________________________________________"
    Print " The mother who gives life will join the father who takes it away. Five"
    Print " crescent moons will light the truth, and only when all five shine will the"
    Print " truth be revealed."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE KING'S GUARD") And r = 43 Then
    Cls
    Print "__Fortune Teller_______________________________________________________________"
    Print " Clad in a worn suit of armor with a sword and shield at his side, the guard"
    Print " notices your presence and instantly goes on alert."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO KING'S GUARD") And r = 43 Then
    Cls
    Print "__Fortune Teller_______________________________________________________________"
    Print " By Oathmoor's hammer, an outsider. Take my advice: we don't take kindly to"
    Print " thieves. Steal from the King's people, and you'll hang by the rope."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GUARD") And r = 44 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " Adorned in golden armor and wielding a sword, the guard blocks your path."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO GUARD") And r = 44 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " The King summoned you? What business do you have?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "BUSINESS") And r = 44 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " Malthera? Speak no more and see the King."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "MALTHERA") And r = 44 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " That witch... Go on and speak with the King, fool."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MINER") And r = 53 Then
    Cls
    Print "__Miner________________________________________________________________________"
    Print " Covered in a layer of dirt and sweat, this weary man seems burdened by regret."
    Print " His entire life has been spent carving riches from the earth, yet he now"
    Print " appears lost in his thoughts."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO MINER") And r = 53 Then
    Cls
    Print "__Miner________________________________________________________________________"
    Print " I've carved almost every inch of gold from these walls. And what do I have to"
    Print " show for it? I wasted my life. It's too late to start again."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "OATHMOOR") And r = 53 Then
    Cls
    Print "__Miner________________________________________________________________________"
    Print " Yes... that's where we are, isn't it?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "MALTHERA") And r = 53 Then
    Cls
    Print "__Miner________________________________________________________________________"
    Print " Who?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ORC") And r = 67 Then
    Cls
    Print "__Orc__________________________________________________________________________"
    Print " Towering over you in a makeshift suit of iron and bone armor, the Orc appears"
    Print " to have just returned from battle."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO ORC") And r = 67 Then
    Cls
    Print "__Orc__________________________________________________________________________"
    Print " Yes, human, I am here on a quest for glory-to bring treasure and knowledge."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "QUEST FOR GLORY") And r = 67 Then
    Cls
    Print "__Orc__________________________________________________________________________"
    Print " I've heard tales of a beast that must be slain. When I succeed, I will become"
    Print " a hero."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "HERO") And r = 53 Then
    Cls
    Print "__Orc__________________________________________________________________________"
    Print " The title of hero is the greatest honor. Immortalized in song for generations."
    Print " It's the dream of every orc."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "FAREWELL") And r = 67 Then
    Cls
    Print "__Orc__________________________________________________________________________"
    Print " Farewell, and protection on your journey. Perhaps we shall meet again."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "ORC") And r = 67 Then
    Cls
    Print "__Orc__________________________________________________________________________"
    Print " Yes, foolish human, I am an orc. No, I don't speak like the rest of them-so"
    Print " don't ask."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ROOTS") And r = 82 Then
    Cls
    Print "__Roots________________________________________________________________________"
    Print " The roots move slowly, writhing like eels. A strange, ominous smell fills the"
    Print " air, as though this place is cursed with eternal doom."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PRIESTESS") And r = 91 Then
    Cls
    Print "__Priestess____________________________________________________________________"
    Print " Shrouded in a traditional brown robe, her face obscured by her hood, the"
    Print " priestess speaks in a stern tone."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO PRIESTESS") And r = 91 Then
    Cls
    Print "__Priestess____________________________________________________________________"
    Print " You have found this holy temple, and you are safe within these walls. May I"
    Print " perform a traveler's blessing?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TRAVELER'S BLESSING") And r = 91 Then
    Cls
    Print "__Priestess____________________________________________________________________"
    Print " By the spirits of the river and the wheat that grows beneath our feet, may you"
    Print " be protected from evil. May we meet again in the heavenly warmth of"
    Print " Aetheronic. Bless you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PRIESTESS") And r = 91 Then
    Cls
    Print "__Priestess____________________________________________________________________"
    Print " Shrouded in a traditional brown robe, her face obscured by her hood, the"
    Print " priestess speaks in a stern tone."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO PRIESTESS") And r = 91 Then
    Cls
    Print "__Priestess____________________________________________________________________"
    Print " You have found this holy temple, and you are safe within these walls. May I"
    Print " perform a traveler's blessing?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TRAVELER'S BLESSING") And r = 91 Then
    Cls
    Print "__Priestess____________________________________________________________________"
    Print " By the spirits of the river and the wheat that grows beneath our feet, may you"
    Print " be protected from evil. May we meet again in the heavenly warmth of"
    Print " Aetheronic. Bless you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PRIEST") And r = 98 Then
    Cls
    Print "__Priest_______________________________________________________________________"
    Print " Clad in traditional brown robes, his face is hidden beneath his hood. He"
    Print " speaks calmly but with great authority."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO PRIEST") And r = 98 Then
    Cls
    Print "__Priest_______________________________________________________________________"
    Print " Greetings, traveler. Rest for a while and give thanks to Aetheronic."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "AETHERONIC") And r = 98 Then
    Cls
    Print "__Priest_______________________________________________________________________"
    Print " The God of Light, tasked with guarding the Sun after Vaelthoryn stole it from"
    Print " the heavens."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "VAELTHORYN") And r = 98 Then
    Cls
    Print "__Priest_______________________________________________________________________"
    Print " A trickster dragon of immense power. It stole the Sun from the gods and"
    Print " entrusted Aetheronic to protect it from being reclaimed."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PRIESTESS") And r = 102 Then
    Cls
    Print "__Priestess____________________________________________________________________"
    Print " This priestess, her face painted white, greets you solemnly within the"
    Print " hallowed temple."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO PRIESTESS") And r = 102 Then
    Cls
    Print "__Priestess____________________________________________________________________"
    Print " Respect this place of worship. We are merely servants of the divine."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE OLD PRIEST") And r = 104 Then
    Cls
    Print "__Old Priest___________________________________________________________________"
    Print " Draped in white robes, the old priest is engrossed in study. Upon seeing you,"
    Print " a flicker of disbelief crosses his face."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO OLD PRIEST") And r = 104 Then
    Cls
    Print "__Old Priest___________________________________________________________________"
    Print " Welcome, adventurer, to our temple. May the knowledge of the heavens nourish"
    Print " your soul and mind."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STATUE") And r = 107 Then
    Cls
    Print "__God of Life_Statue___________________________________________________________"
    Print " A massive stone statue looms over you, its outstretched arms symbolizing the"
    Print " act of giving life to the world."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO STATUE") And r = 107 Then
    Cls
    Print "__God of Life_Statue___________________________________________________________"
    Print " The statue directs you toward a doorway."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "DOORWAY") And r = 107 Then
    Cls
    Print "__God of Life_Statue___________________________________________________________"
    Print " The statue remains silent."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE HEAD PRIEST") And r = 112 Then
    Cls
    Print "__Head Priest__________________________________________________________________"
    Print " Clothed in yellow robes and exuding humility, the head priest welcomes you"
    Print " warmly into the temple."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO HEAD PRIEST") And r = 112 Then
    Cls
    Print "__Head Priest__________________________________________________________________"
    Print " Walk among the faithful, learn from our sacred texts, and partake in the"
    Print " spiritual wisdom of this world."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE YOUNG WOMAN") And r = 121 Then
    Cls
    Print "__Young Woman__________________________________________________________________"
    Print " A somber young woman dressed entirely in black stands in quiet mourning, her"
    Print " face shadowed by sorrow."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO YOUNG WOMAN") And r = 121 Then
    Cls
    Print "__Young Woman__________________________________________________________________"
    Print " She acts as though you aren't even there, her grief impenetrable."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STATUE") And r = 124 Then
    Cls
    Print "__Statue_______________________________________________________________________"
    Print " A towering stone statue of the Guardian of the Dead looms over the area."
    Print " Legends say it stands eternal vigil, protecting the departed in their"
    Print " everlasting rest."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MONK") And r = 125 Then
    Cls
    Print "__Monk_________________________________________________________________________"
    Print " A serene monk, clad in a simple brown robe, roams the grounds. His calm"
    Print " demeanor reflects his mission to guide lost souls toward the light."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO MONK") And r = 125 Then
    Cls
    Print "__Monk_________________________________________________________________________"
    Print " ÂªI have arrived to bring peace to those who seek it,Âª he says with quiet"
    Print " conviction."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE LOST SOUL") And r = 134 Then
    Cls
    Print "__Lost Soul____________________________________________________________________"
    Print " This ghastly creature, skeletal and otherworldly, reaches out with a bony"
    Print " hand, attempting to drag you into the abyss."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "LISTEN TO WHISPERS") And r = 136 Then
    Cls
    Print "__Whispers_____________________________________________________________________"
    Print " Ethereal murmurs swirl around you, their voices growing louder with each"
    Print " moment, filling the air with the secrets of the dead."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE OLD WOMAN") And r = 147 Then
    Cls
    Print "__Old Woman____________________________________________________________________"
    Print " A weary old woman moves methodically, her tired hands lighting sticks of"
    Print " incense as she whispers prayers for the departed in a voice scarcely audible."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CLOAKED FIGURE") And r = 151 Then
    Cls
    Print "__Cloaked Figure_______________________________________________________________"
    Print " A shrouded figure lingers in the shadows, their focus distant and inward, as"
    Print " though they are lost within the realms of the dead."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CARETAKER") And r = 158 Then
    Cls
    Print "__Caretaker____________________________________________________________________"
    Print " This weary man's demeanor reflects years of unyielding dedication. His life's"
    Print " purpose is to ensure that even those whose lives were tragically cut short"
    Print " find dignity in death."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO CARETAKER") And r = 158 Then
    Cls
    Print "__Caretaker____________________________________________________________________"
    Print " ï¿½An outsider?ï¿½ he says, his voice gravelly. ï¿½Haven't met many of you. If you"
    Print " need to rest, feel free to do so by the fire. But respect the residents here.ï¿½"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE NECROMANCER") And r = 175 Then
    Cls
    Print "__Necromancer__________________________________________________________________"
    Print " Clad entirely in black, the figure's face is obscured beneath a dark hood."
    Print " Blood stains their hands as they cry out incantations, summoning the restless"
    Print " spirits of the dead."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO NECROMANCER") And r = 175 Then
    Cls
    Print "__Necromancer__________________________________________________________________"
    Print " ï¿½I call upon the flesh of the dead to rise and feast upon them! For they have"
    Print " strayed from the righteous path of Vaelthoryn,ï¿½ the necromancer bellows with"
    Print " fervor."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "VAELTHORYN") And r = 175 Then
    Cls
    Print "__Necromancer__________________________________________________________________"
    Print " The necromancer pays you no heed, lost in their dark rituals."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE KNIGHT") And r = 178 Then
    Cls
    Print "__Knight_______________________________________________________________________"
    Print " Dressed in a suit of armor, he stands guard, vigilant against the evils that"
    Print " may arise."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO KNIGHT") And r = 178 Then
    Cls
    Print "__Knight_______________________________________________________________________"
    Print " Move along, citizen. I am standing guard. Everyone's on high alert, and we"
    Print " must remain vigilant."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BARD") And r = 181 Then
    Cls
    Print "__Bard_________________________________________________________________________"
    Print " Clad in an outfit of the finest cloth, he strums his lute, playing a melody"
    Print " that instills peace and calm."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "LISTEN TO BARD") And r = 181 Then
    Cls
    Print "__Bard_________________________________________________________________________"
    Print " From the wilderness came a hero so bold, Who answered the call of King Soligo,"
    Print " With sword and lantern in tow, he lands will soon be free from the evil witch"
    Print " Malthera."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE KING") And r = 186 Then
    Cls
    Print "__King_________________________________________________________________________"
    Print " With a weary expression, he sits upon his throne and greets you with a simple"
    Print " hello."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO KING") And r = 186 Then
    Cls
    Print "__King_________________________________________________________________________"
    Print " The Adventurer has arrived. I must say we are pleased to have you in our"
    Print " midst. The evil witch Malthera has cursed the heavens, the lands, and all the"
    Print " citizens of the Kingdom of Oathmoor."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "MALTHERA") And r = 186 Then
    Cls
    Print "__King_________________________________________________________________________"
    Print " She was once a member of the Royal Mage's House. Perhaps it was the allure of"
    Print " power that drew her over."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "ROYAL MAGES HOUSE") And r = 186 Then
    Cls
    Print "__King_________________________________________________________________________"
    Print " It was once the crown jewel of the northern province. It housed the brightest"
    Print " and most powerful mages, dedicated to ensuring our safety."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "NORTHEN PROVINCE") And r = 186 Then
    Cls
    Print "__King_________________________________________________________________________"
    Print " This is known as Borealislyn. The village of Oathmoor lies on the northernmost"
    Print " border, just before reaching no man's land."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ADVISORS") And r = 186 Then
    Cls
    Print "__Advisors_____________________________________________________________________"
    Print " A group of the King's most trusted confidants, offering him the counsel he"
    Print " needs to rule."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO ADVISORS") And r = 186 Then
    Cls
    Print "__Advisors_____________________________________________________________________"
    Print " They ignore you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE TROOPS") And r = 187 Then
    Cls
    Print "__Troops_______________________________________________________________________"
    Print " On high alert for some time now, they stand with swords in hand, ready for"
    Print " action."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO TROOPS") And r = 187 Then
    Cls
    Print "__Troops_______________________________________________________________________"
    Print " Move along, citizen."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE NOBLES") And r = 190 Then
    Cls
    Print "__Nobles_______________________________________________________________________"
    Print " The wealthy, conducting business here in hopes of securing their own survival."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO NOBLES") And r = 190 Then
    Cls
    Print "__Nobles_______________________________________________________________________"
    Print " They ignore you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PRINCESS FEYHEART") And r = 196 Then
    Cls
    Print "__Princess Feyheart____________________________________________________________"
    Print " Clad in a gown of the finest materials, her flowing hair frames a face filled"
    Print " with doubt as she gazes at you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO PRINCESS FEYHEART") And r = 196 Then
    Cls
    Print "__Princess Feyheart____________________________________________________________"
    Print " You must be the Adventurer my father sent for. Please, do what you can to save"
    Print " us from this evil magic. Those who once called this place home have been"
    Print " slaughtered. Those who claimed they would stop this have all failed. We are"
    Print " alone in this devilish nightscape. Please, save us all."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PRIEST") And r = 198 Then
    Cls
    Print "__Priest_______________________________________________________________________"
    Print " Dressed in black, he greets you with a fearful expression, his mind seemingly"
    Print " elsewhere."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO PRIEST") And r = 198 Then
    Cls
    Print "__Priest_______________________________________________________________________"
    Print " They ignore you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ROYAL WIZARD") And r = 204 Then
    Cls
    Print "__Royal Wizard_________________________________________________________________"
    Print " Wearing a blue robe, the Wizard welcomes you into his sanctum."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO ROYAL WIZARD") And r = 204 Then
    Cls
    Print "__Royal Wizard_________________________________________________________________"
    Print " Ah, yes. You are the Adventurer summoned by the King. I must admit I was"
    Print " reluctant to believe it, but now that I see you, I think we might have a"
    Print " chance. Beware of the hand of Umbrothar."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "UMBROTHAR") And r = 204 Then
    Cls
    Print "__Royal Wizard_________________________________________________________________"
    Print " It is said that she drags unsuspecting souls into the afterlife, turning them"
    Print " to stone with her touch."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GUARD") And r = 228 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " Dressed in an all-black quilted tunic, an old iron helmet, and a neatly"
    Print " crafted piece of chainmail, he has a tired expression etched upon his face."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO GUARD") And r = 228 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " Well, greetings, Adventurer. You are forsaken like the rest of us. We won't"
    Print " last long if this continues."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GUARD") And r = 231 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " He's weary from standing guard and ensuring the safety of everyone within the"
    Print " castle."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO GUARD") And r = 231 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " This was supposed to be a gravy tour. But here I am, standing watch to ensure"
    Print " those foul beasts don't take the castle. I've heard reports that Willowshade"
    Print " has already fallen."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "WILLOWSHADE") And r = 231 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " Just south of the caves of Eldermoor, it was attacked by the dark forces of"
    Print " the dead."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GUARD") And r = 236 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " A weary soul, deeply doubtful of survival in the coming days. He appears to be"
    Print " on the brink of absolute ruin."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO GUARD") And r = 236 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " Move along, Adventurer. We need to stay vigilant to protect the King."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GUARD") And r = 246 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " His armor is torn to shreds, a tragic testament to a battle lost against a foe"
    Print " too powerful to defeat."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WINGED BEAST") And r = 248 Then
    Cls
    Print "__Winged Beast_________________________________________________________________"
    Print " A vile creature from the depths of the unknown. Its eyes glow red, and its"
    Print " wings span six feet. With fangs protruding from its maw, it waits for you to"
    Print " lower your guard."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO WINGED BEAST") And r = 248 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " The creature lets out a chilling laugh as it lunges at you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE TORVENIS") And r = 272 Then
    Cls
    Print "__Torvenis_____________________________________________________________________"
    Print " The strange creature appears to be moving itself about beneath you, as if"
    Print " waiting to drag you into the darkness."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO TORVENIS") And r = 272 Then
    Cls
    Print "__Torvenis_____________________________________________________________________"
    Print " It ignores you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE DWELLEM") And r = 275 Then
    Cls
    Print "__Dwellem______________________________________________________________________"
    Print " Wearing a makeshift rusted metal for armour and painting to resemble that of a"
    Print " rockface, it lumbers about almost under a spell."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO DWELLEM") And r = 275 Then
    Cls
    Print "__Dwellem______________________________________________________________________"
    Print " It ignores you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WOMAN") And r = 289 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " She's lost in a world unlike our own, she's chanting in an ancient language"
    Print " with her eye's closed."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO WOMAN") And r = 289 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " It's best not to interrupt her at this time."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ELDERLY PRIEST") And r = 293 Then
    Cls
    Print "__Elderly Priest_______________________________________________________________"
    Print " Dressed in rags and lurking about the darkness, staying true to his teachings"
    Print " and his oath to the Gods."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO ELDERLY PRIEST") And r = 293 Then
    Cls
    Print "__Elderly Priest_______________________________________________________________"
    Print " He ignores you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SKELETAL REMAIN") And r = 299 Then
    Cls
    Print "__Skeletal Remains_____________________________________________________________"
    Print " The skeletal remains of an unlucky soul left as a reminder of what awaits you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GOLECN") And r = 304 Then
    Cls
    Print "__Golecn_______________________________________________________________________"
    Print " Crafted out of solid stone, it has not a face yet chisel marks from it's"
    Print " creator."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO GOLECN") And r = 304 Then
    Cls
    Print "__Golecn_______________________________________________________________________"
    Print " It ignores you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PRIESTESS") And r = 311 Then
    Cls
    Print "__Priestess____________________________________________________________________"
    Print " She greets you and warns you not to continue on this path."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO PRIESTESS") And r = 311 Then
    Cls
    Print "__Priestess____________________________________________________________________"
    Print " Foolish outsider, you seek peace through the act of violence. Don't you"
    Print " understand it requires blood."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MYCELIAN SAGE") And r = 323 Then
    Cls
    Print "__Mycelian Sage________________________________________________________________"
    Print " A strange entity who's flesh has already began to rot away. It's eye's have"
    Print " sunken in and it's jaw unhinged. This unholy beast craves human flesh."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO MYCELIAN SAGE") And r = 323 Then
    Cls
    Print "__Mycelian Sage________________________________________________________________"
    Print " It let's out a hiss and slowly inches towards you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MYCELIAN SAGE") And r = 328 Then
    Cls
    Print "__Mycelian Sage________________________________________________________________"
    Print " Climbing along the ceiling and walls, it hunts you. A fowl stench coming from"
    Print " it's decaying flesh."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO MYCELIAN SAGE") And r = 328 Then
    Cls
    Print "__Mycelian Sage________________________________________________________________"
    Print " It doesn't respond."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE VOICES") And r = 330 Then
    Cls
    Print "__Voices_______________________________________________________________________"
    Print " You listen and can't make out just what they are trying to say."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SHADOWS") And r = 332 Then
    Cls
    Print "__Shadows______________________________________________________________________"
    Print " Images of people dancing and moving about carrying on with conversations as if"
    Print " they were still here."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ADVENTURER") And r = 344 Then
    Cls
    Print "__Adventurer___________________________________________________________________"
    Print " A tired old soul that appears to be lost within this place. They attempt to"
    Print " stay awake weary of letting themselves fall asleep here."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO ADVENTURER") And r = 344 Then
    Cls
    Print "__Adventurer___________________________________________________________________"
    Print " The shadows, they keep me from sleeping. I'm being tortured by them."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "THE SHADOWS") And r = 344 Then
    Cls
    Print "__Adventurer___________________________________________________________________"
    Print " Their the spirits of those who once lived here. They don't know their dead or"
    Print " maybe its us who are dead. I can't sleep, i'm doomed."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MERMAN") And r = 357 Then
    Cls
    Print "__Merman_______________________________________________________________________"
    Print " It's a fowl beast half man and half fish. It's lingers about in the distance,"
    Print " yearning to feast on your flesh."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO MERMAN") And r = 357 Then
    Cls
    Print "__Merman_______________________________________________________________________"
    Print " It lays out a hiss and shows it's teeth."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE VINES") And r = 361 Then
    Cls
    Print "__Vines________________________________________________________________________"
    Print " They are translucent and move about as if alive."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ADVENTURER") And r = 361 Then
    Cls
    Print "__Adventurer___________________________________________________________________"
    Print " Clad in weathered, tattered clothes, the adventurer leans against the wall,"
    Print " exhausted and barely conscious. Weeks of wandering have left them gaunt and"
    Print " desperate, their eyes hollow from the absence of sunlight."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO ADVENTURER") And r = 361 Then
    Cls
    Print "__Adventurer___________________________________________________________________"
    Print " It's over for me, they mutter weakly. I can't go on. I've been lost here for"
    Print " what feels like a lifetime. Every turn leads nowhere... there's a portal"
    Print " ahead, but heed my warning-leave it be. Get out while you still can."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "PORTAL") And r = 361 Then
    Cls
    Print "__Adventurer___________________________________________________________________"
    Print " A mysterious gateway stands ahead, its swirling depths an invitation into the"
    Print " unknown. No one knows what lies beyond-only that those who enter seldom"
    Print " return."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE AUTOMATION GUARDIAN") And r = 394 Then
    Cls
    Print "__Automation Guardian__________________________________________________________"
    Print " A sleek, statue-like figure, silver in color, with facial features carved to"
    Print " resemble those of a human."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO AUTOMATION GUARDIAN") And r = 394 Then
    Cls
    Print "__Automation Guardian _________________________________________________________"
    Print " It doesn't respond, but you hear the faint sound of gears turning within its"
    Print " body."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FACELESS ENTITY") And r = 399 Then
    Cls
    Print "__Faceless Entity______________________________________________________________"
    Print " An ancient being, as old as this place, crafted by the hands of those who"
    Print " built the clock to ensure its maintenance."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO FACELESS ENTITY") And r = 399 Then
    Cls
    Print "__Faceless Entity______________________________________________________________"
    Print " It doesn't utter a word."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SPIRIT") And r = 404 Then
    Cls
    Print "__Spirit_______________________________________________________________________"
    Print " A tormented apparition, floating in a state of unbearable pain and terror,"
    Print " fading in and out of existence."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO SPIRIT") And r = 404 Then
    Cls
    Print "__Spirit_______________________________________________________________________"
    Print " Leave before it's too late."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WOODSMAN") And r = 409 Then
    Cls
    Print "__Woodsman_____________________________________________________________________"
    Print " A rugged figure clad in clothing designed to blend with the forest, a survivor"
    Print " who knows the land like the back of his hand."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO WOODSMAN") And r = 409 Then
    Cls
    Print "__Woodsman_____________________________________________________________________"
    Print " I see we have another one for the slaughter. But don't let me stop you-you'll"
    Print " find out soon enough."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GOBLIN") And r = 412 Then
    Cls
    Print "__Goblin_______________________________________________________________________"
    Print " A twisted, mutated creature with glowing eyes and the faint stench of death"
    Print " trailing behind it."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GHOUL") And r = 415 Then
    Cls
    Print "__Ghoul________________________________________________________________________"
    Print " Its flesh rots off its bones as it hisses menacingly, clad in the decayed"
    Print " uniform of the King's Guard."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FACELESS ENTITY") And r = 427 Then
    Cls
    Print "__Faceless Entity______________________________________________________________"
    Print " It moves with an unsettling aura of shifting light, existing in a state"
    Print " between the realms of the living and the dead."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO FACELESS ENTITY") And r = 427 Then
    Cls
    Print "__Faceless Entity______________________________________________________________"
    Print " It ignores you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GHOST") And r = 430 Then
    Cls
    Print "__Ghost________________________________________________________________________"
    Print " A spectral figure from another realm, standing in scorched armor that bears"
    Print " the marks of an unknown fire."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "LISTEN TO VOICE") And r = 437 Then
    Cls
    Print "__Voice________________________________________________________________________"
    Print " You hear muffled words-someone pleading desperately for their life."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PRISONER") And r = 486 Then
    Cls
    Print "__Prisoner_____________________________________________________________________"
    Print " Dressed in tattered rags and caked in filth, the prisoner stares at you in"
    Print " shock. You are the first person he has seen in years."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO PRISONER") And r = 486 Then
    Cls
    Print "__Prisoner_____________________________________________________________________"
    Print " He attempts to speak, but his words are silenced-he has no tongue."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE TOAD") And r = 500 Then
    Cls
    Print "__Toad_________________________________________________________________________"
    Print " A monstrous toad looms before you, its slimy, water-slicked skin glistening in"
    Print " the dim light. Blood-red eyes glare at you, and a foul stench hangs heavy in"
    Print " the air. It lets out a guttural, hissing croak that chills you to the bone."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO TOAD") And r = 500 Then
    Cls
    Print "__Toad_________________________________________________________________________"
    Print " The creature doesn't respond, its unblinking gaze fixed on you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE HERMIT") And r = 509 Then
    Cls
    Print "__Hermit_______________________________________________________________________"
    Print " A weary, weathered soul sits before you, draped in patched-together rags. His"
    Print " eyes, clouded with age and suspicion, linger on you with a mix of confusion"
    Print " and curiosity."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO HERMIT") And r = 509 Then
    Cls
    Print "__Hermit_______________________________________________________________________"
    Print " Another fool drawn by the call of the swamp? So, the great Ghurvalis beckons"
    Print " yet another believer."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "GHURVALIS") And r = 509 Then
    Cls
    Print "__Hermit_______________________________________________________________________"
    Print " Ah, yes. He dwells within the swamp, and his children guard me. Have you seen"
    Print " them, stranger?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "CHILDREN") And r = 509 Then
    Cls
    Print "__Hermit_______________________________________________________________________"
    Print " The toads, you fool! They are his sacred offspring. I tend to them for the"
    Print " Lord... or rather, for Lerv."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "LERV") And r = 509 Then
    Cls
    Print "__Hermit_______________________________________________________________________"
    Print " Lerv is the Speaker for the Lord. But he's been gone far too long. If you see"
    Print " him on your journey, tell him I must speak with him at once. It's urgent."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ROBED FIGURE") And r = 529 Then
    Cls
    Print "__Robed Figure_________________________________________________________________"
    Print " A strange being stands before you, cloaked in a tattered black robe that seems"
    Print " nearly as ancient as time itself."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SKELETAL REMAINS") And r = 531 Then
    Cls
    Print "__Skeletal Remains_____________________________________________________________"
    Print " A pile of bones lies in a forlorn heap, their clothing reduced to little more"
    Print " than decayed rags."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SKELETAL REMAINS") And r = 537 Then
    Cls
    Print "__Skeletal Remains_____________________________________________________________"
    Print " A thin layer of dust blankets the skeletal remains. Whatever transpired here"
    Print " remains a grim and silent mystery."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE COCOON") And r = 539 Then
    Cls
    Print "__Cocoon_______________________________________________________________________"
    Print " The cocoon is tightly woven, radiating an intense heat reminiscent of an oven."
    Print " Faint movements from within suggest something is trapped inside."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TOUCH COCOON") And r = 539 Then
    Cls
    Print "__Cocoon_______________________________________________________________________"
    Print " You decide against it; the cocoon is far too hot to handle."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "OPEN COCOON") And r = 539 Then
    Cls
    Print "__Cocoon_______________________________________________________________________"
    Print " Summoning your strength, you slash the cocoon open with your sword. A"
    Print " grotesque gushing sound fills the air as its watery contents spill onto the"
    Print " ground."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CONTENTS") And r = 539 Then
    Cls
    Print "__Cocoon_______________________________________________________________________"
    Print " A horrifying mixture of bones, bile, and partially melted flesh pools at your"
    Print " feet. The sight churns your stomach."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE COCOONS") And r = 545 Then
    Cls
    Print "__Cocoons______________________________________________________________________"
    Print " Several cocoons hang closely together, their contents shifting ever so"
    Print " slightly, as though alive."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "OPEN CACOONS") And r = 545 Then
    Cls
    Print "__Cacoons______________________________________________________________________"
    Print " Best not to do that. You wouldn't want whatever is inside spilling out onto"
    Print " the ground."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BODY") And r = 548 Then
    Cls
    Print "__Body_________________________________________________________________________"
    Print " The desiccated remains of an unfortunate soul lie here, their skin stretched"
    Print " tight and brittle, revealing little more than a husk drained of life."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAINE PRIEST") And r = 550 Then
    Cls
    Print "__Priest_______________________________________________________________________"
    Print " The priest is clad in a makeshift holy robe, pieced together from scraps of"
    Print " clothing scavenged from the surrounding wasteland."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO PRIEST") And r = 550 Then
    Cls
    Print "__Priest_______________________________________________________________________"
    Print " Ah, a new soul, a seeker of the Arach. Come closer and hear the word of truth."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "ARACH") And r = 550 Then
    Cls
    Print "__Priest_______________________________________________________________________"
    Print " Yes, the great creator. It craves not the wealth of material things but the"
    Print " devotion of the mind. For generations, we have worshipped in this sacred"
    Print " place. Now, I am the last... though I believe there may still be others. I"
    Print " have prepared a shrine just beyond this room. You may gaze upon our God with"
    Print " your own eyes."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "GOD") And r = 550 Then
    Cls
    Print "__Priest_______________________________________________________________________"
    Print " Yes, the creator of all-a being who grants life and takes it away. It awaits"
    Print " your arrival."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STREAM") And r = 693 Then
    Cls
    Print "__Stream_______________________________________________________________________"
    Print " A shallow stream rushes over a bed of smooth rocks and silt, its clear waters"
    Print " glinting in the light."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "DRINK FROM STREAM") And r = 693 Then
    Cls
    Print "__Stream_______________________________________________________________________"
    Print " You cup your hands and drink from the fresh, cold water, its crispness"
    Print " invigorating your senses."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE APPRENTICE") And r = 704 Then
    Cls
    Print "__Apprentice___________________________________________________________________"
    Print " Dressed in a flowing black robe, she greets you with a warm smile. Yet, her"
    Print " eyes betray something deeper-secrets, perhaps, or a touch of doubt."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO APPRENTICE") And r = 704 Then
    Cls
    Print "__Apprentice___________________________________________________________________"
    Print " ï¿½You came. We were starting to doubt when-or if-you would arrive.ï¿½"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "LOOKOUT WINDOW") And r = 708 Then
    Cls
    Print "__Window_______________________________________________________________________"
    Print " You gaze out into the endless expanse of the unknown. The stars shimmer and"
    Print " dance across the sky, almost as if alive, whispering secrets of distant"
    Print " realms."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SPECTER") And r = 709 Then
    Cls
    Print "__Specter______________________________________________________________________"
    Print " An ethereal figure drifts about the room, its indistinct form gesturing as"
    Print " though engaged in conversation with an unseen companion."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO SPECTER") And r = 709 Then
    Cls
    Print "__Specter______________________________________________________________________"
    Print " It pays you no mind, continuing its ghostly dialogue as if you weren't even"
    Print " there."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MALTHERA") And r = 718 Then
    Cls
    Print "__Malthera_____________________________________________________________________"
    Print " Draped in flowing black garments and shrouded in swirling mist, Malthera"
    Print " stands before you. Her face ripples and shifts, as though she is struggling to"
    Print " maintain an illusion of humanity."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO MALTHERA") And r = 718 Then
    Cls
    Print "__Malthera_____________________________________________________________________"
    Print " You are Drakhan... champion of the King, savior of Oathmoor, and seeker of"
    Print " destiny. But I am afraid your journey ends here. For you see, I am not"
    Print " Malthera but Vaelthoryn."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "VAELTHORYN") And r = 718 Then
    Cls
    Print "__Vaelthoryn___________________________________________________________________"
    Print " With a sinister grin, Malthera's form begins to twist and contort, revealing"
    Print " her true nature."
    Print ""
    Print " Foolish mortal! You will not survive beyond this point."
    Print ""
    Print " Suddenly, with a deafening roar, Vaelthoryn unleashes a torrent of flames from"
    Print " its gaping maw. Great wings unfurl, stirring the mist into chaos, as the"
    Print " monstrous figure takes flight, circling the room with menacing intent."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SHEEP") And r = 722 Then
    Cls
    Print "__Sheep________________________________________________________________________"
    Print " A flock of innocent sheep grazing peacefully on the lush grass."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WOMAN") And r = 724 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " A weary soul dressed in a vibrant, colorful outfit that harmonizes with the"
    Print " surroundings."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO WOMAN") And r = 724 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " ï¿½We need to speak. A dark force is following you, and you must consult the"
    Print " Priest.ï¿½"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "PRIEST") And r = 724 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " ï¿½He resides at the Temple, south of the valley.ï¿½"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE TRAVELERS") And r = 727 Then
    Cls
    Print "__Travelers____________________________________________________________________"
    Print " A cheerful group of wanderers, wearing whatever they've managed to gather, sit"
    Print " around a campfire sharing stories."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO TRAVELERS") And r = 727 Then
    Cls
    Print "__Travelers____________________________________________________________________"
    Print " The leader steps forward and speaks:"
    Print " ï¿½We mean no harm, traveler. We are but miners, seeking our fortune.ï¿½"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "MINERS") And r = 727 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " ï¿½Yes, we mine for green ore.ï¿½"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "GREEN ORE") And r = 727 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " A precious resource that fuels the world. It brings life to the fields,"
    Print " vitality to the river's fish, and warmth to the fires."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MERCHANTS") And r = 730 Then
    Cls
    Print "__Merchants____________________________________________________________________"
    Print " Exhausted traders working tirelessly to sell their wares to an"
    Print " ever-enthusiastic crowd."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE COWS") And r = 732 Then
    Cls
    Print "__Cows_________________________________________________________________________"
    Print " Black-and-brown-spotted cows graze contentedly, keeping to themselves and"
    Print " enjoying their quiet lives."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MINER") And r = 758 Then
    Cls
    Print "__Miner________________________________________________________________________"
    Print " A tired, overworked soul lost in thought, focused entirely on his labor."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO MINER") And r = 758 Then
    Cls
    Print "__Miner________________________________________________________________________"
    Print " Go away, adventurer. I have no time to gossip."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MINERS") And r = 764 Then
    Cls
    Print "__Miners_______________________________________________________________________"
    Print " A group of miners chips away at the rock, their grunts and the rhythmic"
    Print " clinking of pickaxes filling the air."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO MINERS") And r = 764 Then
    Cls
    Print "__Miners_______________________________________________________________________"
    Print " They ignore you, consumed by their work."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PRIESTESS") And r = 768 Then
    Cls
    Print "__Priestess____________________________________________________________________"
    Print " She is dressed in the holy garments of her faith. Young and serene, she seems"
    Print " almost out of place in this harsh and unforgiving world."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO PRIESTESS") And r = 768 Then
    Cls
    Print "__Priestess____________________________________________________________________"
    Print " Adventurer, what brings you to this place? Are you lost? Do you seek guidance?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "LOST") And r = 768 Then
    Cls
    Print "__Priestess____________________________________________________________________"
    Print " You are in the Glowroot Mine, within a hall of worship. I am Priestess Eryndra"
    Print " Velisaryn, a humble seeker of holy knowledge."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "GUIDANCE") And r = 768 Then
    Cls
    Print "__Priestess____________________________________________________________________"
    Print " If you seek the wisdom of the gods, journey south to the Temple of Knowledge."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MINERS") And r = 770 Then
    Cls
    Print "__Miners_______________________________________________________________________"
    Print " A collection of weary miners labor relentlessly, scraping out a meager"
    Print " existence from the earth's depths."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO MINERS") And r = 770 Then
    Cls
    Print "__Miners_______________________________________________________________________"
    Print " They pay you no mind, wholly absorbed in their toil."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MECHANICAL BEHEMOTH") And r = 797 Then
    Cls
    Print "__Mechanical Behemoth__________________________________________________________"
    Print " A towering figure resembling a statue, yet forged entirely of armor. Its"
    Print " glowing orange eyes burn with an intense light as steam hisses from its"
    Print " joints. The furnace within its chest emits a sound like a tortured, heavy"
    Print " scream, filling the air with an unsettling resonance."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO MECHANICAL BEHEMOTH") And r = 797 Then
    Cls
    Print "__Mechanical Behemoth__________________________________________________________"
    Print " The behemoth responds with the grating noise of rusted metal gears grinding"
    Print " against each other."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GREEN LIGHT") And r = 800 Then
    Cls
    Print "__Green Light__________________________________________________________________"
    Print " A flickering green light dances through the air, moving with an almost"
    Print " sentient grace, as though it were alive."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO GREEN LIGHT") And r = 800 Then
    Cls
    Print "__Green Light__________________________________________________________________"
    Print " Not now, Adventurer. I am seeking the knowledge of the ancients."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE KEEPER OF KNOWLEDGE") And r = 804 Then
    Cls
    Print "__Keeper Of Knowledge__________________________________________________________"
    Print " Before you stands a being that resembles a person, yet it is entirely composed"
    Print " of radiant light. The figure flickers, unstable, as if it could fade out of"
    Print " existence at any moment."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO KEEPER OF KNOWLEDGE") And r = 804 Then
    Cls
    Print "__Keeper Of Knowledge__________________________________________________________"
    Print " Yes, Adventurer, I have waited several lifetimes for someone to arrive. I am"
    Print " the Keeper of Knowledge, and I seek the Key."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "KEY") And r = 804 Then
    Cls
    Print "__Keeper Of Knowledge__________________________________________________________"
    Print " Yes, the Key, Custodian."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "CUSTODIAN") And r = 804 Then
    Cls
    Print "__Keeper Of Knowledge__________________________________________________________"
    Print " The one who holds the Key wields control over the knowledge."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BODY") And r = 834 Then
    Cls
    Print "__Body_________________________________________________________________________"
    Print " The mangled remains of a poor lost soul lie before you. Whoever did this is"
    Print " truly a monster."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "LISTEN TO CONVERSATION") And r = 835 Then
    Cls
    Print "__Conversation_________________________________________________________________"
    Print " You listen closely, and for a moment, you can hear someone whispering about"
    Print " your arrival within their holy sanctuary."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "LISTEN TO CONVERSATION") And r = 841 Then
    Cls
    Print "__Conversation_________________________________________________________________"
    Print " Member 1: ï¿½The dawn of the new age is upon us, Grayb. Rumor has it the Amulet"
    Print " of Whispers is here, and the wizard needs it for the portal."
    Print ""
    Print " ï¿½Member 2: ï¿½The wizard? That fool. It doesn't exist-it's a fool's dream.ï¿½"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CLOAKED FIGURE") And r = 843 Then
    Cls
    Print "__Cloaked Figure_______________________________________________________________"
    Print " Dressed in a black robe, their face is obscured, and they exist somewhere"
    Print " between faith and reality, shrouded in mystery."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO CLOAKED FIGURE") And r = 843 Then
    Cls
    Print "__Cloaked Figure_______________________________________________________________"
    Print " They ignore you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CLOAKED FIGURE") And r = 850 Then
    Cls
    Print "__Cloaked Figure_______________________________________________________________"
    Print " Dressed in a black robe, a foul odor wafts off of them. The stench of death is"
    Print " unmistakable."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO CLOAKED FIGURE") And r = 850 Then
    Cls
    Print "__Cloaked Figure_______________________________________________________________"
    Print " They ignore you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SPIDER") And r = 855 Then
    Cls
    Print "__Spider_______________________________________________________________________"
    Print " A massive beast the size of a man hangs from its web. Its body is white, a"
    Print " stark contrast to the dark realm it inhabits. Its eight eyes glint in the"
    Print " light of your lantern, and it emits an eerie hiss, as if it yearns to feast"
    Print " upon you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BATS") And r = 858 Then
    Cls
    Print "__Bats_________________________________________________________________________"
    Print " Large, winged creatures flit around you, their cries echoing through the"
    Print " shadows. They appear capable of carrying you away but, for now, seem to leave"
    Print " you alone."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FAMILY") And r = 865 Then
    Cls
    Print "__Family_______________________________________________________________________"
    Print " A family resides within this chaotic realm. A mother, father, and daughter sit"
    Print " around a table, their expressions vacant. They appear trapped in a dreamlike"
    Print " trance."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO FAMILY") And r = 865 Then
    Cls
    Print "__Family_______________________________________________________________________"
    Print " They seem unable to move or speak, locked in their trance-like state."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WIZARD") And r = 867 Then
    Cls
    Print "__Wizard_______________________________________________________________________"
    Print " The wizard wears a tattered brown cloak, his face weathered from years of"
    Print " magic that have taken a toll on his body. He looks frail, as though on the"
    Print " brink of death, yet his eyes burn with a desperate hope to unlock the secrets"
    Print " of the unknown realm of magic."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO WIZARD") And r = 867 Then
    Cls
    Print "__Wizard_______________________________________________________________________"
    Print " ï¿½What are you doing here? A stranger? An outsider? Seeking what isn't yours?"
    Print " Foolish adventurer. You will not take the Amulet of Whispers from me.ï¿½"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "AMULET OF WHISPERS") And r = 867 Then
    Cls
    Print "__Wizard_______________________________________________________________________"
    Print " Before you can react, the wizard leaps back, preparing to attack. In his"
    Print " haste, however, he fumbles and fails to cast his spell."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SHADOWY FIGURE") And r = 879 Then
    Cls
    Print "__Shadowy Figure_______________________________________________________________"
    Print " A featureless being, shrouded in mystery. It seems to be nothing more than the"
    Print " spirit of an unknown presence, drifting silently through this forsaken place."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO SHADOWY FIGURE") And r = 879 Then
    Cls
    Print "__Shadowy Figure_______________________________________________________________"
    Print " The figure ignores you, continuing its enigmatic journey without"
    Print " acknowledgment."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "LISTEN TO VOICE") And r = 890 Then
    Cls
    Print "__Voice________________________________________________________________________"
    Print " A disembodied voice echoes through the air, its tone both ominous and"
    Print " foreboding. It warns you to stay away from the gateway, urging you to turn"
    Print " back before you meet a most painful end."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE JUDGE") And r = 912 Then
    Cls
    Print "__Judge________________________________________________________________________"
    Print " Clad in black robes and with a face painted ghostly white, the figure gazes"
    Print " down at you from their perch of authority. For a brief moment, a flicker of"
    Print " confusion crosses their otherwise impassive expression."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO JUDGE") And r = 912 Then
    Cls
    Print "__Judge________________________________________________________________________"
    Print " ÂªYou are not on trial for the crimes of the land. There is no reason to"
    Print " prolong this conversation.Âª"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE AELIRA") And r = 914 Then
    Cls
    Print "__Aelira_______________________________________________________________________"
    Print " She greets you with an unsettling smile, her unblinking gaze fixed firmly on"
    Print " yours. Her attire is strange, almost jarring in its unsuitability for this"
    Print " place, adding to the air of unease she exudes."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO AELIRA") And r = 914 Then
    Cls
    Print "__Aelira_______________________________________________________________________"
    Print " ï¿½You're not from around here, are you? I saw you once before... in the"
    Print " village, before you met with the King. You've come far, haven't you? But let"
    Print " me tell you something, you won't stop her. You can't stop her. Oh no... no,"
    Print " you won't.ï¿½"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SKELETAL FIGURE") And r = 923 Then
    Cls
    Print "__Skeletal Figure______________________________________________________________"
    Print " A pile of dust-covered bones, stripped of flesh and any remnants of clothing."
    Print " Just how long have they been here?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MALTHERA") And r = 925 Then
    Cls
    Print "__Malthera_____________________________________________________________________"
    Print " Draped in flowing red, her cloak billowing as if moved by an unseen force. She"
    Print " stands before you, unnervingly still."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO MALTHERA") And r = 925 Then
    Cls
    Print "__Malthera_____________________________________________________________________"
    Print " You must not walk this path. Turn back, lest you wander the forsaken realm of"
    Print " the damned, before it is too late."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WOMAN") And r = 941 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " She stumbles through the mist, searching desperately for someone. Her skin is"
    Print " pale, her eyes hollow-almost devoid of life."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO WOMAN") And r = 941 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " Edric? Have you seen my Edric?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EDRIC") And r = 941 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " Yes... he is my husband. A soldier. I'm trying to find him... Edric..."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SPECTATOR") And r = 948 Then
    Cls
    Print "__Spectator____________________________________________________________________"
    Print " Draped in fine garments untouched by labor, they stand apart-an observer,"
    Print " detached from the weight of reality itself."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO SPECTATOR") And r = 948 Then
    Cls
    Print "__Spectator____________________________________________________________________"
    Print " Such a senseless waste. I had hoped for more... and now, what am I to do?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE VOICE") And r = 969 Then
    Cls
    Print "__Voice________________________________________________________________________"
    Print " A deep, resonant voice echoes around you, yet its source remains unseen."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ELDER") And r = 973 Then
    Cls
    Print "__Elder________________________________________________________________________"
    Print " Draped in a headdress and a robe fashioned from animal hide, the elder greets"
    Print " you with a warm smile."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO ELDER") And r = 973 Then
    Cls
    Print "__Elder________________________________________________________________________"
    Print " Greetings, Adventurer. It has been foretold that an outsider would come to our"
    Print " village. Please respect our ways and customs-we must live as one."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BIRD") And r = 980 Then
    Cls
    Print "__Bird_________________________________________________________________________"
    Print " A striking red bird perches nearby, scanning the ground intently as it"
    Print " searches for food."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE LABORER") And r = 986 Then
    Cls
    Print "__Laborer______________________________________________________________________"
    Print " Covered in a fine layer of dust, the laborer works tirelessly, focused"
    Print " entirely on the task at hand."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO LABORER") And r = 986 Then
    Cls
    Print "__Laborer______________________________________________________________________"
    Print " He ignores you and continues with his work."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FOREMAN") And r = 988 Then
    Cls
    Print "__Foreman______________________________________________________________________"
    Print " Dressed in finely made clothes, the foreman wears an expression of exhaustion."
    Print " His gaze drifts past you, lost in thought."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO FOREMAN") And r = 988 Then
    Cls
    Print "__Foreman______________________________________________________________________"
    Print " Can't you see I'm busy? I must ensure we have enough wood prepared for the"
    Print " winter. The temple must be built before it's too late."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TEMPLE") And r = 988 Then
    Cls
    Print "__Foreman______________________________________________________________________"
    Print " The temple must be completed to activate the doorway. Only then can we restore"
    Print " the world to what it was before everything failed us."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WORKERS") And r = 993 Then
    Cls
    Print "__Workers______________________________________________________________________"
    Print " A group of workers moves steadily through their daily tasks. Clad in simple,"
    Print " handmade brown garments, they carry on with quiet determination."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO WORKERS") And r = 993 Then
    Cls
    Print "__Workers______________________________________________________________________"
    Print " Sorry, Adventurer, we don't have time to talk. There is much work to be done."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE KEEPER OF THE GUILD") And r = 1020 Then
    Cls
    Print "__Keeper of the Guild__________________________________________________________"
    Print " Shrouded in a flowing black robe, his face obscured by shadow, the Keeper of"
    Print " the Guild regards you with surprise, as if your presence here is wholly"
    Print " unexpected."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO KEEPER OF THE GUILD") And r = 1020 Then
    Cls
    Print "__Keeper of the Guild__________________________________________________________"
    Print " An outsider? Have you been spoken to by the voice of Mirethis?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "MIRETHIS") And r = 1012 Then
    Cls
    Print "__Keeper of the Guild__________________________________________________________"
    Print " The Weeping Mother. She grants protection to those who seek it-through"
    Print " offerings of silver and flesh. You have heard her voice, haven't you?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "YES") And r = 1012 Then
    Cls
    Print "__Keeper of the Guild__________________________________________________________"
    Print " Good. Since the Mother has called you here, you must make an offering at her"
    Print " tomb, far to the south, buried deep in the ice. Go now."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "NO") And r = 1012 Then
    Cls
    Print "__Keeper of the Guild__________________________________________________________"
    Print " Then leave. Leave before the others arrive... or they will tear you apart."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE OLD WOMAN") And r = 1034 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " Dressed in patched-together clothing made from whatever she could find, her"
    Print " face is weathered, each wrinkle a mark of every battle lost in her world."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO OLD WOMAN") And r = 1034 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " An outsider? How can this be? We have been doomed to stay here until she has"
    Print " forgiven us."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "FORGIVEN US") And r = 1034 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " Yes, we, all who remain from this forsaken land. Those who fought in the Great"
    Print " War and were captured-our families-were sent here to die. A reminder of what"
    Print " unwavering dedication can cost."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "GREAT WAR") And r = 1034 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " It was a war born of marriage and fought with the innocent. It has been so"
    Print " cold here lately. Please, does Oathmore still stand?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "YES") And r = 1034 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " Good. My family is originally from there. Now go. I'm tired and need my rest."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FROZEN FIGURE") And r = 1038 Then
    Cls
    Print "__Frozen Figure________________________________________________________________"
    Print " The frozen bodies of those unfortunate enough to die while standing. They"
    Print " remain as a grim testament to the evil forces that haunt this land."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MONK") And r = 1045 Then
    Cls
    Print "__Monk_________________________________________________________________________"
    Print " A weary old man, draped in clothing scavenged from the dead. His exhaustion is"
    Print " not just of the body, but of the soul, worn down by years spent in this frozen"
    Print " tomb of suffering."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO MONK") And r = 1045 Then
    Cls
    Print "__Monk_________________________________________________________________________"
    Print " We have not had a visitor in this village for quite some time. Since I was a"
    Print " child, I believed everything beyond our walls had been erased by that evil"
    Print " witch. We have lived in fear of what lurks beyond the ice. Thank you for"
    Print " giving me hope, but it is too late for me."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CORPSE") And r = 1052 Then
    Cls
    Print "__Corpse_______________________________________________________________________"
    Print " Its flesh is crudely stitched together with needle and thread. Its sunken"
    Print " black eyes stare lifelessly, a stench of decay clinging to its being."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO CORPSE") And r = 1052 Then
    Cls
    Print "__Corpse_______________________________________________________________________"
    Print " Its mouth moves slowly, as if by muscle memory-an imitation of humanity long"
    Print " lost."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MECHANIZED WALKER") And r = 1059 Then
    Cls
    Print "__Mechanized Walker____________________________________________________________"
    Print " A bizarre fusion of metal and flesh, this automaton aimlessly roams the area,"
    Print " performing menial tasks for a faceless master."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO MECHANIZED WALKER") And r = 1059 Then
    Cls
    Print "__Mechanized Walker____________________________________________________________"
    Print " It does not respond. The only sounds are the hiss of steam vents and the"
    Print " grinding of metal joints."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WORKERS") And r = 1062 Then
    Cls
    Print "__Workers______________________________________________________________________"
    Print " Gaunt and lifeless, these weary souls have not seen the sun in what feels like"
    Print " an eternity. Trapped in an endless cycle, they labor without hope."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO WORKERS") And r = 1062 Then
    Cls
    Print "__Workers______________________________________________________________________"
    Print " They ignore you-or perhaps they simply no longer hear."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GUARD") And r = 1066 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " Encased in plated armor, a sword resting at his hip, he watches the workers"
    Print " with a detached gaze."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO GUARD") And r = 1066 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " I understand you are wanted in The Aurelic Foundry. Go there now and meet with"
    Print " the Archmechanist."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "THE AURELIC FOUNDRY") And r = 1066 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " The beating heart of the machine."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "ARCHMECHANIST") And r = 1066 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " Go to her and find out."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WORKERS") And r = 1071 Then
    Cls
    Print "__Workers______________________________________________________________________"
    Print " Dressed in tattered rags and covered in soot, they swing their pickaxes in a"
    Print " mindless rhythm, toiling until the day they fall."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO WORKERS") And r = 1071 Then
    Cls
    Print "__Workers______________________________________________________________________"
    Print " They do not respond."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GUARD") And r = 1077 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " Clad in worn, dented armor, she regards you with a weary expression. A sword"
    Print " dangles from her hip, though she makes no move to draw it."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO GUARD") And r = 1077 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " Go speak with the Archmechanist. She is expecting you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "ARCHMECHANIST") And r = 1077 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " I'm not at liberty to discuss her. Find out for yourself."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MECHANIZED WORKERS") And r = 1085 Then
    Cls
    Print "__Mechanized Workers___________________________________________________________"
    Print " Cloaked in soot, they trudge forward, each step producing the grating sound of"
    Print " metal grinding against metal."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MONEKS") And r = 1092 Then
    Cls
    Print "__Monks________________________________________________________________________"
    Print " Deep in trance, they kneel in prayer, their voices resonant and unyielding,"
    Print " breathing life into this solemn place. Draped in heavy robes, their faces"
    Print " remain hidden, their identities lost to devotion."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MECHANIZED WALKERS") And r = 1100 Then
    Cls
    Print "__Mechanized Walkers___________________________________________________________"
    Print " These towering, spider-like constructs, forged from iron and powered by steam,"
    Print " toil away relentlessly, stripping stone from the ore with mechanical"
    Print " precision."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CLOAKED FIGURE") And r = 1101 Then
    Cls
    Print "__Cloaked Figure_______________________________________________________________"
    Print " A lone figure stands, lost in thought-perhaps the keeper of these strange"
    Print " creations. They wear a deep red robe and remain utterly motionless, as if"
    Print " they, too, are one of the machines."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO CLOAKED FIGURE") And r = 1101 Then
    Cls
    Print "__Cloaked Figure_______________________________________________________________"
    Print " A faint hiss escapes from within the folds of the robe, the only response."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ARCHMECHANIST") And r = 1107 Then
    Cls
    Print "__Archmechanist________________________________________________________________"
    Print " Amidst an array of tools and artifacts, the Archmechanist is consumed by his"
    Print " research. He barely acknowledges your presence, his mind occupied with the"
    Print " mysteries of this forgotten place."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO ARCHMECHANIST") And r = 1107 Then
    Cls
    Print "__Archmechanist________________________________________________________________"
    Print " You have seen too much, outsider. Leave now, or I shall lay you in thy grave."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BROKEN BODIES") And r = 1111 Then
    Cls
    Print "__Broken Bodies________________________________________________________________"
    Print " The remains of fallen workers litter the ground-bones shattered, their"
    Print " lifeless faces frozen in silent agony."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MONK") And r = 1112 Then
    Cls
    Print "__Monk_________________________________________________________________________"
    Print " Battered and broken, this lifeless husk is all that remains-a heap devoid of"
    Print " spirit, abandoned to the darkness."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE KING") And r = 1122 Then
    Cls
    Print "__King_________________________________________________________________________"
    Print " Draped in only the finest garments, the king greets you with a joyful"
    Print " expression."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO KING") And r = 1122 Then
    Cls
    Print "__King_________________________________________________________________________"
    Print " By the stars of Oathmore, it is good to see you again, Drakhan. You have"
    Print " reached the end of your journey. Now, speak the word, and you shall be"
    Print " rewarded."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "WORD") And r = 1122 Then
    Cls
    Print "__King_________________________________________________________________________"
    Print " Yes, yes-the word, Adventurer! Speak it, and the world shall be ours."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE LIFELESS BODY") And r = 1127 Then
    Cls
    Print "__Lifeless Body________________________________________________________________"
    Print " The remains of a fellow adventurer lie motionless-void of life. Clad in a"
    Print " rusted suit of armor, they are covered in dust and draped in cobwebs, long"
    Print " forgotten."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO LIFELESS BODY") And r = 1127 Then
    Cls
    Print "__Lifeless Body________________________________________________________________"
    Print " She's dead."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WOMAN IN BLACK") And r = 1131 Then
    Cls
    Print "__Woman In Black_______________________________________________________________"
    Print " She floats before you, as if controlled by an unseen force. Her hair drifts"
    Print " weightlessly, and her tattered peasant's clothing billows as though suspended"
    Print " in water. Her glowing white eyes pierce the darkness, and the very air around"
    Print " her hums with an intensity that sends sharp pain through your body."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO WOMAN IN BLACK") And r = 1131 Then
    Cls
    Print "__Woman In Black_______________________________________________________________"
    Print " She cackles maniacally at your foolish attempts to speak."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE STONE FIGURE") And r = 1136 Then
    Cls
    Print "__Stone Figure_________________________________________________________________"
    Print " Sculpted from a single, unbroken piece of stone, the figure moves with an"
    Print " uncanny human-like grace. Its face is completely featureless, yet its rigid"
    Print " stance leaves no doubt-it has been ordered to prevent you from proceeding."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO STONE FIGURE") And r = 1136 Then
    Cls
    Print "__Woman In Black_______________________________________________________________"
    Print " It does not respond."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PRIEST") And r = 1141 Then
    Cls
    Print "__Priest_______________________________________________________________________"
    Print " Dressed in a black robe, his weathered face tells a story of devotion and"
    Print " despair. He clings to his beliefs, a lost soul adrift in the remnants of"
    Print " faith."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO PRIEST") And r = 1141 Then
    Cls
    Print "__Priest_______________________________________________________________________"
    Print " It has been a long time since an outsider stepped into this place of worship."
    Print " But soon, all lost souls will find their way back to the light."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE OLD SOUL") And r = 1149 Then
    Cls
    Print "__Old Soul_____________________________________________________________________"
    Print " Wandering these halls for an eternity, they seem completely devoid of humanity"
    Print "just a lost spirit, trapped within this labyrinth."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO OLD SOUL") And r = 1149 Then
    Cls
    Print "__Old Soul_____________________________________________________________________"
    Print " This used to be such a wonderful place. People lived freely, unburdened. But"
    Print " the darkness crept in, and now we cannot shake it."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MALTHERA") And r = 1152 Then
    Cls
    Print "__Malthera_____________________________________________________________________"
    Print " She towers over you, dressed in flowing white. Her hair drifts as if suspended"
    Print " in water, and her pale skin suggests she has not seen the light of day in"
    Print " ages."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO MALTHERA") And r = 1152 Then
    Cls
    Print "__Malthera_____________________________________________________________________"
    Print " I have watched your every step, Drakhan. But you will go no further. Turn back"
    Print " now, or be destroyed. Heed this warning-your next step will decide your fate."
    Print " I have seen many fools in my time, but none so blind as you. Deceived by those"
    Print " you trusted, you have stumbled into a trap of your own making, and now the"
    Print " price must be paid. But before I strike you down and reclaim what is"
    Print " rightfully mine, know this-an era of darkness is upon the world. Fate itself"
    Print " has foretold our meeting, and you are the last obstacle standing between me"
    Print " and my rightful dominion. With your fall, the King will crumble, and soon all"
    Print " kingdoms shall kneel before me. Prepare yourself, for death."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WORSHIPPERS") And r = 1171 Then
    Cls
    Print "__Worshippers__________________________________________________________________"
    Print " Draped in deep purple robes, their faces remain hidden, leaving only their"
    Print " hands to confirm their humanity. They chant in a language unknown to you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO WORSHIPPERS") And r = 1171 Then
    Cls
    Print "__Worshippers__________________________________________________________________"
    Print " Best not to disturb them."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WORSHIPPERS") And r = 1172 Then
    Cls
    Print "__Worshippers__________________________________________________________________"
    Print " Draped in deep purple robes, their faces remain hidden, leaving only their"
    Print " hands to confirm their humanity. They chant in a language unknown to you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO WORSHIPPERS") And r = 1172 Then
    Cls
    Print "__Worshippers__________________________________________________________________"
    Print " Best not to disturb them."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PEOPLE") And r = 1176 Then
    Cls
    Print "__People_______________________________________________________________________"
    Print " They wear ordinary clothing and seem to be celebrating something."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO PEOPLE") And r = 1176 Then
    Cls
    Print "__People_______________________________________________________________________"
    Print " They appear to be in a trance and ignore you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CHEF") And r = 1182 Then
    Cls
    Print "__Chef_________________________________________________________________________"
    Print " Dressed in a worn uniform, they are lost in deep concentration, carefully"
    Print " preparing their next dish."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO CHEF") And r = 1182 Then
    Cls
    Print "__Chef_________________________________________________________________________"
    Print " I've been working on this dish for a day now. It came to me in a dream-the"
    Print " perfect dish to connect body and soul. We must rebuild that bridge, or we are"
    Print " doomed."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "DOOMED") And r = 1182 Then
    Cls
    Print "__Chef_________________________________________________________________________"
    Print " We are cursed. The land is cursed. Now we are lost in the darkness. Something"
    Print " must be done... Someone must act."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WATER FAIRY") And r = 1214 Then
    Cls
    Print "__Water Fairy__________________________________________________________________"
    Print " She rises from the water with an almost supernatural grace, her movements as"
    Print " fluid as the currents themselves. Her eyes, deep and endless black, gleam with"
    Print " ancient wisdom, while her pale blue skin glows softly in the moonlight."
    Print " Suddenly, a blinding white light bursts forth, banishing the shadows and"
    Print " driving away the darkness."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO WATER FAIRY") And r = 1214 Then
    Cls
    Print "__Water Fairy__________________________________________________________________"
    Print " Greetings, fair adventurer. I have awaited this moment for many tides. The"
    Print " darkness shall soon be vanquished, and the light shall once more reign. Take"
    Print " now the blessing of the Prayer of Guidance, and may it lead you upon the true"
    Print " path."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "PRAYER") And r = 1214 Then
    Cls
    Print "__Water Fairy__________________________________________________________________"
    Print " O guiding light upon the waters deep, By silver tide and starlit keep, Let not"
    Print " my vessel stray nor sink, But grant me wisdom, let me think. Where shadows"
    Print " dance and voices fade, Keep my heart unbound, unafraid. With steady hand and"
    Print " spirit bright, Lead me forth into the light."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SPECTRAL FIGURE") And r = 1220 Then
    Cls
    Print "__Spectral Figure______________________________________________________________"
    Print " A shifting entity wanders this plane of existence, its form flickering between"
    Print " the faces of countless souls-some familiar, some lost to time."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO SPECTRAL FIGURE") And r = 1220 Then
    Cls
    Print "__Spectral Figure______________________________________________________________"
    Print " In a chorus of voices, gathered from those who may or may not have ever"
    Print " existed, it urges you to leave this place."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BAT") And r = 1225 Then
    Cls
    Print "__Bat__________________________________________________________________________"
    Print " A massive creature with glowing yellow eyes and razor-sharp teeth cuts through"
    Print " the air, hunting for its next meal."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE DISEMBODIED HEAD") And r = 1229 Then
    Cls
    Print "__Disembodied Head_____________________________________________________________"
    Print " It drifts weightlessly, its translucent form barely tethered to this world."
    Print " Sunken eyes stare vacantly as it releases a scream that chills you to the"
    Print " core."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE DISFIGURED GHOUL") And r = 1286 Then
    Cls
    Print "__Disfigured Ghoul_____________________________________________________________"
    Print " Its limbs are twisted, its skin as gray as thick fog. Its eyes remain hidden,"
    Print " and its tattered rags hang loosely, held together by crude stitches."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO DISFIGURED GHOUL") And r = 1286 Then
    Cls
    Print "__Disfigured Ghoul_____________________________________________________________"
    Print " The ghoul struggles to form a word, but before it can, the distant toll of a"
    Print " bell rings out-its attention shifts instantly, as if compelled by an unseen"
    Print " force."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE THE VENTUREWEAVER") And r = 1314 Then
    Cls
    Print "__The Ventureweaver____________________________________________________________"
    Print " He sits behind an old desk, his fingers moving across the keys of an even"
    Print " older laptop. Lines of forgotten code flicker on the dim screen-the very"
    Print " foundation of the world you now stand in."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO THE VENTUREWEAVER") And r = 1314 Then
    Cls
    Print "__The Ventureweaver____________________________________________________________"
    Print " Greetings, adventurer. You have arrived. You chose not to take the life of"
    Print " Malthera, the witch. In doing so, you have made the honorable choice. And for"
    Print " that, I offer you a piece of wisdom. Patience is the virtue of those who seek"
    Print " the full story before drawing their blade. The greatest heroes are not judged"
    Print " by the speed of their sword, but by the depth of their understanding. To"
    Print " destroy is simple-to listen, to learn, to unveil the hidden truthsï¿½ that is"
    Print " the path of those who shape destiny itself."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MECHANICAL ARM") And r = 1327 Then
    Cls
    Print "__Mechanical Arm_______________________________________________________________"
    Print " Strange, crudely assembled arms extend from the walls-fashioned from jagged,"
    Print " mismatched metal, their design a poor imitation of human limbs."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MACHINIST") And r = 1340 Then
    Cls
    Print "__Machinist____________________________________________________________________"
    Print " Draped in gray, his long hair unkempt, the machinist bears the weary look of a"
    Print " man who has seen too much. Standing atop a crate, he addresses the restless"
    Print " crowd, his voice carrying the weight of revolution."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "LISTEN") And r = 1340 Then
    Cls
    Print "__Machinist____________________________________________________________________"
    Print " We must hold those who govern us to a higher standard, and when they fail us,"
    Print " they must be punished accordingly."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CLEANING WOMAN") And r = 1344 Then
    Cls
    Print "__Cleaning Woman_______________________________________________________________"
    Print " She moves in erratic, twitching motions, each step stiff and unnatural. Half"
    Print " of her face is shattered, exposing a mechanical visage beneath the ruined"
    Print " flesh."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO CLEANING WOMAN") And r = 1344 Then
    Cls
    Print "__Cleaning Woman_______________________________________________________________"
    Print " I must be going... I must be cleaning..."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WOMAN") And r = 1349 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " She dances with an eerie grace, lost in a world of her own-oblivious to your"
    Print " presence, as if reality itself no longer binds her."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO WOMAN") And r = 1349 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " She does not acknowledge you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE OLD WOMAN") And r = 1350 Then
    Cls
    Print "__Old Woman____________________________________________________________________"
    Print " Wrapped in a tattered blanket, she rocks gently in her chair, her aged face"
    Print " illuminated by the flickering light of the hut. She has spent countless days"
    Print " here, simply enduring. At the sight of you, her expression brightens."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO OLD WOMAN") And r = 1350 Then
    Cls
    Print "__Old Woman____________________________________________________________________"
    Print " Well now, I never expected to see another soul. At least... a real soul."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "REAL SOUL") And r = 1350 Then
    Cls
    Print "__Old Woman____________________________________________________________________"
    Print " You are human, yes? We may look it, but in truth, we are nothing more than"
    Print " gears within metal shells. I have never known the taste of food... a shame, I"
    Print " think."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BUTCHER") And r = 1359 Then
    Cls
    Print "__Butcher______________________________________________________________________"
    Print " Wearing a bloodstained leather apron, the butcher waves a massive knife"
    Print " through the air with unsettling precision."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO BUTCHER") And r = 1359 Then
    Cls
    Print "__Butcher______________________________________________________________________"
    Print " I must ensure the meat never stops. I'm too busy right now to talk-come back"
    Print " later."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE DRUNKEN COOK") And r = 1365 Then
    Cls
    Print "__Drunken Cook_________________________________________________________________"
    Print " His uniform is disheveled, his hair an unkempt mess. He clutches a wooden cup"
    Print " sloshing with beer, spilling its contents onto the table as he bellows a tune"
    Print " from a long-forgotten bard."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FIGURE") And r = 1375 Then
    Cls
    Print "__Figure_______________________________________________________________________"
    Print " A strange individual stands before you. Something about them feels... off. The"
    Print " foul stench of death clings to the air. She seems almost surprised to see you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO FIGURE") And r = 1375 Then
    Cls
    Print "__Figure_______________________________________________________________________"
    Print " She simply stands there, breathing heavily, as if preparing for battle."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE RATCATCHER") And r = 1390 Then
    Cls
    Print "__Ratcatcher___________________________________________________________________"
    Print " Draped in tattered rags, their face hidden in shadow, the Ratcatcher seems"
    Print " almost startled by your presence."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO RATCATCHER") And r = 1390 Then
    Cls
    Print "__Ratcatcher___________________________________________________________________"
    Print " You're the first person I've seen in a long time. I thought I was the only one"
    Print " left wandering this wretched place."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MURGLOTH") And r = 1392 Then
    Cls
    Print "__Murgloth_____________________________________________________________________"
    Print " A strange, almost serpent-like creature, the Murgloth has claimed this place"
    Print " as its own-and it has no intention of sharing."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FIGURE") And r = 1397 Then
    Cls
    Print "__Figure_______________________________________________________________________"
    Print " Sunken yellow eyes peer at you from a grotesque, misshapen skull, their gaze"
    Print " unblinking and unnerving."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SKELETON WARRIOR") And r = 1398 Then
    Cls
    Print "__Skeleton Warrior_____________________________________________________________"
    Print " Clad in ancient, rusted battle armor and gripping a timeworn sword, the"
    Print " Skeleton Warrior moves with unnatural speed, as if possessed by a vengeful"
    Print " spirit."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MARROWKRAKE") And r = 1401 Then
    Cls
    Print "__Marrowkrake__________________________________________________________________"
    Print " A massive sea serpent clad in bone-like armor, its eyeless visage betrays no"
    Print " emotion as it slithers through the ruins, searching for its next meal-you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE VERDANT HUSK") And r = 1414 Then
    Cls
    Print "__Verdant Husk_________________________________________________________________"
    Print " A strange, godless creature shrouded in moss, its form barely resembling what"
    Print " it once was. Its muffled screams are the last remnants of its lost humanity."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SELITH") And r = 1420 Then
    Cls
    Print "__Selith_______________________________________________________________________"
    Print " She stands before you, her hair flowing as if caught in an unseen breeze. It"
    Print " is clear-she has been waiting for you in this forsaken place."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO SELITH") And r = 1420 Then
    Cls
    Print "__Selith_______________________________________________________________________"
    Print " It has been ages since your return. Head north to speak with Galyn."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SLIME") And r = 1431 Then
    Cls
    Print "__Slime________________________________________________________________________"
    Print " A shifting, blue mass paces back and forth, trapped in an endless loop-as if"
    Print " caught between worlds."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE RAVEN") And r = 1437 Then
    Cls
    Print "__Raven________________________________________________________________________"
    Print " The raven's eyes gleam with unnatural malice. It moves erratically, as if"
    Print " possessed by a dark force."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MECHANICAL ARM") And r = 1327 Then
    Cls
    Print "__Mechanical Arm_______________________________________________________________"
    Print " Strange, crudely assembled arms extend from the walls-fashioned from jagged,"
    Print " mismatched metal, their design a poor imitation of human limbs."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MACHINIST") And r = 1340 Then
    Cls
    Print "__Machinist____________________________________________________________________"
    Print " Draped in gray, his long hair unkempt, the machinist bears the weary look of a"
    Print " man who has seen too much. Standing atop a crate, he addresses the restless"
    Print " crowd, his voice carrying the weight of revolution."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "LISTEN") And r = 1340 Then
    Cls
    Print "__Machinist____________________________________________________________________"
    Print " We must hold those who govern us to a higher standard, and when they fail us,"
    Print " they must be punished accordingly."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CLEANING WOMAN") And r = 1344 Then
    Cls
    Print "__Cleaning Woman_______________________________________________________________"
    Print " She moves in erratic, twitching motions, each step stiff and unnatural. Half"
    Print " of her face is shattered, exposing a mechanical visage beneath the ruined"
    Print " flesh."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO CLEANING WOMAN") And r = 1344 Then
    Cls
    Print "__Cleaning Woman_______________________________________________________________"
    Print " I must be going... I must be cleaning..."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WOMAN") And r = 1349 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " She dances with an eerie grace, lost in a world of her own-oblivious to your"
    Print " presence, as if reality itself no longer binds her."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO WOMAN") And r = 1349 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " She does not acknowledge you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE OLD WOMAN") And r = 1350 Then
    Cls
    Print "__Old Woman____________________________________________________________________"
    Print " Wrapped in a tattered blanket, she rocks gently in her chair, her aged face"
    Print " illuminated by the flickering light of the hut. She has spent countless days"
    Print " here, simply enduring. At the sight of you, her expression brightens."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO OLD WOMAN") And r = 1350 Then
    Cls
    Print "__Old Woman____________________________________________________________________"
    Print " Well now, I never expected to see another soul. At least... a real soul."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "REAL SOUL") And r = 1350 Then
    Cls
    Print "__Old Woman____________________________________________________________________"
    Print " You are human, yes? We may look it, but in truth, we are nothing more than"
    Print " gears within metal shells. I have never known the taste of food... a shame, I"
    Print " think."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE BUTCHER") And r = 1359 Then
    Cls
    Print "__Butcher______________________________________________________________________"
    Print " Wearing a bloodstained leather apron, the butcher waves a massive knife"
    Print " through the air with unsettling precision."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO BUTCHER") And r = 1359 Then
    Cls
    Print "__Butcher______________________________________________________________________"
    Print " I must ensure the meat never stops. I'm too busy right now to talk-come back"
    Print " later."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE DRUNKEN COOK") And r = 1365 Then
    Cls
    Print "__Drunken Cook_________________________________________________________________"
    Print " His uniform is disheveled, his hair an unkempt mess. He clutches a wooden cup"
    Print " sloshing with beer, spilling its contents onto the table as he bellows a tune"
    Print " from a long-forgotten bard."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FIGURE") And r = 1375 Then
    Cls
    Print "__Figure_______________________________________________________________________"
    Print " A strange individual stands before you. Something about them feels... off. The"
    Print " foul stench of death clings to the air. She seems almost surprised to see you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO FIGURE") And r = 1375 Then
    Cls
    Print "__Figure_______________________________________________________________________"
    Print " She simply stands there, breathing heavily, as if preparing for battle."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE RATCATCHER") And r = 1390 Then
    Cls
    Print "__Ratcatcher___________________________________________________________________"
    Print " Draped in tattered rags, their face hidden in shadow, the Ratcatcher seems"
    Print " almost startled by your presence."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO RATCATCHER") And r = 1390 Then
    Cls
    Print "__Ratcatcher___________________________________________________________________"
    Print " You're the first person I've seen in a long time. I thought I was the only one"
    Print " left wandering this wretched place."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MURGLOTH") And r = 1392 Then
    Cls
    Print "__Murgloth_____________________________________________________________________"
    Print " A strange, almost serpent-like creature, the Murgloth has claimed this place"
    Print " as its own-and it has no intention of sharing."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE FIGURE") And r = 1397 Then
    Cls
    Print "__Figure_______________________________________________________________________"
    Print " Sunken yellow eyes peer at you from a grotesque, misshapen skull, their gaze"
    Print " unblinking and unnerving."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SKELETON WARRIOR") And r = 1398 Then
    Cls
    Print "__Skeleton Warrior_____________________________________________________________"
    Print " Clad in ancient, rusted battle armor and gripping a timeworn sword, the"
    Print " Skeleton Warrior moves with unnatural speed, as if possessed by a vengeful"
    Print " spirit."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MARROWKRAKE") And r = 1401 Then
    Cls
    Print "__Marrowkrake__________________________________________________________________"
    Print " A massive sea serpent clad in bone-like armor, its eyeless visage betrays no"
    Print " emotion as it slithers through the ruins, searching for its next meal-you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE VERDANT HUSK") And r = 1414 Then
    Cls
    Print "__Verdant Husk_________________________________________________________________"
    Print " A strange, godless creature shrouded in moss, its form barely resembling what"
    Print " it once was. Its muffled screams are the last remnants of its lost humanity."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SELITH") And r = 1420 Then
    Cls
    Print "__Selith_______________________________________________________________________"
    Print " She stands before you, her hair flowing as if caught in an unseen breeze. It"
    Print " is clear-she has been waiting for you in this forsaken place."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO SELITH") And r = 1420 Then
    Cls
    Print "__Selith_______________________________________________________________________"
    Print " It has been ages since your return. Head north to speak with Galyn."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SLIME") And r = 1431 Then
    Cls
    Print "__Slime________________________________________________________________________"
    Print " A shifting, blue mass paces back and forth, trapped in an endless loop-as if"
    Print " caught between worlds."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE RAVEN") And r = 1437 Then
    Cls
    Print "__Raven________________________________________________________________________"
    Print " The raven's eyes gleam with unnatural malice. It moves erratically, as if"
    Print " possessed by a dark force."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "LISTEN") And r = 1448 Then
    Cls
    Print "__The Leader___________________________________________________________________"
    Print " The archway is nearly complete. We stand on the cusp of bringing forth the"
    Print " Dark Mother into our world. Another voice, uncertain, interrupts."
    Print ""
    Print " Why hasn't she arrived yet?"
    Print ""
    Print " A pause. Then, a calm but resolute reply:"
    Print ""
    Print " We are sending one of the faithless to venture forth. If his sacrifice is"
    Print " worthy, she will come."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE THE LEADER") And r = 1450 Then
    Cls
    Print "__The Leader___________________________________________________________________"
    Print " Draped in a tattered red robe, she stands motionless. Her face is swallowed by"
    Print " the darkness, leaving only her hands visible-thin, deliberate, waiting."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO THE LEADER") And r = 1450 Then
    Cls
    Print "__The Leader___________________________________________________________________"
    Print " Best not to draw attention to yourself."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CLOAKED FIGURES") And r = 1450 Then
    Cls
    Print "__Cloaked Figured______________________________________________________________"
    Print " Dressed in simple brown robes, they shift restlessly, barely able to contain"
    Print " their excitement over the news they have just received."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO CLOAKED FIGURES") And r = 1450 Then
    Cls
    Print "__Cloaked Figures______________________________________________________________"
    Print " Best not to draw attention to yourself."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GODS GUARD") And r = 1454 Then
    Cls
    Print "__God's Guard__________________________________________________________________"
    Print " Clad in a pristine suit of golden armor, the figure stands unmoving. Its face"
    Print " is pale, its hollow eyes fixed forward, unseeing yet unnerving."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO GODS GUARD") And r = 1454 Then
    Cls
    Print "__God's Guard__________________________________________________________________"
    Print " It just stands there in silence."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE GUARD") And r = 1465 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " Wearing worn leather armor, the guard grips a rope tightly, its other end"
    Print " bound around the wrists of a prisoner."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO GUARD") And r = 1465 Then
    Cls
    Print "__Guard________________________________________________________________________"
    Print " Move along."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PRISONER") And r = 1465 Then
    Cls
    Print "__Prisoner_____________________________________________________________________"
    Print " His face is weary, the look of a man who hasn't slept in ages. His voice is"
    Print " quiet, yet edged with desperation."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO PRISONER") And r = 1465 Then
    Cls
    Print "__Prisoner_____________________________________________________________________"
    Print " I'm being sent to lure out the Dark Mother... My family-they don't know I'm"
    Print " here. Please, you must tell them about me."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "DARK MOTHER") And r = 1465 Then
    Cls
    Print "__Prisoner_____________________________________________________________________"
    Print " She is the giver of life, the bringer of light... and not real. But hey, if"
    Print " they hadn't caught me, I wouldn't be here."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "FAMILY") And r = 1465 Then
    Cls
    Print "__Prisoner_____________________________________________________________________"
    Print " They live in the village of Coe."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "CAUGHT") And r = 1465 Then
    Cls
    Print "__Prisoner_____________________________________________________________________"
    Print " They found me a few nights ago. One too many ales, and I thought it'd be funny"
    Print " if someone joked about the Dark Mother not being real. Next thing I knew-here"
    Print " I am."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE YOUNG WOMAN") And r = 1475 Then
    Cls
    Print "__Young Woman__________________________________________________________________"
    Print " She tends to her meal over a slow-burning fire, her face etched with"
    Print " exhaustion."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MOTHER") And r = 1480 Then
    Cls
    Print "__Mother_______________________________________________________________________"
    Print " She gestures for you to sit by the fire, her presence a rare kindness in this"
    Print " forsaken place. She has been here for quite some time."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO MOTHER") And r = 1480 Then
    Cls
    Print "__Mother_______________________________________________________________________"
    Print " Get warm by the fire. It's always good to see a friendly face in these parts."
    Print " Not many come through here-just the people from below."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "BELOW") And r = 1480 Then
    Cls
    Print "__Mother_______________________________________________________________________"
    Print " Once, my people lived among the clouds with the gods. Now we are few. When the"
    Print " weather changed, the rest sought refuge in the crypt... but all they found was"
    Print " madness. It poisoned them, you see."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "POISONED") And r = 1480 Then
    Cls
    Print "__Mother_______________________________________________________________________"
    Print " The gods abandoned this place for a reason. A great sickness came from it. The"
    Print " archway has always been the bringer of death."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "ARCHWAY") And r = 1480 Then
    Cls
    Print "__Mother_______________________________________________________________________"
    Print " It is a gateway between worlds. It brought you here, and it must be destroyed."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE HOLY MAN") And r = 1495 Then
    Cls
    Print "__Holy Man_____________________________________________________________________"
    Print " What was once a robe of spiritual prestige now hangs in tatters, reduced to"
    Print " little more than rags."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO HOLY MAN") And r = 1495 Then
    Cls
    Print "__Holy Man_____________________________________________________________________"
    Print " The realms of the living and the dead will forever be in conflict. Heed my"
    Print " warning, stranger-leave this cursed place while you still can."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PRIESTS REMAINS") And r = 1499 Then
    Cls
    Print "__Priest's Remains_____________________________________________________________"
    Print " The withered husk of a priest lies here, his robes still draped over his"
    Print " lifeless form. A once-devout servant, now abandoned in the garden of his gods."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ELDER") And r = 1502 Then
    Cls
    Print "__Elder________________________________________________________________________"
    Print " She wears faded, colorful cloth, her face adorned with painted markings. Eyes"
    Print " closed, she sways slightly-deep in a trance."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO ELDER") And r = 1502 Then
    Cls
    Print "__Elder________________________________________________________________________"
    Print " This place is steeped in unrest, -she murmurs-. The spirits cry out for peace,"
    Print " and I must listen... I must speak to them and guide them to rest."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PALADIN") And r = 1531 Then
    Cls
    Print "__Paladin______________________________________________________________________"
    Print " She has never ventured beyond this holy place, dedicating herself to the"
    Print " ancient teachings in order to protect them."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO PALADIN") And r = 1531 Then
    Cls
    Print "__Paladin______________________________________________________________________"
    Print " Mother. Go to Mother now."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "MOTHER") And r = 1531 Then
    Cls
    Print "__Paladin______________________________________________________________________"
    Print " Go."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MOTHER") And r = 1533 Then
    Cls
    Print "__Mother_______________________________________________________________________"
    Print " Draped in a handwoven cloak, her dimly glowing eyes hold the weight of a"
    Print " lifetime spent in isolation. She has never seen the real world."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO MOTHER") And r = 1533 Then
    Cls
    Print "__Mother_______________________________________________________________________"
    Print " You seek knowledge? You choose life over death, to spare one so another may"
    Print " speak. I know you. I know what you seek-the ultimate truth. But for that, you"
    Print " must speak the name of the one you seek. Head north of the crossing, and you"
    Print " will find your answer."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PALADIN") And r = 1536 Then
    Cls
    Print "__Paladin______________________________________________________________________"
    Print " Clad in blessed armor, he meets your gaze with the stern focus of a man on"
    Print " official duty."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO PALADIN") And r = 1536 Then
    Cls
    Print "__Paladin______________________________________________________________________"
    Print " We've been under the knife for some time now. The wolves are closing in. It"
    Print " won't be long before the final battle begins. Leave now-I don't want you here"
    Print " when the carnage starts."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE KNIGHT") And r = 1539 Then
    Cls
    Print "__Knight_______________________________________________________________________"
    Print " His armor, dented and scratched, has seen better days. He stands on guard,"
    Print " hardened by a lifetime of battle."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO KNIGHT") And r = 1539 Then
    Cls
    Print "__Knight_______________________________________________________________________"
    Print " You must leave this place. The darkness is upon us."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SKELETAL FIGURE") And r = 1551 Then
    Cls
    Print "__Skeletal Figure______________________________________________________________"
    Print " The remains of a lost soul-only brittle bones endure, a silent testament to"
    Print " their forgotten existence."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WOMAN") And r = 1557 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " She drifts through a world of her own, singing softly for an audience of one."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO WOMAN") And r = 1557 Then
    Cls
    Print "__Woman________________________________________________________________________"
    Print " She pays you no mind, utterly consumed by her performance."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SOLDIER") And r = 1560 Then
    Cls
    Print "__Soldier______________________________________________________________________"
    Print " With weary eyes and a hollow stare, he stands at the brink of desertion, his"
    Print " spirit worn thin."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO SOLDIER") And r = 1560 Then
    Cls
    Print "__Soldier______________________________________________________________________"
    Print " He ignores you, gazing into the distance, lost in thought."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE LONE FIGURE") And r = 1567 Then
    Cls
    Print "__Lone Figure__________________________________________________________________"
    Print " Clad in armor fashioned from the remnants of spiders, his face is concealed"
    Print " beneath the withered husk of another."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO LONE FIGURE") And r = 1567 Then
    Cls
    Print "__Lone Figure__________________________________________________________________"
    Print " ï¿½The Spider has given us shelter. Those blessed with life are among the chosen"
    Print " privileged to dwell with the gods.ï¿½"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "GODS") And r = 1567 Then
    Cls
    Print "__Lone Figure__________________________________________________________________"
    Print " ï¿½Yes, they are the Life Choosers, the Life Protectors. They feed, they watch,"
    Print " they decide.ï¿½"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CALLING BIRD") And r = 1574 Then
    Cls
    Print "__Calling Bird_________________________________________________________________"
    Print " A massive bird soars in the distance, its haunting call weaving a melody that"
    Print " tingles the senses."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SHADOWY FIGURE") And r = 1577 Then
    Cls
    Print "__Shadowy Figure_______________________________________________________________"
    Print " Hidden within the darkness, its form barely discernible. It blends seamlessly"
    Print " into the world around it, an enigma lurking just out of reach."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO SHADOWY FIGURE") And r = 1577 Then
    Cls
    Print "__Shadowy Figure_______________________________________________________________"
    Print " It ignores you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WORKERS") And r = 1585 Then
    Cls
    Print "__Workers______________________________________________________________________"
    Print " Covered in dust and lost in a trance, they move methodically, expanding this"
    Print " place with whatever tools they have scavenged."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO WORKERS") And r = 1585 Then
    Cls
    Print "__Workers______________________________________________________________________"
    Print " They are too busy to acknowledge you."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ROBED FIGURES") And r = 1591 Then
    Cls
    Print "__Robed Figures________________________________________________________________"
    Print " Draped in black robes, they appear deep in prayer, chanting in a language"
    Print " unknown to the outside world."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO ROBED FIGURES") And r = 1591 Then
    Cls
    Print "__Robed Figures________________________________________________________________"
    Print " Best not to interrupt them."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE YOUNG WOMAN") And r = 1592 Then
    Cls
    Print "__Young Woman__________________________________________________________________"
    Print " Clad in flowing blue garments, her long black hair cascading over her"
    Print " shoulders, she greets you with a warm, knowing smile."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO YOUNG WOMAN") And r = 1592 Then
    Cls
    Print "__Young Woman__________________________________________________________________"
    Print " If you seek the truth, head north into the unknown realm."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE OLD MAN") And r = 1595 Then
    Cls
    Print "__Old Man______________________________________________________________________"
    Print " A weary soul, trapped within a realm of darkness, his eyes searching"
    Print " desperately for something-anything-to eat."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO OLD MAN") And r = 1595 Then
    Cls
    Print "__Old Man______________________________________________________________________"
    Print " Are you one of them? No, no, you can't be. You'd be busy eating one of those,"
    Print " things. Nah, just another sick mind lost to the void."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE ORB") And r = 1605 Then
    Cls
    Print "__Orb__________________________________________________________________________"
    Print " It floats before you, radiating a soft, warm glow, pulsing as if alive."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SKELETAL REMAINS") And r = 1607 Then
    Cls
    Print "__Skeletal Remains_____________________________________________________________"
    Print " The weathered bones of a long-forgotten soul, scattered remnants of a life"
    Print " lost to time."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE LAMBS") And r = 1641 Then
    Cls
    Print "__Lambs________________________________________________________________________"
    Print " They wander peacefully, calling out to one another as they explore their"
    Print " surroundings."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PEOPLE") And r = 1642 Then
    Cls
    Print "__People_______________________________________________________________________"
    Print " Lost in conversation, they carry on as if unaware of your presence."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE PLANT") And r = 1643 Then
    Cls
    Print "__Plant________________________________________________________________________"
    Print " It shifts restlessly, as though yearning for more sunlight. A strange odor"
    Print " wafts from its leaves."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MONK") And r = 1664 Then
    Cls
    Print "__Monk_________________________________________________________________________"
    Print " He works frantically, his mind clearly unhinged. He reeks of a barn and wears"
    Print " an old, filthy cloak."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO MONK") And r = 1664 Then
    Cls
    Print "__Monk_________________________________________________________________________"
    Print " He shoots you a bewildered glance, as if incredulous that you'd interrupt him."
    Print " Muttering to himself, he continues without pause: -I need a pot of water..."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MONK") And r = 1669 Then
    Cls
    Print "__Monk_________________________________________________________________________"
    Print " Draped in a brown robe, his body has long since turned to dust-a silent,"
    Print " crumbling reminder of what once was."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE OLD WOMAN") And r = 1680 Then
    Cls
    Print "__Old Woman____________________________________________________________________"
    Print " She is a weary soul, left alone to fade away in this sorrowful place."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO OLD WOMAN") And r = 1680 Then
    Cls
    Print "__Old Woman____________________________________________________________________"
    Print " It's nice to see another soul here. Everything around me is just a reminder of"
    Print " death."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SHADOWS") And r = 1684 Then
    Cls
    Print "__Shadows______________________________________________________________________"
    Print " Dark figures flicker and twist before you, moving as if alive."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE MONK") And r = 1687 Then
    Cls
    Print "__Monk_________________________________________________________________________"
    Print " Draped in a cobweb-covered robe, the monkï¿½s remains rest here in undisturbed"
    Print " silence."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE HUNTER") And r = 1699 Then
    Cls
    Print "__Hunter_______________________________________________________________________"
    Print " Covered in soot and dirt, she greets you with a stony expression."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO HUNTER") And r = 1699 Then
    Cls
    Print "__Hunter_______________________________________________________________________"
    Print " Haven't seen many people in these parts for quite some time. The hunting's"
    Print " been good."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE CLOAKED FIGURE") And r = 1741 Then
    Cls
    Print "__Cloaked Figure_______________________________________________________________"
    Print " An enigmatic figure draped in a dark, tattered cloak moves silently, face"
    Print " obscured by shadow. Their presence radiates a quiet menace, and every movement"
    Print " seems deliberate yet mysterious."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO CLOAKED FIGURE") And r = 1741 Then
    Cls
    Print "__Cloaked Figure_______________________________________________________________"
    Print " Ah, I see an adventurer has discovered this place. You're a long way from"
    Print " home. If it is wisdom you seek, the Chief is the one you must speak to."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE VILLAGE CHIEF") And r = 1748 Then
    Cls
    Print "__Village Chief________________________________________________________________"
    Print " Seated proudly upon an ornate throne, the village chief commands respect. Age"
    Print " lines his weathered face, wisdom gleams in his eyes, and his words carry the"
    Print " weight of generations."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO VILLAGE CHIEF") And r = 1748 Then
    Cls
    Print "__Village Chief________________________________________________________________"
    Print " You must be weary, fair adventurer. The world you seek was long ago erased by"
    Print " the hands of time. With every step forward, the past swallows what you've left"
    Print " behind. There is no going back-only by pressing on will you find solace. I was"
    Print " once like you: a tired soul wandering through forgotten lands, seeking"
    Print " knowledge and yearning for the treasures of the lost. But in time, I realized"
    Print " I wasn't searching for relics-I was running from myself. No one can tell you"
    Print " who you are or what you're truly seeking. That truth is yours alone to"
    Print " uncover. So I ask you, adventurer-how far are you willing to travel into the"
    Print " unknown?"
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE COACHMAN") And r = 1749 Then
    Cls
    Print "__Coachman_____________________________________________________________________"
    Print " The weary driver sits atop an old farm wagon, reins held loosely in calloused"
    Print " hands. He observes his surroundings with quiet patience, accustomed to long"
    Print " journeys and silent contemplation."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE SENTRY") And r = 1751 Then
    Cls
    Print "__Sentry_______________________________________________________________________"
    Print " A vigilant sentry stands watchful, armor gleaming faintly despite numerous"
    Print " scratches and dents from past battles. His steady gaze pierces through you,"
    Print " alert and unwavering."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "TALK TO SENTRY") And r = 1751 Then
    Cls
    Print "__Sentry_______________________________________________________________________"
    Print " Move along."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
End If
If (cmd$ = "EXAMINE WEARY OLD SOUL") And r = 1762 Then
    Cls
    Print "__Weary Old Soul_______________________________________________________________"
    Print " An aged figure stands hunched and weary, eyes distant and clouded by countless"
    Print " years. They carry the burden of unspoken sorrows, worn down by a world that"
    Print " offers little respite."
    Do: Loop Until InKey$ = ""
    Do: Loop Until InKey$ <> ""
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

'''End Code
'''''''''''''''''''''''''''''''''''''''''''
If (cmd$ = "USE FIVE TREASURES") Or (cmd$ = "USE TREASURES") And gotshard = 1 And gotrelic = 1 And gotcrown = 1 And gotoryn = 1 And gottear = 1 And r = 1152 Then
    GoTo win
End If

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
Print "  You step through and find yourself back where your quest began—only the"
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

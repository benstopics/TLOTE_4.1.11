import json

def parse_rooms(filename):
    with open(filename, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    max_rooms = int(lines[0].strip())
    rooms = {}

    line_idx = 1
    for room_num in range(1, max_rooms + 1):
        # Find start marker
        start_marker = f"--ROOM {room_num} START--"
        end_marker = f"--ROOM {room_num} END--"

        while line_idx < len(lines) and lines[line_idx].strip() != start_marker:
            line_idx += 1

        if line_idx >= len(lines):
            raise ValueError(f"Error: Start marker not found for room {room_num}")

        line_idx += 1  # Skip start marker
        buffer_lines = []

        while line_idx < len(lines) and lines[line_idx].strip() != end_marker:
            buffer_lines.append(lines[line_idx].rstrip('\n'))
            line_idx += 1

        if line_idx >= len(lines):
            raise ValueError(f"Error: End marker not found for room {room_num}")

        if len(buffer_lines) < 2:
            raise ValueError(f"Error: Missing title or exit line for room {room_num}")

        # Extract title
        title = buffer_lines[0]

        # Extract exits
        exits_line = buffer_lines[1]
        exits = [int(x.strip()) if x.strip().isdigit() else 0 for x in exits_line.split(",")]
        
        if len(exits) < 4:
            print(f"Error parsing exits for room {room_num}: {exits_line}")
            exits = [0, 0, 0, 0]

        # Extract description (remaining lines)
        description = "\n".join(buffer_lines[2:]) if len(buffer_lines) > 2 else ""

        room_obj = {
            "title": title,
            "description": description,
            "northExit": int(exits[0]),
            "southExit": int(exits[1]),
            "eastExit": int(exits[2]),
            "westExit": int(exits[3])
        }

        rooms[int(room_num)] = room_obj
        line_idx += 1  # Move past END marker

    return rooms

hardcoded_room_lookup = {
    "shard": 71,
    "relic": 126,
    "crown": 186,
    "oryn": 248,
    "tear": 298,
    "heart": 392,
    "chalice": 468,
    "mirror": 506,
    "shield": 642,
    "gauntlet": 710,
    "amuletofwhispers": 867,
    "amuletofshadows": 897,
    "amuletofthecelestialkey": 926,
    "amuletofwildsong": 991,
    "amuletoftheshiftingsands": 1119,
    "theechoesoflostages": 47,
    "theserpentscanticle": 103,
    "thearchitectsoath": 294,
    "thefleshandshadow": 407,
    "thelabyrinthsbreath": 669,
    "themoonthatwatches": 755,
    "thegildedprison": 901,
    "theunwrittentestament": 1101,
}

def parse_interactions(filename):
    with open(filename, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    max_interactions = int(lines[0].strip())
    interactions = []

    line_idx = 1
    for interaction_num in range(1, max_interactions + 1):
        # Find start marker
        start_marker = "--COMMAND START--"
        end_marker = "--COMMAND END--"

        while line_idx < len(lines) and lines[line_idx].strip() != start_marker:
            line_idx += 1

        if line_idx >= len(lines):
            raise ValueError(f"Error: Start marker not found for interaction {interaction_num}")

        line_idx += 1  # Skip start marker
        buffer_lines = []

        while line_idx < len(lines) and lines[line_idx].strip() != end_marker:
            buffer_lines.append(lines[line_idx].rstrip('\n'))
            line_idx += 1

        if line_idx >= len(lines):
            raise ValueError(f"Error: End marker not found for interaction {interaction_num}")

        if len(buffer_lines) < 5:
            raise ValueError(f"Error: Missing data for interaction {interaction_num}")

        command_string = buffer_lines[0]
        required_room = int(buffer_lines[1])
        required_item = buffer_lines[2]
        if required_item.startswith("got"):
            required_item = required_item[3:].strip()
        title_line = buffer_lines[3]
        display_text = buffer_lines[4]

        if required_room < 0 and required_item in hardcoded_room_lookup:
            required_room = hardcoded_room_lookup[required_item]

        interaction_obj = {
            "commandString": command_string,
            "requiredRoom": required_room,
            **({"requiredItem": required_item} if required_item != "noitem" else {}),
            "titleLine": title_line,
            "displayText": display_text
        }

        interactions.append(interaction_obj)
        line_idx += 1  # Move past END marker

    return interactions

additional_interactions = [
  {
    "commandString": "TAKE SHARD",
    "requiredRoom": 71,
    "requiredItem": "shard",
    "itemKey": "shard",
    "titleLine": "You have taken 'The Shard of Eternal Light'."
  },
  {
    "commandString": "TAKE RELIC",
    "requiredRoom": 126,
    "requiredItem": "relic",
    "itemKey": "relic",
    "titleLine": "You have taken 'The Emberheart Relic'."
  },
  {
    "commandString": "TAKE CROWN",
    "requiredRoom": 186,
    "requiredItem": "crown",
    "itemKey": "crown",
    "titleLine": "You have taken 'The Veilbreaker Crown'."
  },
  {
    "commandString": "TAKE ORYN",
    "requiredRoom": 248,
    "requiredItem": "oryn",
    "itemKey": "oryn",
    "titleLine": "You have taken 'The Wyrmblade of Oryn'."
  },
  {
    "commandString": "TAKE TEAR",
    "requiredRoom": 298,
    "requiredItem": "tear",
    "itemKey": "tear",
    "titleLine": "You have taken 'The Ashen Tear'."
  },
  {
    "commandString": "TAKE HEART",
    "requiredRoom": 392,
    "requiredItem": "heart",
    "itemKey": "heart",
    "titleLine": "You have taken 'The Crystal Heart'."
  },
  {
    "commandString": "TAKE CHALICE",
    "requiredRoom": 468,
    "requiredItem": "chalice",
    "itemKey": "chalice",
    "titleLine": "You have taken 'The Ember Chalice'."
  },
  {
    "commandString": "TAKE MIRROR",
    "requiredRoom": 506,
    "requiredItem": "mirror",
    "itemKey": "mirror",
    "titleLine": "You have taken 'The Obsidian Mirror'."
  },
  {
    "commandString": "TAKE SHIELD",
    "requiredRoom": 642,
    "requiredItem": "shield",
    "itemKey": "shield",
    "titleLine": "You have taken 'The Shielf of Eternity'."
  },
  {
    "commandString": "TAKE GAUNTLET",
    "requiredRoom": 710,
    "requiredItem": "gauntlet",
    "itemKey": "gauntlet",
    "titleLine": "You have taken 'The Ashen Tear'."
  },
  {
    "commandString": "TAKE AMULET OF WHISPERS",
    "requiredRoom": 867,
    "requiredItem": "amuletofwhispers",
    "itemKey": "amuletofwhispers",
    "titleLine": "You have taken 'The Amulet of Whispers'."
  },
  {
    "commandString": "TAKE AMULET OF SHADOWS",
    "requiredRoom": 897,
    "requiredItem": "amuletofshadows",
    "itemKey": "amuletofshadows",
    "titleLine": "You have taken 'The Amulet of Shadow's.'"
  },
  {
    "commandString": "TAKE AMULET OF THE CELESTIAL KEY",
    "requiredRoom": 926,
    "requiredItem": "amuletofthecelestialkey",
    "itemKey": "amuletofthecelestialkey",
    "titleLine": "You have taken 'The Amulet of the Celestial Key.'"
  },
  {
    "commandString": "TAKE AMULET OF WILD SONG",
    "requiredRoom": 991,
    "requiredItem": "amuletofwildsong",
    "itemKey": "amuletofwildsong",
    "titleLine": "You have taken 'The Amulet of Wild Song.'"
  },
  {
    "commandString": "TAKE AMULET OF THE SHIFTING SANDS",
    "requiredRoom": 1119,
    "requiredItem": "amuletoftheshiftingsands",
    "itemKey": "amuletoftheshiftingsands",
    "titleLine": "You have taken 'The Amulet of the Shifting Sands.'"
  },
  {
    "commandString": "TAKE BOOK",
    "requiredRoom": 47,
    "requiredItem": "theechoesoflostages",
    "itemKey": "theechoesoflostages",
    "titleLine": "You have taken 'The Echoes Of Lost Ages, book.'"
  },
  {
    "commandString": "TAKE BOOK",
    "requiredRoom": 103,
    "requiredItem": "theserpentscanticle",
    "itemKey": "theserpentscanticle",
    "titleLine": "You have taken 'The Serpent's Canticle, book.'"
  },
  {
    "commandString": "TAKE BOOK",
    "requiredRoom": 294,
    "requiredItem": "thearchitectsoath",
    "itemKey": "thearchitectsoath",
    "titleLine": "You have taken 'The Serpent's Canticle, book.'"
  },
  {
    "commandString": "TAKE BOOK",
    "requiredRoom": 407,
    "requiredItem": "thefleshandshadow",
    "itemKey": "fleshandshadow",
    "titleLine": "You have taken 'Of Flesh And Shadow, book.'"
  },
  {
    "commandString": "TAKE BOOK",
    "requiredRoom": 669,
    "requiredItem": "thelabyrinthsbreath",
    "itemKey": "labyrinthsbreath",
    "titleLine": "You have taken 'The Labyrinth's Breath, book.'"
  },
  {
    "commandString": "TAKE BOOK",
    "requiredRoom": 755,
    "requiredItem": "themoonthatwatches",
    "itemKey": "themoonthatwatches",
    "titleLine": "You have taken 'The Moon That Watches, book.'"
  },
  {
    "commandString": "TAKE BOOK",
    "requiredRoom": 901,
    "requiredItem": "thegildedprison",
    "itemKey": "thegildedprison",
    "titleLine": "You have taken 'The Gilded Prison, book.'"
  },
  {
    "commandString": "TAKE BOOK",
    "requiredRoom": 1101,
    "requiredItem": "theunwrittentestament",
    "itemKey": "theunwrittentestament",
    "titleLine": "You have taken 'The Unwritten Testament, book.'"
  }
]


def main():
    rooms = parse_rooms('rooms.txt')
    interactions = parse_interactions('interactions.txt')
    interactions.extend(additional_interactions)

    # Write data.js
    with open('./js/data.js', 'w', encoding='utf-8') as f:
        f.write(f"export const rooms = {json.dumps(rooms, indent=2, ensure_ascii=False)};\n")
        f.write(f"export const interactions = {json.dumps(interactions, indent=2, ensure_ascii=False)};\n")

    print(f"Parsed {len(rooms)} rooms.")
    print(f"Parsed {len(interactions)} interactions.")

    # Print a report of all the first words of interaction command strings. Only unique first words so use a set.
    print("\nFirst words of interaction command strings:")
    first_words = set()
    for interaction in interactions:
        first_word = interaction['commandString'].split()[0].lower()
        first_words.add(first_word)
    for word in sorted(first_words):
        print(f"- {word}")

if __name__ == "__main__":
    main()

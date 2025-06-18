import { html, render, useState, useEffect, useMemo } from './preact.standalone.module.js';
import './tailwind.module.js';
import useCookie from './useCookie.js';
import { interactions, rooms, publicVerbs } from './data.js';

function getRoom(id) {
    if (id === null || id === undefined) {
        console.error(`Invalid room ID: ${id}`);
    }
    const room = rooms[id];
    if (!room) {
        console.error(`Room with id ${id} not found.`);
        return undefined;
    }
    return room;
}

function getFormattedTitle(title) {
    return `____${title}____`;
}

function getRoomDescription(id) {
    const room = getRoom(id);
    if (room) {
        const formattedTitle = getFormattedTitle(room.title);
        const wrappedDescription = room.description; // Optionally add wrapping logic here
        return [formattedTitle, wrappedDescription];
    }
    return ["You are in an unknown location."];
}

function Game() {

    const [gameState, setGameState] = useCookie('gameState', {
        lastText: getRoomDescription("1"),
        inventory: [],
        location: "1",
    });

    const room = getRoom(gameState.location);

    const availableInteractions = useMemo(() => {
        if (!room) return [];
        return interactions
            .filter(interaction => interaction.requiredRoom == gameState.location
                && interaction.requiredItem === undefined
                && (
                    publicVerbs.includes(interaction.commandString.split(' ')[0].toUpperCase())
                    // Or the phrase is found in the log case insensitive
                    || gameState.lastText.some(line =>
                        line.toLowerCase().includes(interaction.commandString.toLowerCase())
                    )
                ))
    })

    function move(roomId) {
        const newRoom = getRoom(roomId);
        if (!newRoom) {
            console.error(`Cannot move to invalid room ${roomId}`);
            return;
        }
        setGameState({
            ...gameState,
            location: roomId,
            lastText: getRoomDescription(roomId)
        });
    }

    return html`
        <div>
        
            <div id="controls" class="pb-10 grid grid-cols-3 gap-2">
                <button
                    class="col-start-1"
                    onclick=${() => console.log('Inventory button clicked')}
                >Inventory</button>

                <button
                    class="col-start-3"
                    onclick=${() => console.log('Help button clicked')}
                >Help</button>
            </div>

            <div id="controls" class="pb-10 grid grid-cols-3 gap-2">
                <button
                    class="col-start-2 ${!room?.northExit ? 'invisible pointer-events-none' : ''}"
                    onclick=${() => room?.northExit && move(room.northExit)}
                >North</button>

                <button
                    class="col-start-1 ${!room?.westExit ? 'invisible pointer-events-none' : ''}"
                    onclick=${() => room?.westExit && move(room.westExit)}
                >West</button>

                <button
                    class="col-start-3 ${!room?.eastExit ? 'invisible pointer-events-none' : ''}"
                    onclick=${() => room?.eastExit && move(room.eastExit)}
                >East</button>

                <button
                    class="col-start-2 ${!room?.southExit ? 'invisible pointer-events-none' : ''}"
                    onclick=${() => room?.southExit && move(room.southExit)}
                >South</button>
            </div>
            
            <div id="log">
                ${gameState.lastText.map((line, index) => html`<p key=${index}>${line}</p>`)}
            </div>

            <div id="interactions" class="grid grid-cols-3 gap-2">
                <button
                    class="col-span-1"
                    onclick=${() => {
                        setGameState({
                            ...gameState,
                            lastText: getRoomDescription(gameState.location)
                        });
                    }}
                >LOOK AROUND</button>

                ${availableInteractions.map(interaction => html`
                    <button
                        key=${interaction.id}
                        class="col-span-1"
                        onclick=${() => {
                            setGameState({
                                ...gameState,
                                lastText: [getFormattedTitle(interaction.titleLine), interaction.displayText]
                            });
                        }}
                    >
                        ${interaction.commandString}
                    </button>
                `)}
            </div>
        </div>
    `;
}

render(html`<${Game} />`, document.getElementById('app'));

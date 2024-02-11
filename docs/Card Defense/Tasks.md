
## Using cards

- [x] Card template
- [x] Test card
- [x] Card hand
- [x] Using card shortcuts plays it and discards it

## Placing buildings

- [x] Await functionality when playing card
- [x] Can prompt player controller for position
- [x] Cards can place buildings that snap to the grid

## Spawning enemies

- [x] Enemy path drawn with lines and easily configurable
- [x] When space is pressed, spawns an enemy
- [x] Enemy travels from beginning to end of the path

## Rounds

- [x] Draws 5 cards at the beginning of the round
- [x] Spawns 10 enemies
- [x] Waits for enemies to get to the end of the path
- [x] If A is pressed, an enemy dies
- [x] If all enemies die, round ends

## Building

- [x] Preview of building when placing
- [x] Buildings positions are saved in the grid
- [x] Cannot build on other buildings
- [x] Building terrain info
- [x] Cannot build on the enemy path

## Gun turret

- [x] Enemies have health
- [x] When enemy health drops to zero, they die
- [x] Gun turret building with set range, damage and attack speed
- [x] Gun turret selects the first enemy in range and looks at it
- [x] Gun turret deals damage to the targeted enemies
- [x] Damage feedback

## Win and lose

- [x] Player wins after 5 rounds
- [x] If enemy reaches the end, it damages the player
- [x] When player health reaches zero, they lose
- [x] Win and lose screen with restart

## Card fixes

- [x] Cards are pulled up if hovered
- [x] If player has more than 6 cards, the rightmost card is discarded
- [x] If player has no more cards in draw pile when drawing, shuffle discard pile into the draw pile
- [x] Cards consume energy when played
- [x] Cards can be played by clicking on them

## Building UI

- [ ] Clicking on building opens its UI
- [ ] UI contains description of building
- [ ] Buildings can have targeting options
- [ ] Button to switch targeting in UI
- [ ] First or strong targeting option on gun turret

## Building upgrade

- [ ] Buildings can be upgraded via cards
- [ ] Each building has its own upgrade function
- [ ] Upgrade card
- [ ] Buildings have upgrade descriptions on their UI
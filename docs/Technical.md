Describes complex systems and how they are implemented.

## Random wave generation

Hand crafted waves would assure quality in some aspects but may not always fit the situation and could quickly become repetitive for the player. Designing waves for multiple different situations would not scale well at all. Therefore, an algorithm to generate random seems like the best compromise: lower quality waves but high variety and can be made context sensitive without necessarily too much added complexity.

### Requirements

The algorithm must meet the following requirements:

- Allow for a specific enemy pool when generating, meaning it cannot depend on all enemies being on option.
- Should be configurable with a difficulty setting, easier waves in the beginning, harder waves near the end for example.
- Must take into account enemy interaction to some degree, healers on their own are very weak, but with the right enemies it can be very strong too.

### Wave patterns

Hand made patterns that can be mixed and matched by the algorithm depending on the needs. Patterns can be generic, meaning it allows for some enemy types rather than specific enemy (fast enemy and normal enemy both meet the condition of being weak for example)

This can use specific pools and even reuse patterns with different pools. Pattern difficulty can be hardcoded and also allow for difficulty multipliers with different enemies.
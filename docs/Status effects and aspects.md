This describes status effects and aspects in detail.

## Aspects

Aspects give special properties to the projectiles of the sentry it is applied on. There can only be one aspect at a time on a sentry (unless maybe an expertise could allow for two or all of them)

Each sentry has its own aspect intensity, which dictates how effective aspects are with it. In general, slower high damage towers like snipers use their aspect less often so they should have a higher aspect intensity, while AOE and fast firing sentries should have lower ones to compensate. Some sentries could be specialized in aspects by having very low DPS but much higher intensity to compensate.

### Status aspects

Some aspects simply apply a status effect equal to their aspect intensity. Those aspects are:

- Fire aspect, which applies burn
- Ice aspect, which applies freeze

The remaining aspects are described below
### Lightning

Lightning chains damage to nearby enemies, halving its damage every time it chains. This means towers that have high single target damage but are bad against multiple targets can now deal with grouped enemies very efficiently.

If the lightning effect ends up being too strong, it the damage decrease can be changed from -50% to -80% for example, making it still good for its purpose but prevent high damage towers from destroying groups entirely. Additionally, an expertise can bring that number back to 50% or another fraction.

### Wind

Wind aspects knocks enemies back, unlike slow which just makes them take longer to travel, this can make enemies go backwards with enough intensity.

On a tower that has high aspect intensity. Since this is a flat distance instead of a multiplicative speed reduction, this can allow for a more sustained clumping.

One way to implement it would be to have a hidden knockback status that gets added and disappears after a fixed time while knocking back its target the whole way through. Unlike other statuses, this one is non exclusive meaning it can be applied many times instead of just having the single status value 

### Darkness/curse?

While I'm not sure about the name, the principle would be a hard to obtain (expensive cards/multi step cards/cards with downsides), but allows the sentry to deal very high amounts of damage.

It could take the form of a status effect that deals damage every time it gets hit. 

## Enemy status effects

For the sake of simplicity, status effects used by aspects should be balanced for the same values. In other words, 50 burn should be around the same usefulness as 50 freeze when taking buffs and synergies into account (50 burn is more powerful on its own, but 50 freeze scales in power with things that take advantage of the slow)

### Burn

Each second, the enemy with burn takes damage equal to its burn value and that value is halved. This ensures that more burn deals damage faster, but deals less damage in the long run.

An alternative would be losing 10 burn every second, which makes stronger burn values much more powerful. Any of these two can be chosen depending on balance.

### Freeze

Each second, the enemy loses 10 freeze. While freeze is active, the speed of the enemy is multiplied by 99% to the power of the freeze value, meaning diminishing returns on freeze and prevents the enemy to completely stop. High freeze values are still very good because of the fact that it will regain less speed over time.

Much like burn, the enemy could loose half of its freeze at a time if high freeze values end up being too strong.

### Building status effects


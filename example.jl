abstract type Weapon end

abstract type Magic end

abstract type Status end

mutable struct Healthy <: Status

end
mutable struct Dead <: Status

end

mutable struct Burn <: Status
    damage::Float64
end

mutable struct Healing <: Status
    health::Float64
end

mutable struct Player
    weapon::Weapon
    health::Float64
    status::Status

    function Player(weapon::Weapon, health::Float64)
        new(weapon, health, Healthy())  
    end
end

mutable struct Fire <: Magic
    element::String
    DOT::Bool
    damage::Float64
end

mutable struct Water <: Magic
    element::String
    DOT::Bool
end

mutable struct Earth <: Magic
    element::String
    DOT::Bool
end

#theres a built in fucntion or thing for air?
# mutable struct Air <: Magic
#     element::String
#     DOT::Bool
# end

mutable struct Sword <: Weapon
    damage::Float64
    range::Float64
end

mutable struct Whip <: Weapon
    damage::Float64
    range::Float64
end

mutable struct Wand
    damage::Float64
    range::Float64
    magic::Magic
end 

function element(thing::Magic) thing.element end
function cast(thing::Magic) Health() end
function cast(thing::Fire) Burn(thing.damage) end


function status(st::Status) 0 end
function status(st::Burn) -1 * st.damage end
function status(st::Healing) st.health end

function attack(stick::Weapon)
    (stick.damage, Healthy()) 
end
function attack(stick::Wand)
    (stick.damage, cast(stick.magic))
end

function damage!(player::Player, status::Status, dmg::Float64) player.health -= dmg end
function damage!(player::Player, status::Burn, dmg::Float64) player.health -= (dmg + status.damge) end

function doattack(player::Player) attack(player.weapon) end

function checkalive!(player::Player) 
    if player.health <= 0.0
        player.status = Dead()
    end
end


function combat!(player1, player2)
    (dmg, stat) = doattack(player1)
    damage!(player2, stat, dmg)
    checkalive!(player2)
    player2
end


function war!(player1, player2)
    while typeof(player1.status) != Dead && typeof(player2.status) != Dead 
        combat!(player1, player2)
        combat!(player2,player1)
    end
    if typeof(player1.status) != Dead
        player1
    elseif typeof(player2.status) != Dead
        player2
    else
        "Mutual defeat"
    end
end

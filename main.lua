require 'shooter'
local moonshine = require 'moonshine'
local effect

function love.load()
  ambienceSound = love.audio.newSource('assets/And-the-Machines-Came-at-Midnight.mp3', 'static')
  ambienceSound:setLooping(true)
  -- ambienceSound:play()
  effect = moonshine(moonshine.effects.vignette)
end

function love.update(dt)
  shooter:update(dt)
  
end

function love.draw()
  shooter:draw()
end
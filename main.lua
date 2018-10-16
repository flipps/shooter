require 'shooter'

function love.load()
  ambienceSound = love.audio.newSource('assets/And-the-Machines-Came-at-Midnight.mp3', 'static')
  ambienceSound:setLooping(true)
  ambienceSound:play()
end

function love.update(dt)
  shooter.update()
end

function love.draw()
  shooter.draw()
end
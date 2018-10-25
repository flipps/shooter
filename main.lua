require 'shooter'
require 'enemy'

function love.load()
  ambienceSound = love.audio.newSource('assets/And-the-Machines-Came-at-Midnight.mp3', 'static')
  ambienceSound:setLooping(true)
  ambienceSound:play()

  for i = 1, 3 do
    enemy_controller:create(math.random(0, 700), math.random(0, 500), 20, 20)
  end
end

function love.update(dt)
  shooter:update(dt)
end

function love.draw()
  shooter:draw()
  enemy_controller:draw()
end
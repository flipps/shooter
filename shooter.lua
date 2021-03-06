require 'bullets'
require 'utils'
require 'enemy'
local moonshine = require 'moonshine'

local fps = 24
local sqrt = math.sqrt
local insert = table.insert
local remove = table.remove
local fx

shooter = {
  x = love.graphics.getWidth() / 2,
  y = love.graphics.getHeight() / 2,
  image = love.graphics.newImage('assets/shooter.png'),
  xVelocity = 0,
  yVelocity = 0,
  radius = 30,
  angle = 0,
  friction = 0.8,
  speed = 30,
  animationTimer = 1 / fps,
  totalFrames = 4,
  xOffset = 0,
  currentFrame = 1,
  fire = false,
  widthHalf = 0,
  heightHalf = 0,
  health = 150,
}

shooter.frames = {}

shooter.atlas = love.graphics.newImage('assets/shooter_atlas.png')
shooter.sprite = love.graphics.newQuad(0, 0, 60, 60, shooter.atlas:getDimensions())
shooter.width = shooter.image:getWidth()
shooter.height = shooter.image:getHeight()
shooter.widthHalf = shooter.width / 2
shooter.heightHalf = shooter.height / 2

referenceEnemyAngle = 0
health = 100

function shooter:init()
  fx = moonshine(moonshine.effects.godsray)
  fx.disable('godsray')

  for frame = 1, shooter.totalFrames do
    shooter.frames[frame] = love.graphics.newQuad((frame - 1) * 60, 0, 60, 60, shooter.atlas:getDimensions())
  end

  enemy_controller:create(math.random(0, 700), math.random(0, 500), 100, 100)
end

function resetGame()
  for i,enemy in ipairs(enemy_controller.enemies, enemy) do
    remove(enemy_controller.enemies, i)
    enemy_controller:create(math.random(0, 700), math.random(0, 500), 100, 100)
    shooter.health = 150
    health = 100
  end
end

shooter.init()

function shooter:draw()
  love.graphics.setColor(1, 1, 0)

  fx(
    function()
      if shooter.fire == true then
        love.graphics.draw(shooter.atlas, shooter.frames[shooter.currentFrame], shooter.x, shooter.y, shooter.angle - math.rad(-90), 1, 1, shooter.widthHalf, shooter.heightHalf)
      else
        love.graphics.draw(shooter.atlas, shooter.sprite, shooter.x, shooter.y, shooter.angle - math.rad(-90), 1, 1, shooter.widthHalf, shooter.heightHalf)
      end
    end
  )

  -- bullets creation
  for y = -1, 1 do
    for x = -1, 1 do
      for i,b in ipairs(bullets) do
        love.graphics.draw(bullets.image, b.x, b.y, shooter.angle - math.rad(90), 1, 1, bullets.widthHalf, bullets.heightHalf)
      end
    end
  end

  -- enemies
  enemy_controller:draw(referenceEnemyAngle + math.rad(90), health)

  -- shooter health bar
  if shooter.health >= shooter.health then
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle('fill', 20, 20, shooter.health, 10)
  end

  if shooter.health < 75 then
    print(shooter.health)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', 20, 20, shooter.health, 10)
  end

  -- Debbug
  -- love.graphics.setColor(1, 1, 1)
  -- love.graphics.print('Enemy angle: '.. enemy.angle)
  -- love.graphics.origin()
  -- love.graphics.setColor(1, 0, 0)
  -- love.graphics.print(table.concat({
  --   'Shooter Angle: '..shooter.angle,
  --   'Shooter x: '..shooter.x,
  --   'Shooter y: '..shooter.y,
  --   'Shooter x speed: '..shooter.xVelocity,
  --   'Shooter y speed: '..shooter.yVelocity,
  -- },'\n'), 10, 10)
end

function shooter:update(dt)
  bullets.timer = bullets.timer - 1
  shooter.animationTimer = shooter.animationTimer - dt

  if shooter.animationTimer < 0 then
    shooter.animationTimer = 1 / fps
    shooter.currentFrame = shooter.currentFrame % shooter.totalFrames + 1
  end

  --keyboard interaction
  if love.keyboard.isDown('d') then
    shooter.xVelocity = shooter.xVelocity + shooter.speed
  end

  if love.keyboard.isDown('a') then
    shooter.xVelocity = shooter.xVelocity - shooter.speed
  end

  if love.keyboard.isDown('w') then
    shooter.yVelocity = shooter.yVelocity - shooter.speed
  end

  if love.keyboard.isDown('s') then
    shooter.yVelocity= shooter.yVelocity + shooter.speed
  end

  --mouse interaction
  local dx = love.mouse.getX() - shooter.x
  local dy = love.mouse.getY() - shooter.y
  shooter.angle = math.atan2(dy, dx)

  shooter.xVelocity = shooter.xVelocity * shooter.friction
  shooter.yVelocity = shooter.yVelocity * shooter.friction

  shooter.x = (shooter.x + shooter.xVelocity * dt) % love.graphics.getWidth()
  shooter.y = (shooter.y + shooter.yVelocity * dt) % love.graphics.getHeight()

  -- bullets
  for i,b in ipairs(bullets) do
    local speed = 1000
    
    -- removed bullets that are out of screen boundries
    if b.x > love.graphics.getWidth() or b.x < 0 then
      remove(bullets, i)
    elseif b.y > love.graphics.getHeight() or b.y < 0 then
      remove(bullets, i)
    end

    b.x = b.x + (math.cos(b.angle) * speed * dt)
    b.y = b.y + (math.sin(b.angle) * speed * dt)
  end
  
  -- Enemies pos
  for i,enemy in ipairs(enemy_controller.enemies) do
    enemy.angle = math.atan2((enemy.y - shooter.y), (enemy.x - shooter.x))
    referenceEnemyAngle = enemy.angle
    enemy.x = enemy.x - (math.cos(enemy.angle) * enemy.speed * dt)
    enemy.y = enemy.y - (math.sin(enemy.angle) * enemy.speed * dt)
  end

  -- Mouse controls
  if love.mouse.isDown(1) then
    shooter.fire = true
    fx.enable('godsray')

    if bullets.timer <= 0 then
      bullets.timer = 10
      -- playSound(bullets.sound)
      insert(bullets, {
        x = shooter.x + math.cos(shooter.angle) * shooter.radius,
        y = shooter.y + math.sin(shooter.angle) * shooter.radius,
        radius = 5,
        width = 5,
        height = 5,
        angle = shooter.angle
      })
    end
  else
    shooter.fire = false
    fx.disable('godsray')
  end

  -- Bullets / enemy collision
  for i,bullet in ipairs(bullets) do
    for j,enemy in ipairs(enemy_controller.enemies) do
      -- ax, ay, bx, by, ar, br
      if checkBulletEnemyCollision(bullet.x, bullet.y, enemy.x, enemy.y, bullet.radius, enemy.radius) then
        remove(bullets, i)
        health = health - 1
        if health <= 0 then
          health = 0
          remove(enemy_controller.enemies, i)
          -- add particles
        end
      end
    end
  end

  -- Hero / Enemy collision
  for k,enemy in ipairs(enemy_controller.enemies) do
    if checkBulletEnemyCollision(shooter.x, shooter.y, enemy.x, enemy.y, shooter.radius, enemy.radius) then
      shooter.health = shooter.health - 1
      if shooter.health <= 0 then
        shooter.health = 0
        resetGame()
      end
    end
  end

end
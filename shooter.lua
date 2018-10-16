require 'bullets'
require 'utils'

local fps = 24

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
}
shooter.frames = {}
shooter.atlas = love.graphics.newImage('assets/shooter_atlas.png')
shooter.sprite = love.graphics.newQuad(0, 0, 60, 60, shooter.atlas:getDimensions())

function shooter:init()
  for frame = 1, shooter.totalFrames do
    shooter.frames[frame] = love.graphics.newQuad((frame - 1) * 60, 0, 60, 60, shooter.atlas:getDimensions())
  end
end

shooter.init()

function shooter:draw()
  love.graphics.setColor(1, 1, 0)

  if shooter.fire == true then
    love.graphics.draw(shooter.atlas, shooter.frames[shooter.currentFrame], shooter.x - shooter.image:getWidth() / 2, shooter.y - shooter.image:getHeight() / 2, shooter.angle - math.rad(-90), 1, 1, shooter.image:getWidth() / 2, shooter.image:getHeight() / 2)
  else
    love.graphics.draw(shooter.atlas, shooter.sprite, shooter.x - shooter.image:getWidth() / 2, shooter.y - shooter.image:getHeight() / 2, shooter.angle - math.rad(-90), 1, 1, shooter.image:getWidth() / 2, shooter.image:getHeight() / 2)
  end

  -- bullets creation
  for y = -1, 1 do
    for x = -1, 1 do
      for i,b in ipairs(bullets) do
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle('fill', b.x, b.y, b.radius)
      end
    end
  end

  -- Debbug
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

function shooter:update()
  local dt = love.timer.getDelta()
  local shooterSpeed = 100

  bullets.timer = bullets.timer - 1
  shooter.animationTimer = shooter.animationTimer - dt

  if shooter.animationTimer < 0 then
    shooter.animationTimer = 1 / fps
    shooter.currentFrame = shooter.currentFrame % shooter.totalFrames + 1
  end

  --keyboard interaction
  if love.keyboard.isDown('d') then
    shooter.xVelocity = shooter.xVelocity + shooter.speed
  elseif love.keyboard.isDown('a') then
    shooter.xVelocity = shooter.xVelocity - shooter.speed
  elseif love.keyboard.isDown('w') then
    shooter.yVelocity = shooter.yVelocity - shooter.speed
  elseif love.keyboard.isDown('s') then
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
      table.remove(bullets, i)
    elseif b.y > love.graphics.getHeight() or b.y < 0 then
      table.remove(bullets, i)
    end

    b.x = (b.x + math.cos(b.angle) * speed * dt)
    b.y = (b.y + math.sin(b.angle) * speed * dt)
  end
  
  if love.mouse.isDown(1) then
    shooter.fire = true
    if bullets.timer <= 0 then
      bullets.timer = 10
      -- playSound(bullets.sound)
      table.insert(bullets, {
        x = (shooter.x - shooter.image:getWidth() / 2) + math.cos(shooter.angle) * shooter.radius,
        y = (shooter.y - shooter.image:getHeight() / 2) + math.sin(shooter.angle) * shooter.radius,
        radius = 5,
        angle = shooter.angle
      })
    end
  else
    shooter.fire = false
  end
end
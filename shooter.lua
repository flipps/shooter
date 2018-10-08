require 'bullets'
require 'utils'

shooter = {
  x = love.graphics.getWidth() / 2,
  y = love.graphics.getHeight() / 2,
  xVelocity = 0,
  yVelocity = 0,
  radius = 30,
  angle = 0,
  friction = 0.9,
  speed = 30
}

function shooter:draw()
  love.graphics.setColor(1, 1, 0)
  love.graphics.circle('fill', shooter.x, shooter.y, shooter.radius)

  -- shooter angle indicator
  local shooterCircleDistance = 20
  local shooterCircleradius = 5

  love.graphics.setColor(0, 0, 1)
  love.graphics.circle(
    'fill',
    shooter.x + math.cos(shooter.angle) * shooterCircleDistance,
    shooter.y + math.sin(shooter.angle) * shooterCircleDistance,
    shooterCircleradius
  )

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
  love.graphics.origin()
  love.graphics.setColor(1, 0, 0)
  love.graphics.print(table.concat({
    'Shooter Angle: '..shooter.angle,
    'Shooter x: '..shooter.x,
    'Shooter y: '..shooter.y,
    'Shooter x speed: '..shooter.xVelocity,
    'Shooter y speed: '..shooter.yVelocity,
  },'\n'), 10, 10)
end

function shooter:update()
  local dt = love.timer.getDelta()
  local angleIndicatorSpeed = 10
  local shooterSpeed = 100

  bullets.timer = bullets.timer - 1

  --keyboard interaction
  if love.keyboard.isDown('d') then
    shooter.xVelocity = shooter.xVelocity + shooter.speed
    -- shooter.angle = (shooter.angle + angleIndicatorSpeed * dt) % (2 * math.pi) -- keeps angles positive.
  elseif love.keyboard.isDown('a') then
    shooter.xVelocity = shooter.xVelocity - shooter.speed
    -- shooter.angle = (shooter.angle - angleIndicatorSpeed * dt) % (2 * math.pi)
  elseif love.keyboard.isDown('w') then
    shooter.yVelocity = shooter.yVelocity - shooter.speed
    -- shooter.xVelocity = shooter.xVelocity + math.cos(shooter.angle) * shooterSpeed * dt
    -- shooter.yVelocity = shooter.yVelocity + math.sin(shooter.angle) * shooterSpeed * dt
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
    local speed = 800
    
    -- removed bullets that are out of screen boundries
    if b.x > love.graphics.getWidth() or b.x < 0 then
      table.remove(bullets, i)
    elseif b.y > love.graphics.getHeight() or b.y < 0 then
      table.remove(bullets, i)
    end

    b.x = (b.x + math.cos(b.angle) * speed * dt)
    b.y = (b.y + math.sin(b.angle) * speed * dt)
  end

  -- if love.keyboard.isDown('space') then
  if love.mouse.isDown(1) then
    if bullets.timer <= 0 then
      bullets.timer = 10
      playSound(bullets.sound)
      table.insert(bullets, {
        x = shooter.x + math.cos(shooter.angle) * shooter.radius,
        y = shooter.y + math.sin(shooter.angle) * shooter.radius,
        radius = 5,
        angle = shooter.angle
      })
    end
  end
end
enemy = {}

function enemy:createsEnemy(_x, _y, _w, _h, _r, _s)
  enemy.x = _x
  enemy.y = _y
  enemy.width = _w
  enemy.height = _h
  enemy.radius = _r
  enemy.segments = _s

  love.graphics.circle('fill', enemy.x, enemy.y, enemy.radius, enemy.segments)
end

function enemy:draw()
  love.graphics.setColor(1, 0, 0, 1)
  enemy:createsEnemy(love.math.random(30, love.graphics.getWidth() - 30), love.math.random(30, love.graphics.getHeight() - 30), 50, 50, 30, 100)
end
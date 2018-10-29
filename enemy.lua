enemy_controller = {}
enemy_controller.enemies = {}

local insert = table.insert

function enemy_controller:create(_x, _y, _w, _h)
  enemy = {}
  enemy.x = _x
  enemy.y = _y
  enemy.width = _w
  enemy.height = _h
  enemy.radius = 50
  enemy.segments = 20
  enemy.health = 100
  enemy.speed = 100
  enemy.image = love.graphics.newImage('assets/boss.png')
  enemy.angle = 0
  enemy.halfWidth = enemy.image:getWidth() / 2
  enemy.halfHeight = enemy.image:getHeight() / 2

  insert(enemy_controller.enemies, enemy)
end

function enemy_controller:draw(angle)
  for i,enemy in ipairs(enemy_controller.enemies) do
    enemy.angle = angle

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(enemy.image, enemy.x, enemy.y, enemy.angle, 1, 1, enemy.halfWidth, enemy.halfHeight)
  end
end
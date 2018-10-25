enemy_controller = {}
enemy_controller.enemies = {}

local insert = table.insert

function enemy_controller:create(_x, _y, _w, _h)
  enemy = {}
  enemy.x = _x
  enemy.y = _y
  enemy.width = _w
  enemy.height = _h
  enemy.radius = 10
  enemy.segments = 20

  insert(enemy_controller.enemies, enemy)
end

function enemy_controller:draw()
  for i,enemy in ipairs(enemy_controller.enemies) do
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle('line', enemy.x, enemy.y, enemy.width, enemy.height, enemy.radius, enemy.segments)
  end
end
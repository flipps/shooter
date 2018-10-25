bullets = {
  timer = 10,
  sound = love.audio.newSource('assets/laser_shot.wav', 'static'),
  image = love.graphics.newImage('assets/bullet.png'),
  width = 5,
  heigth = 5,
}

bullets.widthHalf = bullets.width / 2
bullets.heightHalf = bullets.width / 2
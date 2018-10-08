function playSound(sound)
  if sound:isPlaying() then 
    sound:stop()
    sound:play()
  else
    sound:play()
  end
end
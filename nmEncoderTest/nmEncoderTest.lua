-- nmEncoderTest
-- 1.0 @NightMachines
-- based on a script posted on
-- the llllllll.co forum
--
-- Test your Encoders and try
-- out Sensitivity & Acceleration.


local util = require "util"

screen_dirty = true

mySens = 1
myAccel = true
lastDelta = 0
shiftBtn = false

function init()

  counter = {}
  for e = 1,3 do
    counter[e] = 0
  end
  clock.run(screen_redraw_clock)
  redraw()
end

function key(n,z)
  
  if n==1 then
    if z==1 then
      shiftBtn = true
    else
      shiftBtn = false
    end
  end
  
  
  if shiftBtn == false then
    if n==2 and z==1 then
      mySens = util.clamp(mySens-1,1,16)
      status()
    elseif n==3 and z==1 then
      mySens = util.clamp(mySens+1,1,16)
      status()
    end
    
  else
    if n==2 and z==1 then
      myAccel = false
      status()
    elseif n==3 and z==1 then
      myAccel = true
      status()
    end
  end
  screen_dirty = true
end

function status()
  norns.enc.sens(0,mySens)
  norns.enc.accel(0,myAccel)
end


function enc(e,d)
	lastDelta = d
  counter[e] = util.clamp(counter[e] + d,0,100)
  screen_dirty = true
end

function redraw()
  screen:clear()
  screen.level(15)  
  for i = 1,3 do
    screen.move(120, 15 + (10*i))
    screen.text_right("e"..i..": "..counter[i])
  end
  screen.move(0,25)
  screen.text("Sensitivity: "..mySens)
  screen.move(0,35)
  screen.text("Acceleration: "..tostring(myAccel))
  screen.move(0,45)
  screen.text("Last Delta: "..lastDelta)
  screen.move(85,5)
  screen.text("HOLD")
  if shiftBtn == true then
    screen.move(0,60)
    screen.text("off")
    screen.move(27,60)
    screen.text("on")
  else
    screen.move(0,60)
    screen.text("-")
    screen.move(30,60)
    screen.text("+")
  end
  screen:update()
end

function screen_redraw_clock()
  while true do
    if screen_dirty then
      redraw()
      screen_dirty = false
    end
    clock.sleep(1/30)
  end
end
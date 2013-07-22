------------------------------------------
-- Here is were the magic starts!
-- Bruno Barbosa Pinheiro, Fan Studios 2013
-- Pine Library Tests
------------------------------------------

-- using the Pine Library
require 'pinelibrary.lib'
-- some app configurations
display.setStatusBar(display.HiddenStatusBar)




-- testing the loop controller and the easing functions
local smile = display.newImage('images/smile.png')
smile.x, smile.y = display.contentWidth/2, smile.height/2 + 10

local destination = display.contentHeight - (smile.height/2 + 10)

local transitionParams = {
	target = smile,
	time = 5000,
	y = destination,
	transition = PL.easing.outBounce,
	loops = PL.loop.Infinity,
	loopType = PL.loop.PingPong,
	onStart = function() print('starting the transition') end,
	onComplete = function() print('completing the transition') end
}

local loopController = PL.loop:createController(transitionParams)
loopController:start()





-- testing the math:clamp function
print()
print('testing the math:clamp function')
print('[1,10], Value: 7  => ' .. PL.math:clamp(7,1,10))
print('[1,10], Value: 20 => ' .. PL.math:clamp(20,1,10))
print('[1,10], Value: -2 => ' .. PL.math:clamp(-2,1,10))
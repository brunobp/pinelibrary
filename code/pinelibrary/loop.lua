-- a little help with transitions loop
-- Bruno Barbosa Pinheiro 2013, Pine Brothers
-- Pine library

PL.loop = {}
PL.loop.PingPong = 'PingPong'
PL.loop.Straight = 'Straight'
PL.loop.Infinity = 0



-- base controller
local function createBaseController(parameters,initials)
	local controller = {}
	controller.loopCount = -1
	controller.transition = nil
	controller.parameters = parameters
	controller.go = function() end
	
	function controller:initialize()
		for key,value in pairs(initials) do self.parameters.target[key] = value end
		self.parameters.looponStart()
		self.loopCount = -1
	end
	
	function controller:start()
		self:initialize()
		self.go()
	end
	
	function controller:stop()
		self.parameters.looponComplete()
		self:cancel()
	end
	
	function controller:cancel()
		if self.transition then
			transition.cancel(self.transition)
		end
	end
	
	function controller:shouldStop()
		return self.parameters.loops > 0 and self.parameters.loops <= self.loopCount
	end
	
	function controller:countLoop()
		self.loopCount = self.loopCount + 1
	end
		
	return controller
end


-- ping pong controller
local function newPingPongController(parameters,initials,finals)
	local controller = createBaseController(parameters,initials)
	
	local comeBack = function()
		for key,value in pairs(initials) do controller.parameters[key] = value end
		controller.parameters.onComplete = controller.go
		controller.transition = transition.to(controller.parameters.target,controller.parameters)
	end
	
	controller.go = function()
		controller:countLoop()
		if not controller:shouldStop() then
			for key,value in pairs(finals) do controller.parameters[key] = value end
			controller.parameters.onComplete = comeBack
			controller.transition = transition.to(controller.parameters.target,controller.parameters)
		else
			controller:stop()
		end
	end
	
	return controller
end


-- straight controller
local function newStraightController(parameters,initials,finals)
	local controller = createBaseController(parameters,initials)
	
	controller.go = function()
		print("hey")
		controller:countLoop()
		if not controller:shouldStop() then
			for key,value in pairs(initials) do controller.parameters.target[key] = value end
			for key,value in pairs(finals) do controller.parameters[key] = value end
			controller.parameters.onComplete = controller.go
			controller.transition = transition.to(controller.parameters.target,controller.parameters)
		else
			controller:stop()
		end
	end
	
	return controller
end



local function generateControllerArrays(arguments,initialState)
	local initials, finals, parameters = {}, {}, {}
	
	if not arguments.target then print('Warning: you must define the transition\'s target!')
	else parameters.target = arguments.target end
	parameters.onComplete = function() end
	parameters.onStart = function() end
	if initialState then initials = initialState end
	
	for key,value in pairs(arguments) do
		if  key == 'target'		or
			key == 'time' 		or
			key == 'delay' 		or
			key == 'transition'	or
			key == 'delta'		or
			key == 'loopType'	or
			key == 'loops'
		then parameters[key] = value
		elseif 	key == 'onComplete' or
				key == 'onStart'
		then parameters['loop' .. key] = value -- avoid conflicts with the arguments of the corona transitions
		else
			if not initialState then initials[key] = parameters.target[key] end
			finals[key] = value
		end
	end
	
	if not parameters.loopType then parameters.loopType = PL.transition.loop.Straight end
	if not parameters.loops then parameters.loops = 1 end
	if not parameters.time then parameters.time = 100 end

	return parameters,initials,finals
end


-- creating the the loop controller
function PL.loop:createController(arguments,initialState)
	local parameters, initials, finals = generateControllerArrays(arguments,initialState)
	
	if parameters.loopType == PL.loop.PingPong then
		return newPingPongController(parameters,initials,finals)
	end
	return newStraightController(parameters,initials,finals)
end


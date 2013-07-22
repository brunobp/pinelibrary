-- Creating my own ease functions o/
-- Based on Robert Penner's easing functions
-- http://www.robertpenner.com
-- Bruno Barbosa Pinheiro 2012, Pine Brothers
-- Pine library

PL.easing = {}

-- Back
PL.easing.backOvershoot = 1.70158

PL.easing.inBack = function(time,duration,initial,delta)
	local s = PL.easing.backOvershoot
	local elapsed = time/duration
	return delta * (elapsed^2) * ((s+1) * elapsed - s) + initial
end

PL.easing.outBack = function(time, duration, initial, delta)
	local s = PL.easing.backOvershoot
	local elapsed = time/duration - 1
	return delta * ((elapsed^2) * ((s + 1) * elapsed + s) + 1) + initial
end

PL.easing.inOutBack = function(time,duration,initial,delta)
	local s = PL.easing.backOvershoot * 1.525
	local elapsed = time/(duration/2)
	if elapsed < 1 then
		return delta/2 * ((elapsed^2) * ((s+1) * elapsed - s)) + initial
	else
		elapsed = elapsed - 2
		return delta/2 * ((elapsed^2) * ((s+1) * elapsed + s) + 2) + initial
	end
end




-- Bounce
PL.easing.outBounce = function(time,duration,initial,delta)
	local elapsed = time/duration
	local modifier = 0
	if elapsed < 1/2.75 then
		elapsed = elapsed
		modifier = 0
	elseif elapsed < 2/2.75 then
		elapsed = elapsed - 1.5/2.75
		modifier = 0.75
	elseif elapsed < 2.5/2.75 then
		elapsed = elapsed - 2.25/2.75
		modifier = 0.9375
	else
		elapsed = elapsed - 2.625/2.75
		modifier = 0.984375
	end
	return delta * (7.5625 * (elapsed^2) + modifier) + initial
end

PL.easing.inBounce = function(time,duration,initial,delta)
	local outBounce = PL.easing.outBounce(duration - time,duration,0,delta)
	return delta - outBounce + initial	
end

PL.easing.inOutBounce = function(time,duration,initial,delta)
	if time < duration/2 then 
		return PL.easing.inBounce(2 * time,duration,0,delta) * 0.5 + initial
	else 
		return PL.easing.outBounce(time * 2 - duration,duration,0,delta) * 0.5 + delta * 0.5 + initial
	end
end




-- Circ
PL.easing.inCirc = function(time,duration,initial,delta)
	local elapsed = time/duration
	return -delta * (math.sqrt(1 - (elapsed^2)) - 1) + initial
end

PL.easing.outCirc = function(time,duration,initial,delta)
	local elapsed = time/duration - 1
	return delta * math.sqrt(1 - (elapsed^2)) + initial
end

PL.easing.inOutCirc = function(time,duration,initial,delta)
	local elapsed = time/(duration/2)
	if elapsed < 1 then
		return -delta/2 * (math.sqrt(1 - (elapsed^2)) - 1) + initial
	else
		elapsed = elapsed - 2
		return delta/2 * (math.sqrt(1 - (elapsed^2)) + 1) + initial
	end
end




-- Cubic
PL.easing.inCubic = function(time,duration,initial,delta)
	local elapsed = time/duration
	return delta * (elapsed^3) + initial
end

PL.easing.outCubic = function(time,duration,initial,delta)
	local elapsed = time/duration - 1
	return delta * ((elapsed^3) + 1) + initial
end

PL.easing.inOutCubic = function(time,duration,initial,delta)
	local elapsed = time/(duration/2)
	if elapsed < 1 then
		return delta/2 * (elapsed^3) + initial
	else
		elapsed = elapsed - 2
		return delta/2 * ((elapsed^3) + 2) + initial
	end
end




-- Elastic
PL.easing.elasticAmplitude = 0
PL.easing.elasticPeriod = 0

PL.easing.inElastic = function(time,duration,initial,delta)
	local elapsed = time/duration
	if elapsed == 0 then return initial end
	if elapsed == 1 then return initial + delta end
	
	local p = PL.easing.elasticPeriod
	if p == 0 then p = duration * 0.3 end
	
	local s = 0
	local a = PL.easing.elasticAmplitude
	if a == 0 or a < math.abs(delta) then
		a = delta
		s = p/4	
	else
		s = p/(2 * math.pi) * math.asin(delta/a)
	end
	
	elapsed = elapsed - 1
	return -(a * (2^(10*elapsed)) * math.sin((elapsed * duration - s) * (2 * math.pi)/p )) + initial
end

PL.easing.outElastic = function(time,duration,initial,delta)
	local elapsed = time/duration
	if elapsed == 0 then return initial end
	if elapsed == 1 then return initial + delta end
	
	local p = PL.easing.elasticPeriod
	if p == 0 then p = duration * 0.3 end
	
	local s = 0
	local a = PL.easing.elasticAmplitude
	if a == 0 or a < math.abs(delta) then
		a = delta
		s = p/4	
	else
		s = p/(2 * math.pi) * math.asin(delta/a)
	end
	
	return a * (2^(-10 * elapsed)) * math.sin((elapsed * duration - s) * (2 * math.pi)/p) + delta + initial
end

PL.easing.inOutElastic = function(time,duration,initial,delta)
	local elapsed = time/(duration/2)
	if elapsed == 0 then return initial end
	if elapsed == 2 then return initial + delta end
	
	local p = PL.easing.elasticPeriod
	if p == 0 then p = duration * 0.3 * 1.5 end
	
	local s = 0
	local a = PL.easing.elasticAmplitude
	if a == 0 or a < math.abs(delta) then
		a = delta
		s = p/4	
	else
		s = p/(2 * math.pi) * math.asin(delta/a)
	end
	
	
	if elapsed < 1 then
		elapsed = elapsed - 1
		return -0.5 * (a * (2^(10*elapsed)) * math.sin((elapsed * duration - s) * (2 * math.pi)/p)) + initial
	else
		elapsed = elapsed - 1
		return a * (2^(-10 * elapsed)) * math.sin((elapsed * duration - s) * (2 * math.pi)/p) * 0.5 + delta + initial
	end
end





-- Expo
PL.easing.inExpo = function(time,duration,initial,delta)
	if time == 0 then return initial end
	return delta * (2^(10 * (time/duration - 1))) + initial
end

PL.easing.outExpo = function(time,duration,initial,delta)
	if time == duration then return initial + delta end
	return delta * (-(2^(-10 * time/duration)) + 1) + initial
end

PL.easing.inOutExpo = function(time,duration,initial,delta)
	local elapsed = time/(duration/2)
	if elapsed == 0 then return initial end
	if elapsed == 1 then return initial + delta end
	if elapsed < 1 then
		return delta/2 * (2^(10 * (elapsed - 1))) + initial
	else
		elapsed = elapsed - 1
		return delta/2 * (-(2^(-10 * elapsed)) + 2) + initial
	end
end





-- Linear
PL.easing.linear = function(time,duration,initial,delta)
	return delta * time/duration + initial
end





-- Quad
PL.easing.inQuad = function(time,duration,initial,delta)
	local elapsed = time/duration
	return delta * (elapsed^2) + initial
end

PL.easing.outQuad = function(time,duration,initial,delta)
	local elapsed = time/duration
	return -delta * elapsed * (elapsed - 2) + initial
end

PL.easing.inOutQuad = function(time,duration,initial,delta)
	local elapsed = time/(duration/2)
	if elapsed < 1 then
		return delta/2 * (elapsed^2) + initial
	else
		elapsed = elapsed - 1
		return -delta/2 * ((elapsed) * (elapsed - 2) -1) + initial
	end
end





-- Quart
PL.easing.inQuart = function(time,duration,initial,delta)
	local elapsed = time/duration
	return delta * (elapsed^4) + initial
end

PL.easing.outQuart = function(time,duration,initial,delta)
	local elapsed = time/duration - 1
	return -delta * ((elapsed^4) - 1) + initial
end

PL.easing.inOutQuart = function(time,duration,initial,delta)
	local elapsed = time/(duration/2)
	if elapsed < 1 then
		return delta/2 * (elapsed^4) + initial
	else
		elapsed = elapsed - 2
		return -delta/2 * ((elapsed^4) - 2) + initial
	end
end





-- Quint
PL.easing.inQuint = function(time,duration,initial,delta)
	local elapsed = time/duration
	return delta * (elapsed^5) + initial
end

PL.easing.outQuint = function(time,duration,initial,delta)
	local elapsed = time/duration - 1
	return delta * ((elapsed^5) + 1) + initial
end

PL.easing.inOutQuint = function(time,duration,initial,delta)
	local elapsed = time/(duration/2)
	if elapsed < 1 then 
		return delta/2 * (elapsed^5) + initial
	else
		elapsed = elapsed - 2
		return delta/2 * ((elapsed^5) + 2) + initial
	end
end





-- Sine
PL.easing.inSine = function(time,duration,initial,delta)
	return -delta * math.cos(time/duration * math.pi/2) + delta + initial
end

PL.easing.outSine = function(time,duration,initial,delta)
	return delta * math.sin(time/duration * math.pi/2) + initial
end

PL.easing.inOutSine = function(time,duration,initial,delta)
	return -delta/2 * (math.cos(math.pi * time/duration) - 1) + initial
end


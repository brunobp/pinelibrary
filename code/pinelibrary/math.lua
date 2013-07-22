-- math functions
-- Bruno Barbosa Pinheiro 2012, Pine Brothers
-- Pine library

PL.math = {}

function PL.math:clamp(value,min,max)
	local clamped = value
	clamped = math.min(clamped,max)
	clamped = math.max(clamped,min)
	return clamped
end
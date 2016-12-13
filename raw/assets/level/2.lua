return {
	width = 5,
	height = 6,

	'# #..',
	'...X.',
	' ...X',
	'##...',
	'....#',
	'  ^  ',

	win_condition = function (x, y)
		if y<=2 then
			return true
		end
		return false
	end
}
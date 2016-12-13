return {
	width = 3,
	height = 4,
	tutorial = 'controls',

	'#.#',
	'..#',
	'...',
	' ^ ',
	win_condition = function (x, y)
		if y<=2 then
			return true
		end
		return false
	end
}
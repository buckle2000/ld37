return {
	width = 6,
	height = 7,

	'#X...X',
	'#..X.#',
	'X...X#',
	' #...X',
	'#...# ',
	'...# .',
	' ^..X.',

	win_condition = function (x, y)
		if y<=2 then
			return true
		end
		return false
	end
}
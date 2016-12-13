return {
	width = 9,
	height = 10,

	'. ..X....',
	'# #.# ..#',
	'...X#....',
	'.#..X.#. ',
	'... #.. .',
	'....X....',
	'... #..#.',
	'X.. #....',
	'...X#....',
	'    ^    ',

	win_condition = function (x, y)
		if y<=3 and x<5 then
			return true
		end
		return false
	end
}

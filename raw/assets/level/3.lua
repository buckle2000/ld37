return {
	width = 9,
	height = 10,

	'. ..XX XX',
	'# #.#  .#',
	'.#.X#....',
	'.#..X.#. ',
	'... #.. .',
	' #..X....',
	'... #..#X',
	'X.. #....',
	'XXX#XX XX',
	'    ^    ',

	win_condition = function (x, y)
		if y<=3 and x<5 then
			return true
		end
		return false
	end
}

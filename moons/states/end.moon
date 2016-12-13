said = {
  "Thanks for playing!"
  "We really do not have enough time to make more content."
  "But if you like our concept,"
  "   please give us a fair rating"
  ""
  "Thanks again for playing!"
}

said_str = said[1]
for i=2,#said
  said_str ..= '\n'
  said_str ..= said[i]

with {}
  .enter = =>
    lg.setFont lg.newFont(20)
  .draw = =>
    lg.print "The End\n   ... or not", 270, 200
    lg.print said_str, 30, 250


module ApplicationHelper

	def sort_list_correctly_by_field(list, field)
  	list.sort do |x,y|
    	# hack for correctly sorting lists by fields that have æ ø å in them
    	# since lower case letters come after uppercase letters
    	x.send(field).upcase.tr('Æ', 'x').tr('Ø', 'y').tr('Å', 'z') <=> y.send(field).upcase.tr('Æ', 'x').tr('Ø', 'y').tr('Å', 'z')
  	end
  end

  def show_tile_count_table()
  	tiles = [[["A", 7], ["H", 3], ["O", 4], ["W", 1]],
  					 [["B", 3], ["I", 5], ["P", 2], ["Y", 1]],
  					 [["C", 1], ["J", 2], ["R", 6], ["Æ", 1]],
  					 [["D", 5], ["K", 4], ["S", 6], ["Ø", 2]],
  					 [["E", 9], ["L", 5], ["T", 6], ["Å", 2]],
  					 [["F", 4], ["M", 3], ["U", 3], ["?", 2]],
  					 [["G", 4], ["N", 6], ["V", 4]]]

  	show = "<table>"
  	tiles.each do |row|
  		show << "<tr>"
  		row.each { |tile| show << "<td> #{tile.first} - #{tile.last} </td>" }
  		show << "</tr>"
  	end
  	show << "</table>"
  	show.html_safe
  end
end


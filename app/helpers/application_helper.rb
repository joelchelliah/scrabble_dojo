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

  # <table>
  #         <tr>          
  #           <td>P - 2</td>
  #           <td>V - 4</td>
  #           <td>Å - 2</td>
  #         </tr>
  #         <tr>
  #           <td>B - 3</td>
  #           <td>H - 3</td>
  #           <td>L - 5</td>
  #           <td>R - 6</td>
  #           <td>W - 1</td>
  #           <td>? - 2</td>
  #         </tr>
  #         <tr>
  #           <td>C - 1</td>
  #           <td>I - 5</td>
  #           <td>M - 3</td>
  #           <td>S - 6</td>
  #           <td>Y - 1</td>
  #         </tr>
  #         <tr>
  #           <td>D - 5</td>
  #           <td>J - 2</td>
  #           <td>N - 6</td>
  #           <td>T - 6</td>
  #           <td>Æ - 1</td>
  #         </tr>
  #         <tr>
  #           <td>E - 9</td>
            
  #           <td>O - 4</td>
  #           <td>U - 3</td>
  #           <td>Ø - 2</td>
  #         </tr>
  #         <tr>
  #           <td>F - 4</td>
  #           <td>K - 4</td>
  #         </tr>
  #       </table>
end


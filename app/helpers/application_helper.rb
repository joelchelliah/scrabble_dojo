module ApplicationHelper

	def sort_list_correctly_by_field(list, field)
  	list.sort do |x,y|
    	# hack for correctly sorting lists by fields that have æ ø å in them
    	# since lower case letters come after uppercase letters
    	x.send(field).upcase.tr('Æ', 'x').tr('Ø', 'y').tr('Å', 'z') <=> y.send(field).upcase.tr('Æ', 'x').tr('Ø', 'y').tr('Å', 'z')
  	end
  end
end


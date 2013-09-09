class Memo < ActiveRecord::Base
	before_validation :upcase_fields
	validates :name, presence: true, uniqueness: true
	validates :word_list, presence: true, format: { with: /\A([ÆØÅæøåA-Za-z]+\r?\n)*([ÆØÅæøåA-Za-z]+)?\z/ }

	def upcase_fields
		name.upcase!
		word_list.upcase!
		hints.upcase! if hints
	end
end

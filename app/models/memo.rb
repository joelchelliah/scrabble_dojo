class Memo < ActiveRecord::Base
	before_validation :prepare_fields
	validates :name, presence: true, uniqueness: true
	validates :word_list, presence: true, format: { with: /\A([ÆØÅæøåA-Za-z]+\r?\n)*([ÆØÅæøåA-Za-z]+)?\z/ }

	def prepare_fields
		name.upcase!
		word_list.upcase!
		hints.upcase! if hints
		health_decay = Time.now - 10.day unless health_decay
	end
end

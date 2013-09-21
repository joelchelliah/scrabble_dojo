class Memo < ActiveRecord::Base
	belongs_to :user

	default_scope 		-> { order('name ASC') }
	scope :by_health,	-> { order('health_decay ASC') }
	scope :weakest,		-> { by_health.first }

	before_validation :prepare_name, :prepare_word_list
	before_save 			:prepare_hints, :prepare_health_decay
	
	validates :user_id, presence: true
	validates :name, presence: true, uniqueness: true
	validates :word_list, presence: true, format: { with: /\A([ÆØÅÜæøåüA-Za-z]+\r?\n)*([ÆØÅÜæøåüA-Za-z]+)?\z/ }


	private

		def prepare_name
			self.name = self.name.upcase.tr("å-ü", "Å-Ü")
		end

   	def prepare_hints
 			self.hints = self.hints.upcase.tr("å-ü", "Å-Ü") unless self.hints.blank?
   	end

   	def prepare_health_decay
   		self.health_decay = Time.now - 10.day unless self.health_decay
   	end

   	def prepare_word_list
			self.word_list = self.word_list.upcase
																		 .tr(" ", "\n")
												             .tr("å-ü", "Å-Ü")
												             .split(/\r?\n/)
												             .uniq
												             .reject { |w| w == "" }
												             .join("\n")
   	end
end

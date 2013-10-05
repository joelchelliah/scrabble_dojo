class Memo < ActiveRecord::Base

	REGEXP_NEWLINE_SEPERATED_LIST = /\A([ÆØÅÜæøåüA-Za-z]+\r?\n)*([ÆØÅÜæøåüA-Za-z]+)?\z/
	
	belongs_to :user

	default_scope 		-> { order('name ASC') }
	scope :by_health,	-> { order('health_decay ASC').order('practice_disabled ASC') }
	scope :weakest,		-> { by_health.first }

	before_validation :prepare_name, :prepare_word_list, :prepare_accepted_words
	before_save 			:prepare_hints, :prepare_health_decay
	
	validates :user_id, presence: true
	validates :name, presence: true, uniqueness: true
	validates :word_list, presence: true, format: { with: REGEXP_NEWLINE_SEPERATED_LIST }
	validates :accepted_words, format: { with: REGEXP_NEWLINE_SEPERATED_LIST }


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
			self.word_list = prepare_newline_sperated_list self.word_list
   	end

   	def prepare_accepted_words
   		self.accepted_words = prepare_newline_sperated_list self.accepted_words unless self.accepted_words.blank?
   	end

   	def prepare_newline_sperated_list(list)
   		list.upcase
				  .tr(" ", "\n")
          .tr("å-ü", "Å-Ü")
          .split(/\r?\n/)
          .uniq
          .reject { |w| w == "" }
          .join("\n")
    end
end

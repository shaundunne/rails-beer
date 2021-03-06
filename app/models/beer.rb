class Beer < ActiveRecord::Base

	belongs_to :style


	scope :tasted, ->{ where.not(tasted_on: nil) }
	scope :recent, ->{ where('tasted_on > ?', 2.days.ago) }
	scope :filter, ->(name){
		joins(:style).where('styles.name = ?', name) if name.present?
	}

	# A scope always returns a collection, a class method does not.
	scope :search, ->(keyword){where('keywords LIKE ?', "%#{keyword.downcase}%") if keyword.present? }
	scope :find_by_name, ->(name){ where('name =?', name) }


	before_save :set_keywords

	# def self.search(keyword)
	# 	if keyword.present?
	# 		where(name: keyword)
	# 	else
	# 		all
	# 	end		
	# end


	# def tasted?
	# 	tasted_on.present?
	# end

	protected
		def set_keywords
			self.keywords = [name, brewery, description].map(&:downcase).join(' ')
		end

end

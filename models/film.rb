class Film

    attr_reader :id
    attr_accessor :title, :price

    def initialize(options)
        @id = option['id'].to_i() if option['id']
        @title = option['title']
        @price = option['price']
    end

end
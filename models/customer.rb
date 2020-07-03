class Customer

    attr_reader :id
    attr_accessor :name, :funds

    def initialize(options)
        @id = option['id'].to_i() if option['id']
        @name = option['name']
        @funds = option['funds']
    end

end

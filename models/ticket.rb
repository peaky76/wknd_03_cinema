class Ticket

    attr_reader :id
    attr_accessor :customer_id, :film_id

    def initialize(options)
        @id = option['id'].to_i() if option['id']
        @customer_id = option['customer_id'].to_i()
        @film_id = option['film_id'].to_i()
    end

end
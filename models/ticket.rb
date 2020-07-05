require_relative('../db/sql_runner')

class Ticket

    attr_reader :id
    attr_accessor :customer_id, :film_id

    def initialize(options)
        @id = options['id'].to_i() if options['id']
        @customer_id = options['customer_id'].to_i()
        @screening_id = options['screening_id'].to_i()
    end

    # CRUD fns

    def save()
        sql = "INSERT INTO tickets (customer_id, screening_id)
        VALUES ($1, $2)
        RETURNING id"
        values = [@customer_id, @screening_id]
        result = SqlRunner.run(sql, values).first()
        @id = result['id'].to_i()
    end

    def update()
        sql = "UPDATE tickets
        SET (customer_id, screening_id) = ($1, $2)
        WHERE id = $3"
        values = [@customer_id, @screening_id, @id]
        SqlRunner.run(sql, values)
    end

    def delete()
        sql = "DELETE FROM tickets
        WHERE id = $1"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def self.all()
        sql = "SELECT * FROM tickets"
        tickets = SqlRunner.run(sql)
        return tickets.map { |ticket| Ticket.new(ticket) }
    end

    def self.delete_all()
        sql = "DELETE FROM tickets"
        SqlRunner.run(sql)
    end

    # Ticket info

    def film()
        # Get which film this ticket is for via screenings table
        sql = "SELECT films.* FROM films
        INNER JOIN screenings
        ON screenings.film_id = films.id
        WHERE screenings.id = $1"
        values = [@screening_id]
        film_data = SqlRunner.run(sql, values)
        film = film_data.map { |film| Film.new(film) }
        return film.first  
    end

    def date_time()
        # Get time of screening for this ticket via screenings table
        sql = "SELECT date_time FROM screenings
        WHERE id = $1"
        values = [@screening_id]
        screening = SqlRunner.run(sql, values)[0]
        return screening['date_time'] 
    end

    def customer_age()
        sql = "SELECT age FROM customers
        WHERE id = $1"
        values = [@customer_id]
        customer_age = SqlRunner.run(sql, values)[0]['age'].to_i()
        return customer_age
    end

    # Ticket transactions

    def id_check_passed?()
        # Check customer age vs film rating to see if ticket can be sold to them
        return self.customer_age > self.film.rating
    end

    def concession()
        concession = 0
        # Apply discount if the customer qualifies for a concession
        concession = 200 if self.customer_age < 18 || self.customer_age > 65
        return concession
    end

    def off_peak_discount()
        discount = 0
        # Apply discount if the screening is a matinee 
        sql = "SELECT * FROM screenings
        WHERE id = $1"
        values = [@screening_id]
        screening_data = SqlRunner.run(sql, values)
        screening = screening_data.map { |screening| Screening.new(screening) }
        discount = 150 if screening[0].is_matinee?
        return discount
    end

    def price()
        sql = "SELECT price FROM films
        INNER JOIN screenings
        ON screenings.film_id = films.id
        WHERE screenings.id = $1"
        values = [@screening_id]
        base_price = SqlRunner.run(sql, values)[0]['price'].to_i()
        return base_price - self.off_peak_discount - self.concession
    end

    def confirm_sale()
        sql = "UPDATE customers 
        SET funds = funds - $1
        WHERE id = $2"
        values = [self.price(), @customer_id]
        SqlRunner.run(sql, values)
    end

end
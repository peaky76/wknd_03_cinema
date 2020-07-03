require_relative('../db/sql_runner')

class Ticket

    attr_reader :id
    attr_accessor :customer_id, :film_id

    def initialize(options)
        @id = options['id'].to_i() if options['id']
        @customer_id = options['customer_id'].to_i()
        @film_id = options['film_id'].to_i()
    end

    # CRUD fns

    def save()
        sql = "INSERT INTO tickets (customer_id, film_id)
        VALUES ($1, $2)
        RETURNING id"
        values = [@customer_id, @film_id]
        result = SqlRunner.run(sql, values).first()
        @id = result['id'].to_i()
    end

    def update()
        sql = "UPDATE tickets
        SET (customer_id, film_id) = ($1, $2)
        WHERE id = $3"
        values = [@customer_id, @film_id, @id]
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

    # Ticket transactions

    def price()
        sql = "SELECT price FROM films
        WHERE id = $1"
        values = [@film_id]
        result = SqlRunner.run(sql, values).first()
        return result['price'].to_i()
    end

    # def confirm_sale()
    #     sql = "UPDATE customers 
    #     SET funds = $1
    #     WHERE id = $2"
    #     values = [funds, @customer_id]
    #     SqlRunner.run(sql, values)
    # end

end
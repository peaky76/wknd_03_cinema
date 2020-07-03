require_relative('../db/sql_runner')

class Customer

    attr_reader :id
    attr_accessor :name, :funds

    def initialize(options)
        @id = options['id'].to_i() if options['id']
        @name = options['name']
        @funds = options['funds']
    end

    # CRUD fns

    def save()
        sql = "INSERT INTO customers (name, funds) 
        VALUES ($1, $2)
        RETURNING id"
        values = [@name, @funds]
        result = SqlRunner.run(sql, values)
        @id = result.first['id'].to_i
    end

    def update()
        sql = "UPDATE customers
        SET (name, funds) = ($1, $2)
        WHERE id = $3"
        values = [@name, @funds, @id]
        SqlRunner.run(sql, values)
    end

    def delete()
        sql = "DELETE FROM customers
        WHERE id = $1"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def self.all()
        sql = "SELECT * FROM customers"
        customers = SqlRunner.run(sql)
        return customers.map { |customer| Customer.new(customer) }
    end

    def self.delete_all()
        sql = "DELETE FROM customers"
        SqlRunner.run(sql)
    end

    # Customer bookings

    def films()
        sql = "SELECT films.* FROM films
        INNER JOIN tickets
        ON tickets.film_id = films.id
        WHERE tickets.customer_id = $1"
        values = [@id]
        film_data = SqlRunner.run(sql, values)
        films = film_data.map { |film| Film.new(film) }
        return films
    end
    
end

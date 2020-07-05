require_relative('../db/sql_runner')

class Customer

    attr_reader :id
    attr_accessor :name, :funds, :age

    def initialize(options)
        @id = options['id'].to_i() if options['id']
        @name = options['name']
        @funds = options['funds'].to_i()
        @age = options['age'].to_i()
    end

    # CRUD fns

    def save()
        sql = "INSERT INTO customers (name, funds, age) 
        VALUES ($1, $2, $3)
        RETURNING id"
        values = [@name, @funds, @age]
        result = SqlRunner.run(sql, values)
        @id = result.first['id'].to_i
    end

    def update()
        sql = "UPDATE customers
        SET (name, funds, age) = ($1, $2, $3)
        WHERE id = $4"
        values = [@name, @funds, @age, @id]
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

    def ticket_count()
        sql = "SELECT COUNT(*) FROM tickets
        WHERE customer_id = $1"
        values = [@id]
        result = SqlRunner.run(sql, values).first()['count']
        return result
    end

    def ticket_spend()
        films_booked = self.films()
        return films_booked.reduce(0) { |total, film| total + film.price }
    end

end

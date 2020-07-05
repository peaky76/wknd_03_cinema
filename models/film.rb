require_relative('../db/sql_runner')

class Film

    attr_reader :id
    attr_accessor :title, :price, :rating

    def initialize(options)
        @id = options['id'].to_i() if options['id']
        @title = options['title']
        @price = options['price'].to_i()
        @rating = options['rating'].to_i()
    end

    # CRUD fns

    def save()
        sql = "INSERT INTO films (title, price, rating) 
        VALUES ($1, $2, $3)
        RETURNING id"
        values = [@title, @price, @rating]
        result = SqlRunner.run(sql, values)
        @id = result.first['id'].to_i()
    end
    
    def update()
        sql = "UPDATE films
        SET (title, price, rating) = ($1, $2, $3)
        WHERE id = $4"
        values = [@title, @price, @rating, @id]
        SqlRunner.run(sql, values)
    end

    def delete()
        sql = "DELETE FROM films
        WHERE id = $1"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def self.all()
        sql = "SELECT * FROM films"
        films = SqlRunner.run(sql)
        return films.map { |film| Film.new(film) }
    end

    def self.delete_all()
        sql = "DELETE FROM films"
        SqlRunner.run(sql)
    end

    # Customers booked to see film

    def customers()
        sql = "SELECT customers.* FROM customers
        INNER JOIN tickets
        ON tickets.customer_id = customers.id
        INNER JOIN screenings
        ON tickets.screening_id = screenings.id 
        WHERE screenings.film_id = $1"
        values = [@id]
        customer_data = SqlRunner.run(sql, values)
        customers = customer_data.map { |customer| Customer.new(customer) }
        return customers
    end

    def total_sales_count()
        sql = "SELECT COUNT(*) FROM tickets
        INNER JOIN screenings
        ON tickets.screening_id = screenings.id
        WHERE screenings.film_id = $1"
        values = [@id]
        result = SqlRunner.run(sql, values).first()['count']
        return result
    end

    # Screenings info

    def screenings()
        sql = "SELECT * FROM screenings
        WHERE film_id = $1"
        values = [@id]
        screening_data = SqlRunner.run(sql, values)
        return screening_data.map { |screening| Screening.new(screening) }
    end

    def most_popular_screening()
        return self.screenings().max_by { |screening| screening.sales_count }
    end

end
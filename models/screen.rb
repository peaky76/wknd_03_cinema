require_relative('../db/sql_runner')

class Screen

    attr_reader :id
    attr_accessor :number, :capacity

    def initialize(options)
        @id = options['id'].to_i() if options['id']
        @number = options['number'].to_i()
        @capacity = options['capacity'].to_i()
    end

    # CRUD fns

    def save()
        sql = "INSERT INTO screens (number, capacity) 
        VALUES ($1, $2)
        RETURNING id"
        values = [@number, @capacity]
        result = SqlRunner.run(sql, values)
        @id = result.first['id'].to_i()
    end
    
    def update()
        sql = "UPDATE screens
        SET (number, capacity) = ($1, $2)
        WHERE id = $3"
        values = [@number, @capacity, @id]
        SqlRunner.run(sql, values)
    end

    def delete()
        sql = "DELETE FROM screens
        WHERE id = $1"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def self.all()
        sql = "SELECT * FROM screens"
        screens = SqlRunner.run(sql)
        return screens.map { |screen| Screen.new(screen) }
    end

    def self.delete_all()
        sql = "DELETE FROM screens"
        SqlRunner.run(sql)
    end

end
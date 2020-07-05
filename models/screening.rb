require_relative('../db/sql_runner')

class Screening

    attr_reader :id
    attr_accessor :film_id, :screen_id, :date_time

    def initialize(options)
        @id = options['id'].to_i() if options['id']
        @film_id = options['film_id'].to_i()
        @screen_id = options['screen_id'].to_i()
        @date_time = DateTime.strptime(options['date_time'], '%Y-%m-%d %H:%M')
    end

    # CRUD fns

    def save()
        sql = "INSERT INTO screenings (film_id, screen_id, date_time) 
        VALUES ($1, $2, $3)
        RETURNING id"
        values = [@film_id, @screen_id, @date_time]
        result = SqlRunner.run(sql, values)
        @id = result.first['id'].to_i()
    end
    
    def update()
        sql = "UPDATE screenings
        SET (film_id, screen_id, date_time) = ($1, $2, $3)
        WHERE id = $4"
        values = [@film_id, @screen_id, @date_time, @id]
        SqlRunner.run(sql, values)
    end

    def delete()
        sql = "DELETE FROM screenings
        WHERE id = $1"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def self.all()
        sql = "SELECT * FROM screenings"
        screenings = SqlRunner.run(sql)
        return screenings.map { |screening| Screening.new(screening) }
    end

    def self.delete_all()
        sql = "DELETE FROM screenings"
        SqlRunner.run(sql)
    end

    def sales_count()
        sql = "SELECT COUNT(*) FROM tickets
        WHERE screening_id = $1"
        values = [@id]
        result = SqlRunner.run(sql, values).first()['count']
        return result
    end

    def is_matinee?()
        return @date_time.hour <= 17
    end

end
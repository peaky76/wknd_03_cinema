require('pry')
require('date')

require_relative('./models/customer')
require_relative('./models/film')
require_relative('./models/ticket')
require_relative('./models/screen')
require_relative('./models/screening')

Screening.delete_all()
Screen.delete_all()
Ticket.delete_all()
Customer.delete_all()
Film.delete_all()

customer_1 = Customer.new( {'name' => 'Ali', 'funds' => 8000} )
customer_2 = Customer.new( {'name' => 'Bobbie', 'funds' => 10000} )
customer_3 = Customer.new( {'name' => 'Charlie', 'funds' => 6000} )
customers = [customer_1, customer_2, customer_3]
customers.each { |customer| customer.save() }

film_1 = Film.new( {'title' => 'The Godmother Part III', 'price' => 900} )
film_2 = Film.new( {'title' => 'Badfellas', 'price' => 800} )
film_3 = Film.new( {'title' => 'The Good, The Bad and The Average-Looking', 'price' => 1200} )
films = [film_1, film_2, film_3]
films.each { |film| film.save() }

screen_1 = Screen.new( {'number' => 1, 'capacity' => 50} )
screen_2 = Screen.new( {'number' => 2, 'capacity' => 30} )
screen_3 = Screen.new( {'number' => 3, 'capacity' => 20} )
screens = [screen_1, screen_2, screen_3]
screens.each { |screen| screen.save() }

screen_1.capacity = 60
screen_1.update()

screening_1 = Screening.new( {'film_id' => film_1.id, 'screen_id' => screen_3.id, 'date_time' => DateTime.new(2020,8,1,13,0)} )
screening_2 = Screening.new( {'film_id' => film_1.id, 'screen_id' => screen_2.id, 'date_time' => DateTime.new(2020,8,1,16,0)} ) 
screening_3 = Screening.new( {'film_id' => film_1.id, 'screen_id' => screen_1.id, 'date_time' => DateTime.new(2020,8,1,19,0)} )
screening_4 = Screening.new( {'film_id' => film_2.id, 'screen_id' => screen_3.id, 'date_time' => DateTime.new(2020,8,1,15,30)} )
screening_5 = Screening.new( {'film_id' => film_2.id, 'screen_id' => screen_2.id, 'date_time' => DateTime.new(2020,8,1,18,30)} )
screening_6 = Screening.new( {'film_id' => film_3.id, 'screen_id' => screen_2.id, 'date_time' => DateTime.new(2020,8,1,19,30)} )
screenings = [screening_1, screening_2, screening_3, screening_4, screening_5, screening_6]
screenings.each { |screening| screening.save() }

screening_6.screen_id = screen_3.id
screening_6.update()

ticket_1 = Ticket.new( {'customer_id' => customer_1.id, 'film_id' => film_1.id} )
ticket_2 = Ticket.new( {'customer_id' => customer_1.id, 'film_id' => film_2.id} )
ticket_3 = Ticket.new( {'customer_id' => customer_1.id, 'film_id' => film_3.id} )
ticket_4 = Ticket.new( {'customer_id' => customer_2.id, 'film_id' => film_1.id} )
ticket_5 = Ticket.new( {'customer_id' => customer_2.id, 'film_id' => film_2.id} )
ticket_6 = Ticket.new( {'customer_id' => customer_3.id, 'film_id' => film_1.id} )
tickets = [ticket_1, ticket_2, ticket_3, ticket_4, ticket_5, ticket_6]
tickets.each { |ticket| ticket.save() }
tickets.each { |ticket| ticket.confirm_sale() }

binding.pry
nil
require('pry')

require_relative('./models/customer')
require_relative('./models/film')
require_relative('./models/ticket')

Ticket.delete_all()
Customer.delete_all()
Film.delete_all()

customer_1 = Customer.new( {'name' => 'Ali', 'funds' => 8000} )
customer_1.save()

customer_2 = Customer.new( {'name' => 'Bobbie', 'funds' => 1000000} )
customer_2.save()

customer_2.funds = 10000
customer_2.update()

film_1 = Film.new( {'title' => 'The Godmother Part III', 'price' => 900} )
film_1.save()

film_1.title = 'The Godmother Part II'
film_1.update()

film_2 = Film.new( {'title' => 'Badfellas', 'price' => 800} )
film_2.save()

film_3 = Film.new( {'title' => 'The Good, The Bad and The Average-Looking', 'price' => 1200} )
film_3.save()

ticket_1 = Ticket.new( {'customer_id' => customer_1.id, 'film_id' => film_3.id} )
ticket_1.save()

ticket_2 = Ticket.new( {'customer_id' => customer_2.id, 'film_id' => film_2.id} )
ticket_2.save()

ticket_2.film_id = film_3.id
ticket_2.update()

binding.pry
nil
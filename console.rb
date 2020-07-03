require('pry')

require_relative('./models/customer')
require_relative('./models/film')
require_relative('./models/ticket')

customer_1 = Customer.new( {'name' => 'Ali', 'funds' => 8000} )
customer_1.save()

film_1 = Film.new( {'title' => 'The Godmother Part II', 'price' => 900} )
film_1.save()

film_2 = Film.new( {'title' => 'Badfellas', 'price' => 800} )
film_2.save()

ticket_1 = Ticket.new( {'customer_id' => customer_1.id, 'film_id' => film_1.id} )
ticket_1.save()

binding.pry
nil
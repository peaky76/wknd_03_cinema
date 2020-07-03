require('pry')

require_relative('./models/customer')
require_relative('./models/film')
require_relative('./models/ticket')

Ticket.delete_all()
Customer.delete_all()
Film.delete_all()

customer_1 = Customer.new( {'name' => 'Ali', 'funds' => 8000} )
customer_1.save()

customer_2 = Customer.new( {'name' => 'Bobbie', 'funds' => 10000} )
customer_2.save()

film_1 = Film.new( {'title' => 'The Godmother Part II', 'price' => 900} )
film_1.save()

film_2 = Film.new( {'title' => 'Badfellas', 'price' => 800} )
film_2.save()

film_3 = Film.new( {'title' => 'The Good, The Bad and The Average-Looking', 'price' => 1200} )
film_3.save()

ticket_1 = Ticket.new( {'customer_id' => customer_1.id, 'film_id' => film_3.id} )
ticket_1.save()

ticket_2 = Ticket.new( {'customer_id' => customer_2.id, 'film_id' => film_3.id} )
ticket_2.save()

customer_1.delete()
film_1.delete()
ticket_1.delete()

binding.pry
nil
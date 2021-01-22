from faker import Faker
import random

TABLE_SIZE = 1000

myFactory = Faker('ru_RU')

genre = ["Драма", "Мелодрама", "Комедия", "Трагедия",
         "Ситкома","Детектив", "Триллер", "Ужасы",
         "Слешер","Арт-хаус", "Фантастика", "Фентези"]

country = ["Австралия", "Германия", "Испания", "Италия",
           "Франция", "Россия", "Китай", "Америка", "Англия"]

t = ["Серебряная", "Платиновая", "Золотая"]


def generate_user():
    
# User_id, Name, age, sub_id

    file = open("user_data.txt", "w")

    for i in range(TABLE_SIZE):
        
        # user_id = str(i)
        user_name = myFactory.name()
        user_age = str(random.randint(10, 85))
        sub_type = str(random.randint(0, 2))
        # подписка, которую ты, бездельник, так и не придумал

        user  = ", " + user_name + ", " + user_age + ", " + sub_type + "\n"
        
        file.write(user)
        
    file.close()



def generate_actor():
    
# actor_id, Name, age,

    file = open("actor_data.txt", "w")

    for i in range(TABLE_SIZE):
        
        # actor_id = str(i)
        actor_name = myFactory.name()
        actor_age = str(random.randint(10, 85))

        actor  = ", " + actor_name + ", " + actor_age + "\n"
        # actor  = actor_name + "\t" + actor_age + "\n"
        
        file.write(actor)
        
    file.close()


def generate_tv_show():

# show_id, name, genre, country, seasons_num, rate

    file = open("show_data.txt", "w")

    for i in range(TABLE_SIZE):
        
        # show_id = str(i)
        show_name = myFactory.word()
        show_genre = myFactory.word(genre)
        show_country = myFactory.word(country)
        seasons_num = str(random.randint(1, 15))
        rate = str(random.randint(1, 10))

        show = ", " + show_name + ", " +\
               show_genre + ", " + show_country + ", " +\
               seasons_num + ", " + rate + "\n"
        
        file.write(show)
        
    file.close()



def generate_movie():

# movie_id, name, genre, country, length, rate

    file = open("movie_data.txt", "w")

    for i in range(TABLE_SIZE):
        
        # movie_id = str(i)
        movie_name = myFactory.word()
        movie_genre = myFactory.word(genre)
        movie_country = myFactory.word(country)
        length = str(random.randint(63, 245)) # в минутах
        rate = str(random.randint(1, 10))

        movie = ", " + movie_name + ", " +\
               movie_genre + ", " + movie_country + ", " +\
               length + ", " + rate + "\n"
        
        file.write(movie)
        
    file.close()



def generate_sub():

# id, price, type, добавить длительность если хватит мозгов придумать как

    file = open("sub_data.txt", "w")

    for i in range(3):

        sub_id = str(500+i)
        price = str(1000 + 1000*i)
        sub_type = t[i]

        sub =", " + \
              price + ", " + \
              sub_type + "\n"

        file.write(sub)


def generate_show_movie_actor():
    # actor_id, show_id

    file1 = open("actor_show_data.txt", "w")
    file2 = open("actor_movie_data.txt", "w")
    
    for i in range(TABLE_SIZE):
        
        actor_id = str(random.randint(0, 1000))
        show_id = str(random.randint(0, 1000))
        movie_id = str(random.randint(0, 1000))

        actor_show = actor_id + ", " + show_id + "\n"
        actor_movie = actor_id + ", " + movie_id + "\n"

        file1.write(actor_show)
        file2.write(actor_movie)

    file1.close()
    file2.close()


def generate_sub_movie_show():

    file = open("generate_sub_type.txt", "w")
    for i in range(100):
        sub_type = str(0)
        show_id = str(i)
        movie_id = str(i)

        c = sub_type + ", " + show_id + ", " + movie_id + "\n"
        file.write(c)
        
    for i in range(50, 350):
        sub_type = str(1)
        show_id = str(i)
        movie_id = str(i)

        c = sub_type + ", " + show_id + ", " + movie_id + "\n"
        file.write(c)

    for i in range(300, 900):
        sub_type = str(2)
        show_id = str(i)
        movie_id = str(i)

        c = sub_type + ", " + show_id + ", " + movie_id + "\n"
        file.write(c)

    file.close()

        
# generate_user()
# generate_actor()
generate_tv_show()
generate_movie()
#generate_sub()
# generate_sub_movie_show()
# generate_show_movie_actor()


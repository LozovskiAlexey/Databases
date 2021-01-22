import pyodbc

def show(cursor):
    for row in cursor:
        print(row)

    
server = 'DESKTOP-0RGQUOR'
database = 'dbRK3' 

# соеднинение с бд
cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};\
                       SERVER=' + server + ';\
                       DATABASE=' + database +';\
                       Trusted_Connection=yes;')

# подключили курсор
cursor = cnxn.cursor()


# insert data
insert_query = '''insert into dbo.Employee (id, full_name, birth_date, department)
                  values (?, ?, ?, ?);'''

# просто пусть будет тут, почему нет, правда ведь?
# выделили данные для вставки в таблицу
EmployeeData = [[3, 'Дмитриев Двитрий Дмитриевич', '25-09-1994', 'ИТ'],
                [4, 'Александров Александр Евгениевич', '25-09-1980', 'ИТ']]
 

# вставка данных в таблицу

# for row in EmployeeData: 
#     values = (row[0], row[1], row[2], row[3])
#     cursor.execute(insert_query, values)
# сохранить изменения
# cnxn.commit()


# выполнить запрос, вывести все данные из таблицы
# на уровне бд
cursor.execute('select department \
               from dbo.Employee as Empl\
               join dbo.TimeControl as TC on Empl.id=TC.Employee_id\
               where action_type = 1 and datepart(hour, timer) = 9 and datepart(minute, timer) = 0\
               group by department')

# result = cursor.fetchall() # получить результат из таблицы
show(cursor) # отображение полученных данных из запроса выше или обработать result


cursor/execute('select id \
                from (    \
                    select id, count(id)\
                    from dbo.Employee as Empl \
                    join dbo.TimeController as TC on TC.Employee_id = Empl.id\
                    where action_type = 2\
                    group by id')

# завершение работы курсора         
cursor.close()
cnxn.close()

# выполнение на уровне языка
# cursor = cnxn.cursor(cursor_factory=DictCursor) # можно обращаться к значениям по столбцу
# cursor.execute() # выполнить запрос 
# workers = Enumerable(cursor.fetchall())  # получить данные в нужном формате
# обработать данные как массив


import sqlite3
connection = sqlite3.connect("world.db")
cursor = connection.cursor()
query = "SELECT * FROM Country WHERE region='Australia and New Zealand';"
cursor.execute(query)
results = cursor.fetchall()
for r in results:
    print r
    
cursor.close()
connection.close()


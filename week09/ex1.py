import psycopg2
import geopy

con = psycopg2.connect(database="dvdrental", user="riseinokoe",
                       password="Chenskiy2107", host="127.0.0.1", port="5432")

cur = con.cursor()

cur.execute('''SELECT * FROM get_regexp_and_id_range('%11%', 400, 600)''')
query = cur.fetchall()
for i in query:
    try:
        locator = geopy.Nominatim(user_agent=i[1])
        coords = locator.geocode(i[1])
        print(coords.address)
    except:
        print('Address not found')

cur.close()
con.close()

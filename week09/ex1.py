import psycopg2
import geopy

con = psycopg2.connect(database="dvdrental", user="riseinokoe",
                       password="Chenskiy2107", host="127.0.0.1", port="5432")

cur = con.cursor()

cur.execute('''SELECT * FROM get_regexp_and_id_range('%11%', 400, 600);''')
query = cur.fetchall()
for i in query:
    sql = '''UPDATE address SET latitude = %s, longitude = %s WHERE address_id = %s'''
    data = (0, 0, i[0])
    print(i)
    try:
        locator = geopy.Nominatim(user_agent=i[1])
        coords = locator.geocode(i[1])
        latitude = coords.latitude
        longitude = coords.longitude
        data = (latitude, longitude, i[0])
        cur.execute(sql, data)
        print(latitude, longitude, sep=', ')
    except:
        cur.execute(sql, data)
        print(0, 0, sep=', ')

cur.execute('''SELECT longitude, latitude FROM address WHERE longitude IS NOT NULL AND latitude IS NOT NULL''')
print(cur.fetchall())

con.commit()

cur.close()
con.close()

import select
import psycopg2
import psycopg2.extensions
import subprocess
from halo import Halo
conn = psycopg2.connect(dbname='pg_pubsub', user='postgres', host='localhost', password='123456')
conn.set_isolation_level(psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT)
curs = conn.cursor()
curs.execute("LISTEN mensagens;")
spinner = Halo(text='Aguardando as notificações', spinner='dots')
spinner.start()
while 1:
    if select.select([conn], [], [], 5) == ([], [], []):
        pass
    else:
        conn.poll()
        while conn.notifies:
            notify = conn.notifies.pop()
            print('\n')
            print("Notificação assincrona:", notify.pid, notify.channel, notify.payload)
spinner.stop()

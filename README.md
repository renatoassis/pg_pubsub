# pg_pubsub

Setup postgres [docker](https://docs.docker.com/install/)

*considerando que tenha docker instalado

```bash
  pip install pgcli
  pip install docker-compose 
  docker-compose up -d 
  pgcli -U postgres -d pg_pubsub  -h localhost # senha 123456
```

Setup `notify.py`
```bash
  cd notify-python
  pip install pipenv
  pipenv install
  pipenv shell
  python notify.py
```

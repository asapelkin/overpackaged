import os
os.environ['LC_ALL'] = 'C.UTF-8'
os.environ['LANG'] = 'C.UTF-8'
import click
import pycurl
from io import BytesIO
from psycopg2 import sql
import myextension

@click.group()
def cli():
    pass


def query_db():
    current_datetime = '2023-09-23 10:00:00'
    query = sql.SQL(
        "SELECT {date}::TIMESTAMP;"
    ).format(
        date=sql.Literal(current_datetime)
    )
    print(query)


def call_extension(number):
    myextension.print_string(number)
    
def discard_output(data):
    pass

@cli.command()
def run():
    query_db()
    call_extension("Checking availability...")
    sites = ["http://yahoo.com", "http://google.com", "http://ya.ru"]
    for site in sites:
        c = pycurl.Curl()
        c.setopt(c.URL, site)
        c.setopt(pycurl.WRITEFUNCTION, discard_output)  # Добавьте эту строку
        c.perform()
        http_status = c.getinfo(pycurl.HTTP_CODE)
        c.close()
        print(f'Status of {site}: {http_status}')

 
if __name__ == '__main__':
    cli()


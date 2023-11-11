import os
import sys
os.environ['LC_ALL'] = 'C.UTF-8'
os.environ['LANG'] = 'C.UTF-8'
import click
import pycurl
from psycopg2 import sql, Date
import myextension

@click.group()
def cli():
    pass


def check_psycopg2():
    """
    Random code to check psycopg2
    """
    try:
        date = Date(2023, 1, 1)
        query = sql.SQL("SELECT {} FROM {}").format(
            sql.Identifier('column_name'), sql.Identifier('table_name')
        )
        if not date or not query:
            raise RuntimeError(f"date: {date}, query: {query}")
    except Exception as e:
        print(f"Looks like psycopg2 cannot operate normally: {e}")
        sys.exit(1)
    print("psycopg2 works!")


def check_pycurl():
    """
    Random code to check pycurl
    """
    try:
        url = "http://google.com"
        c = pycurl.Curl()
        c.setopt(c.URL, url)
        c.setopt(c.FOLLOWLOCATION, True)
        c.setopt(pycurl.WRITEFUNCTION, discard_output)
        c.perform()
        http_status = c.getinfo(pycurl.HTTP_CODE)
        c.close()
        assert 200 <= http_status < 300
    except Exception as e:
        print(f"Looks like pycurl cannot operate normally: {e}")
        sys.exit(1)

    print("pycurl works!")


def check_extension():
    myextension.print_string("42")
    print("myextension works!")


def discard_output(data):
    pass


@cli.command()
def run():
    check_psycopg2()
    check_pycurl()
    check_extension()


if __name__ == '__main__':
    cli()

#!/usr/bin/env python3
import logging

import psycopg2
from psycopg2 import sql
from psycopg2.extensions import quote_ident


class PlPy(object):

    def __init__(self, dsn=None, logger=None):
        if logger is None:
            logger = logging.getLogger(__name__)
        self.logger = logger
        if dsn is None:
            dsn = ''
        self.dsn = dsn
        self.db = psycopg2.connect(dsn=self.dsn)
        self.cursor = self.db.cursor()
        self.ident = quote_ident(value=None, scope=None)
        self.literal = sql.Literal

    def notice(self, message):
        self.logger.info(message)

    def debug(self, message):
        self.logger.info(message)

    def log(self, message):
        self.logger.info(message)

    def info(self, message):
        self.logger.info(message)

    def warning(self, message):
        self.logger.info(message)

    def error(self, message):
        self.logger.info(message)

    def fatal(self, message):
        self.logger.info(message)


    def execute(self, *args, **kwargs):
        return self.cursor.execute(*args, **kwargs)

    def prepare(self, statement):
        return self.execute(f"PREPARE {statement}")


    def quote_literal(self, *args, **kwargs):
        return self.literal(*args, **kwargs)

    def quote_ident(self, value):
        scope = self.cursor
        if self.cursor is None:
            scope = self.db
        return self.ident(value, scope)



# Prueba
# Conexion a la BD

import pyodbc


class FarmasDBConnection:
    
    def __init__(self, server, db) :
        self.server = server
        self.db = db


    # Hacer la conexion a la bd
    def connection(self):
        try:
            connection = 'DRIVER={ODBC Driver 17 for SQL server}; SERVER=' + self.server + '; DATABASE='+ self.bd + '; Trusted_Connection=yes'
            self.connection = pyodbc.connect(connection)
            print('Good connection')
            self.cursor = self.connection.cursor()
            
        except pyodbc.Error as e:
            print(f'Bad connection {e}')
            self.connection = None
            self.cursor = None
    
    # Cerrar la conexion a la bd
    def close(self):
        if self.cursor:
            self.cursor.close()
        if self.connection:
            self.connection.close()
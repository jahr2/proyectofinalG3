
# Aca importamos la clase donde hicimos la conexion
from Database import FarmasDBConnection

class UserRepository:
    def __init__(self, db_connection :FarmasDBConnection):
        self.db = db_connection

    def GetUserById(self, id: int):
        query = "SELECT [Id],[FirstName],[LastName],[UserName],[Email],[EmailConfirmed],[PasswordHash],[SecurityStamp],[PhoneNumber],[PhoneNumberConfirmed],[LockoutEndDateUtc],[LockoutEnabled],[AccessFailedCount]"
        + "FROM [Users] WHERE [Id]=?;"

        params = (id,)

        result = self.db.execute_query(query, params)

        




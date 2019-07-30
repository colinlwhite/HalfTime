using Dapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HalfTime.Models;
using System.Data.SqlClient;

namespace HalfTime.Data
{
    public class usersRepository
    {
        const string ConnectionString = "Server=localhost;Database=HalfTimeDB;Trusted_Connection=True;";

        public User getUser(int id)
        {
            var sql = "select u.Id, u.FireBaseUid, u.FirstName, u.LastName, u.Street, u.City, u.State, u.ZipCode, u.PhoneNumber from [User] u where u.Id = @id";
            using (var db = new SqlConnection(ConnectionString))
            {
                var user = db.QueryFirstOrDefault<User>(sql, new { id });
                return user;
            }

        }

        public User AddUser(User newUserObj)
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var newUser = db.QueryFirstOrDefault<User>(@"
                    Insert into [User](firebaseuid, firstname, lastname, street, city, state, zipcode, phonenumber)
                    Output inserted.*
                    Values(@firebaseuid, @firstname, @lastname, @street, @city, @state, @zipcode, @phonenumber)",
                    new
                    {
                        newUserObj.FireBaseUid,
                        newUserObj.FirstName,
                        newUserObj.LastName,
                        newUserObj.Street,
                        newUserObj.City,
                        newUserObj.State,
                        newUserObj.ZipCode,
                        newUserObj.PhoneNumber,
                    });

                if (newUser != null)
                {
                    return newUser;
                }
            }

            throw new Exception("Unfortunatley, a new user was not created");
        }

        public User updateUser(User userToUpdate)
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var updateQuery = @"Update [User]
                                    Set FireBaseUid = @firebaseuid,
                                    FirstName = @firstname,
                                    LastName = @lastname,
                                    Street = @street,
                                    City = @city, 
                                    State = @state, 
                                    ZipCode = @zipcode, 
                                    PhoneNumber = @phonenumber
                                    Where Id = @id";

                var rowsAffected = db.Execute(updateQuery, userToUpdate);

                if (rowsAffected == 1)
                {
                    return userToUpdate;
                }
                throw new Exception("We could not update the user");
            }
        }

        public void DeleteUser(int id)
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var parameter = new { Id = id };

                var deleteQuery = "Delete from [User] where Id = @id";

                var rowsAffected = db.Execute(deleteQuery, parameter);

                if (rowsAffected != 1)
                {
                    throw new Exception("We couldn't delete the user at this time");
                }
            }
        }
    }
}

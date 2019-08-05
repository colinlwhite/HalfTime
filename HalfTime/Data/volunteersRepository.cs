using Dapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HalfTime.Models;
using System.Data.SqlClient;

namespace HalfTime.Data
{
    public class volunteersRepository
    {

        const string ConnectionString = "Server=localhost;Database=HalfTimeDB;Trusted_Connection=True;";

        public Volunteer getVolunteer(int id)
        {
            var sql = "select Volunteer.Id, Volunteer.FirstName, Volunteer.LastName, Volunteer.Street, Volunteer.City, Volunteer.State, Volunteer.ZipCode, Volunteer.PhoneNumber from Volunteer where Volunteer.Id = @id";
            using (var db = new SqlConnection(ConnectionString))
            {
                var singleVolunteer = db.QueryFirstOrDefault<Volunteer>(sql, new { id });
                return singleVolunteer;

            }
        }

        public IEnumerable<Volunteer> getUserVolunteers(int id)
        {
            var sql = "select Volunteer.Id, Volunteer.FirstName, Volunteer.LastName, Volunteer.Street, Volunteer.City, Volunteer.State, Volunteer.ZipCode, Volunteer.PhoneNumber from Volunteer join UserVolunteerJoin on Volunteer.Id = UserVolunteerJoin.VolunteerId join [User] u on UserVolunteerJoin.UserId = u.Id where u.Id = @id and Volunteer.IsDeleted = 0 OR Volunteer.IsDeleted IS NULL";
            using (var db = new SqlConnection(ConnectionString))
            {
                var volunteers = db.Query<Volunteer>(sql, new { id }).ToList();
                return volunteers;
            }

        }

        public Volunteer AddVolunteer(Volunteer newVolunteerObj)
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var newVolunteer = db.QueryFirstOrDefault<Volunteer>(@"
                    Insert into volunteer(firstname, lastname, street, city, state, zipcode, phonenumber)
                    Output inserted.*
                    Values(@firstname, @lastname, @street, @city, @state, @zipcode, @phonenumber)",
                    new
                    {
                        newVolunteerObj.FirstName,
                        newVolunteerObj.LastName,
                        newVolunteerObj.Street,
                        newVolunteerObj.City,
                        newVolunteerObj.State,
                        newVolunteerObj.ZipCode,
                        newVolunteerObj.PhoneNumber,
                    });

                if (newVolunteer != null)
                {
                    return newVolunteer;
                }
            }

            throw new Exception("Unfortunatley, a new volunteer was not created");
        }

        public void InsertVolunteerJoinTable()
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var volunteerInsert = "INSERT INTO UserVolunteerJoin values ((SELECT U.Id FROM [User] U WHERE U.Id = 1),(Select TOP(1) Volunteer.Id FROM Volunteer ORDER BY Volunteer.Id DESC))";

                var rowAffected = db.Execute(volunteerInsert);
            }
        }

        public Volunteer updateVolunteer(Volunteer volunteerToUpdate)
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var updateQuery = @"Update Volunteer
                                    Set FirstName = @firstname,
                                    LastName = @lastname,
                                    Street = @street,
                                    City = @city,
                                    State = @state,
                                    ZipCode = @zipcode,
                                    PhoneNumber = @phonenumber
                                    Where Id = @id";

                var rowsAffected = db.Execute(updateQuery, volunteerToUpdate);

                if (rowsAffected == 1)
                {
                    return volunteerToUpdate;
                }
                throw new Exception("We could not update the volunteer");
            }
        }

        public void DeleteVolunteer(int id)
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var parameter = new { Id = id };

                var deleteQuery = "Update Volunteer SET isDeleted = 1 where Volunteer.Id = @id";

                var rowsAffected = db.Execute(deleteQuery, parameter);

                if (rowsAffected != 1)
                {
                    throw new Exception("We couldn't delete the volunteer at this time");
                }
            }
        }
    }
}

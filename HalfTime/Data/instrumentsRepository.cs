using Dapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HalfTime.Models;
using System.Data.SqlClient;

namespace HalfTime.Data
{
    public class instrumentsRepository
    {

        const string ConnectionString = "Server=localhost;Database=HalfTimeDB;Trusted_Connection=True;";

        public Instrument getInstrument(int id)
        {
            var sql = "select Instrument.Id, Instrument.Name, Instrument.Condition, Instrument.Category, Instrument.StudentId, Instrument.Description, Instrument.Brand, Instrument.ModelNumber from Instrument where Instrument.Id = @id";
            using (var db = new SqlConnection(ConnectionString))
            {
                var singleInstrument = db.QueryFirstOrDefault<Instrument>(sql, new { id });
                return singleInstrument;

            }
        }

        public IEnumerable <Instrument> getUserInstruments(int id)
        {
            var sql = "select Instrument.Id, Instrument.Name, Instrument.Condition, Instrument.Category, Instrument.StudentId, Instrument.Description, Instrument.Brand, Instrument.ModelNumber from Instrument join UserInstrumentJoin on Instrument.Id = UserInstrumentJoin.InstrumentId join [User] u on UserInstrumentJoin.UserId = u.Id where u.Id = @id and Instrument.IsDeleted = 0 OR Instrument.IsDeleted IS NULL";
            using (var db = new SqlConnection(ConnectionString))
            {
                var instruments = db.Query<Instrument>(sql, new { id }).ToList();
                return instruments;
            }
            
        }

        public Instrument AddInstrument(Instrument newInstrumentObj)
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var newInstrument = db.QueryFirstOrDefault<Instrument>(@"
                    Insert into instrument(name, condition, category, studentId, description, brand, modelnumber)
                    Output inserted.*
                    Values(@name, @condition, @category, @studentId, @description, @brand, @modelnumber)",
                    new
                    {
                        newInstrumentObj.Name,
                        newInstrumentObj.Condition,
                        newInstrumentObj.Category,
                        newInstrumentObj.StudentId,
                        newInstrumentObj.Description,
                        newInstrumentObj.Brand, 
                        newInstrumentObj.ModelNumber,
                    });

                if (newInstrument != null)
                {
                    return newInstrument;
                }
            }

            throw new Exception("Unfortunatley, a new instrument was not created");
        }

        public void InsertInstrumentJoinTable()
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var instrumentInsert = "INSERT INTO UserInstrumentJoin values ((SELECT U.Id FROM [User] U WHERE U.Id = 1),(Select TOP(1) Instrument.Id FROM Student ORDER BY Instrument.Id DESC))";

                var rowAffected = db.Execute(instrumentInsert);
            }
        }

        public Instrument updateInstrument(Instrument instrumentToUpdate)
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var updateQuery = @"Update Instrument
                                    Set Name = @name,
                                    Condition = @condition,
                                    Category = @category,
                                    StudentId = @studentid,
                                    Description = @description,
                                    Brand = @brand,
                                    ModelNumber = @modelnumber
                                    Where Id = @id";

                var rowsAffected = db.Execute(updateQuery, instrumentToUpdate);

                if (rowsAffected == 1)
                {
                    return instrumentToUpdate;
                }
                throw new Exception("We could not update the instrument");
            }
        }

        public void DeleteInstrument(int id)
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var parameter = new { Id = id };

                var deleteQuery = "Update Instrument SET isDeleted = 1 where Instrument.Id = @id";

                var rowsAffected = db.Execute(deleteQuery, parameter);

                if (rowsAffected != 1)
                {
                    throw new Exception("We couldn't delete the instrument at this time");
                }
            }
        }
    }
}

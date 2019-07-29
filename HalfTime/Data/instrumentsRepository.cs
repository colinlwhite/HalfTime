﻿using Dapper;
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

        public IEnumerable <Instrument> getUserInstruments(int id)
        {
            var sql = "select Instrument.Id, Instrument.Name, Instrument.Condition, Instrument.Category, Instrument.StudentId, Instrument.Description, Instrument.Brand, Instrument.ModelNumber from Instrument join UserInstrumentJoin on Instrument.Id = UserInstrumentJoin.InstrumentId join [User] u on UserInstrumentJoin.UserId = u.Id where u.Id = @id";
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
    }
}

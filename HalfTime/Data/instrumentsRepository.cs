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

        const string ConnectionString = "Server=localhost;Database=HalfTime;Trusted_Connection=True;";

        public IEnumerable <Instrument> getUserInstruments(int id)
        {
            var sql = "select Instrument.Id, Instrument.Name, Instrument.Condition, Instrument.Category, Instrument.StudentId, Instrument.Brand, Instrument.ModelNumber from Instrument join UserInstrumentJoin on Instrument.Id = UserInstrumentJoin.InstrumentId join [User] u on UserInstrumentJoin.UserId = u.Id where u.Id = @id";
            using (var db = new SqlConnection(ConnectionString))
            {
                var instruments = db.Query<Instrument>(sql, new { id }).ToList();
                return instruments;
            }
            
        }
    }
}

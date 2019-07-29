using Dapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HalfTime.Models;
using System.Data.SqlClient;

namespace HalfTime.Data
{
    public class studentsRepository
    {

        const string ConnectionString = "Server=localhost;Database=HalfTimeDB;Trusted_Connection=True;";

        public IEnumerable<Student> getUserStudents(int id)
        {
            var sql = "select Student.Id, Student.FirstName, Student.LastName, Student.Street, Student.City, Student.State, Student.ZipCode from Student join UserStudentJoin on Student.Id = UserStudentJoin.StudentId join [User] u on UserStudentJoin.UserId = u.Id where u.Id = @id";
            using (var db = new SqlConnection(ConnectionString))
            {
                var students = db.Query<Student>(sql, new { id }).ToList();
                return students;
            }

        }
    }
}

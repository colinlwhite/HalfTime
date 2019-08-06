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

        public Student getStudent(int id)
        {
            var sql = "select Student.Id, Student.FirstName, Student.LastName, Student.Street, Student.City, Student.State, Student.ZipCode, Student.Gender, Student.Grade, Student.Chair from Student where Student.Id = @id";
            using (var db = new SqlConnection(ConnectionString))
            {
                var singleStudent = db.QueryFirstOrDefault<Student>(sql, new { id });
                return singleStudent;

            }
        }

        public IEnumerable<Student> getUserStudents(int id)
        {
            var sql = "select Student.Id, Student.FirstName, Student.LastName, Student.Street, Student.City, Student.State, Student.ZipCode, Student.Gender, Student.Grade, Student.Chair from Student join UserStudentJoin on Student.Id = UserStudentJoin.StudentId join [User] u on UserStudentJoin.UserId = u.Id where u.Id = @id and Student.IsDeleted = 0 OR Student.IsDeleted IS NULL";
            using (var db = new SqlConnection(ConnectionString))
            {
                var students = db.Query<Student>(sql, new { id }).ToList();
                return students;
            }

        }

        public Student AddStudent(Student newStudentObj)
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var newStudent = db.QueryFirstOrDefault<Student>(@"
                    Insert into student(firstname, lastname, street, city, state, zipcode, gender, grade, chair)
                    Output inserted.*
                    Values(@firstname, @lastname, @street, @city, @state, @zipcode, @gender, @grade, @chair)",
                    new
                    {
                        newStudentObj.FirstName,
                        newStudentObj.LastName,
                        newStudentObj.Street,
                        newStudentObj.City,
                        newStudentObj.State,
                        newStudentObj.ZipCode,
                        newStudentObj.Gender,
                        newStudentObj.Grade,
                        newStudentObj.Chair,
                    });

                if (newStudent != null)
                {
                    return newStudent;
                }
            }

            throw new Exception("Unfortunatley, a new student was not created");
        }

        public void InsertStudentJoinTable()
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var studentInsert = "INSERT INTO UserStudentJoin values ((SELECT U.Id FROM [User] U WHERE U.Id = 1),(Select TOP(1) Student.Id FROM Student ORDER BY Student.Id DESC))";

                var rowAffected = db.Execute(studentInsert);
            }

        }

        public Student updateStudent(Student studentToUpdate)
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var updateQuery = @"Update Student
                                    Set FirstName = @firstname,
                                    LastName = @lastname,
                                    Street = @street,
                                    City = @city,
                                    State = @state,
                                    ZipCode = @zipcode,
                                    Gender = @gender, 
                                    Grade = @grade, 
                                    Chair = @chair
                                    Where Id = @id";

                var rowsAffected = db.Execute(updateQuery, studentToUpdate);

                if (rowsAffected == 1)
                {
                    return studentToUpdate;
                }
                throw new Exception("We could not update the student");
            }
        }

        public void DeleteStudent(int id)
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var parameter = new { Id = id };

                var deleteQuery = "Update Student SET isDeleted = 1 where Student.Id = @id";

                var rowsAffected = db.Execute(deleteQuery, parameter);

                if (rowsAffected != 1)
                {
                    throw new Exception("We couldn't delete the student at this time");
                }
            }
        }

    }
}

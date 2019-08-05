using Dapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HalfTime.Models;
using System.Data.SqlClient;

namespace HalfTime.Data
{
    public class uniformsRepository
    {
        const string ConnectionString = "Server=localhost;Database=HalfTimeDB;Trusted_Connection=True;";

        public Uniform getUniform(int id)
        {
            var sql = "select Uniform.Id, Uniform.Size, Uniform.Condition, Uniform.StudentId from Uniform where Uniform.Id = @id";
            using (var db = new SqlConnection(ConnectionString))
            {
                var singleUniform = db.QueryFirstOrDefault<Uniform>(sql, new { id });
                return singleUniform;

            }
        }

        public IEnumerable<Uniform> getUserUniforms(int id)
        {
            var sql = "select Uniform.Id, Uniform.Size, Uniform.Condition, Uniform.StudentId from Uniform join UserUniformJoin on Uniform.Id = UserUniformJoin.UniformId join [User] u on UserUniformJoin.UserId = u.Id where u.Id = @id and Uniform.IsDeleted = 0 OR Uniform.IsDeleted IS NULL";
            using (var db = new SqlConnection(ConnectionString))
            {
                var uniforms = db.Query<Uniform>(sql, new { id }).ToList();
                return uniforms;
            }

        }

        public Uniform AddUniform(Uniform newUniformObj)
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var newUniform = db.QueryFirstOrDefault<Uniform>(@"
                    Insert into uniform(size, condition, studentid)
                    Output inserted.*
                    Values(@size, @condition, @studentid)",
                    new
                    {
                        newUniformObj.Size,
                        newUniformObj.Condition,
                        newUniformObj.StudentId,
                    });

                if (newUniform != null)
                {
                    return newUniform;
                }
            }

            throw new Exception("Unfortunatley, a new uniform was not created");
        }

        public void InsertUniformJoinTable()
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var uniformInsert = "INSERT INTO UserUniformJoin values ((SELECT U.Id FROM [User] U WHERE U.Id = 1),(Select TOP(1) Uniform.Id FROM Uniform ORDER BY Uniform.Id DESC))";

                var rowAffected = db.Execute(uniformInsert);
            }
        }

        public Uniform updateUniform(Uniform uniformToUpdate)
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var updateQuery = @"Update Uniform
                                    Set Size = @size,
                                    Condition = @condition,
                                    StudentId = @studentid
                                    Where Id = @id";

                var rowsAffected = db.Execute(updateQuery, uniformToUpdate);

                if (rowsAffected == 1)
                {
                    return uniformToUpdate;
                }
                throw new Exception("We could not update the uniform");
            }
        }

        public void DeleteUniform(int id)
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var parameter = new { Id = id };

                var deleteQuery = "Update Uniform SET isDeleted = 1 where Uniform.Id = @id";

                var rowsAffected = db.Execute(deleteQuery, parameter);

                if (rowsAffected != 1)
                {
                    throw new Exception("We couldn't delete the uniform at this time");
                }
            }
        }
    }
}

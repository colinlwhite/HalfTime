using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using HalfTime.Models;
using HalfTime.Data;

namespace HalfTime.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StudentsController : ControllerBase
    {
        readonly studentsRepository _studentsRepository;

        public StudentsController()
        {
            _studentsRepository = new studentsRepository();
        }

        // GET: api/Students/ID/2
        [HttpGet("ID/{id}")]
        public ActionResult GetStudentById(int id)
        {
            var oneStudent = _studentsRepository.getStudent(id);

            return Ok(oneStudent);
        }

        // GET: api/Students/5
        [HttpGet("{id}")]
        public ActionResult GetStudentsByUserId(int id)
        {
            var userStudents = _studentsRepository.getUserStudents(id);

            return Ok(userStudents);
        }

        // POST: api/Students
        [HttpPost]
        public ActionResult AddStudent(Student createStudent)
        {
             var newStudent = _studentsRepository.AddStudent(createStudent);

            _studentsRepository.InsertStudentJoinTable();

            return Created($"api/students/{newStudent.Id}", newStudent);
        }

        // PUT: api/Students/5
        [HttpPut("{id}")]
         public ActionResult updateStudent(int id, Student studentToUpdate)
        {
            if (id != studentToUpdate.Id)
            {
               return BadRequest(new { Error = "There was an error" });
            }
            var student = _studentsRepository.updateStudent(studentToUpdate);
            return Ok(student);
        }

        // DELETE: api/ApiWithActions/5
        [HttpPut("delete/{id}")]
        public ActionResult DeleteStudent(int id)
        {
            _studentsRepository.DeleteStudent(id);

            return Ok("The student was deleted");
        }
    }
}

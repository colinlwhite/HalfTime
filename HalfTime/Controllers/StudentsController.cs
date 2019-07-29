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

        // GET: api/Students/5
        [HttpGet("{id}")]
        public ActionResult GetStudentsByUserId(int id)
        {
            var userStudents = _studentsRepository.getUserStudents(id);

            return Ok(userStudents);
        }

        // POST: api/Students
        //[HttpPost]
        public ActionResult AddStudent(Student createStudent)
        {
             var newStudent = _studentsRepository.AddStudent(createStudent);

            return Created($"api/students/{newStudent.Id}", newStudent);
        }

        //// PUT: api/Instruments/5
        //[HttpPut("{id}")]
        //// public ActionResult updateInstrument(int id, Instrument instrumentToUpdate)
        //{
        //    if (id != instrumentToUpdate.Id)
        //    {
        //        return BadRequest(new { Error = "There was an error" });
        //    }
        //    //var instrument = _instrumentsRepository.updateInstrument(instrumentToUpdate);
        //    // return Ok(instrument);
        //}

        //// DELETE: api/ApiWithActions/5
        //[HttpDelete("{id}")]
        //public ActionResult DeleteInstrument(int id)
        //{
        //    //_instrumentsRepository.DeleteInstrument(id);

        //    return Ok("The instrument was deleted");
        //}
    }
}

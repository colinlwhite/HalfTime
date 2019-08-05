using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using HalfTime.Data;
using HalfTime.Models;

namespace HalfTime.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class VolunteersController : ControllerBase
    {
        readonly volunteersRepository _volunteersRepository;

        public VolunteersController()
        {
            _volunteersRepository = new volunteersRepository();
        }

        // GET: api/Volunteers/ID/2
        [HttpGet("ID/{id}")]
        public ActionResult GetEventById(int id)
        {
            var oneVolunteer = _volunteersRepository.getVolunteer(id);

            return Ok(oneVolunteer);
        }

        // GET: api/Volunteers/5
        [HttpGet("{id}")]
        public ActionResult GetVolunteersByUserId(int id)
        {
            var userVolunteers = _volunteersRepository.getUserVolunteers(id);

            return Ok(userVolunteers);
        }

        // POST: api/Volunteers
        [HttpPost]
        public ActionResult AddVolunteer(Volunteer createVolunteer)
        {
            var newVolunteer = _volunteersRepository.AddVolunteer(createVolunteer);

            _volunteersRepository.InsertVolunteerJoinTable();

            return Created($"api/volunteers/{newVolunteer.Id}", newVolunteer);
        }

        // PUT: api/Volunteers/5
        [HttpPut("{id}")]
        public ActionResult updateVolunteer(int id, Volunteer volunteerToUpdate)
        {
            if (id != volunteerToUpdate.Id)
            {
                return BadRequest(new { Error = "There was an error" });
            }
            var volunteer = _volunteersRepository.updateVolunteer(volunteerToUpdate);
            return Ok(volunteer);
        }

        // DELETE: api/ApiWithActions/5
        [HttpPut("delete/{id}")]
        public ActionResult DeleteVolunteer(int id)
        {
            _volunteersRepository.DeleteVolunteer(id);

            return Ok("The volunteer was deleted");
        }
    }
}

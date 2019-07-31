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
    public class EventsController : ControllerBase
    {
        readonly eventsRepository _eventsRepository;

        public EventsController(eventsRepository eventsRepository)
        {
            _eventsRepository = eventsRepository;
        }

        // GET: api/Events/ID/5
        [HttpGet("ID/{id}")]
        public ActionResult GetEventById(int id)
        {
            var oneEvent = _eventsRepository.getEvent(id);

            return Ok(oneEvent);
        }

        // GET: api/Events/5
        [HttpGet("{id}")]
        public ActionResult GetEventsByUserId(int id)
        {
            var userEvents = _eventsRepository.getUserEvents(id);

            return Ok(userEvents);
        }

        // POST: api/Events
        [HttpPost]
        public ActionResult AddEvent(Event createEvent)
        {
            var newEvent = _eventsRepository.AddEvent(createEvent);

            return Created($"api/events/{newEvent.Id}", newEvent);
        }

        // POST: api/Events/SMS
        [HttpPost("SMS")]
        public ActionResult SendTwilioSMS()
        {
            _eventsRepository.SendSMS();

            return Ok("The message was sent to your volunteers");
        }

        // PUT: api/Events/5
        [HttpPut("{id}")]
        public ActionResult updateEvent(int id, Event eventToUpdate)
        {
            if (id != eventToUpdate.Id)
            {
                return BadRequest(new { Error = "There was an error" });
            }
            var updatedEvent = _eventsRepository.updateEvent(eventToUpdate);
            return Ok(updatedEvent);
        }

        // DELETE: api/ApiWithActions/5
        [HttpDelete("{id}")]
        public ActionResult DeleteEvent(int id)
        {
            _eventsRepository.DeleteEvent(id);

            return Ok("The event was deleted");
        }
    }
}

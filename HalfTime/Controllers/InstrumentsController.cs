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
    public class InstrumentsController : ControllerBase
    {

        readonly instrumentsRepository _instrumentsRepository;

        public InstrumentsController()
        {
            _instrumentsRepository = new instrumentsRepository();
        }

        // GET: api/Instruments/ID/5
        [HttpGet("ID/{id}")]
        public ActionResult GetInstrumentById(int id)
        {
            var oneInstrument = _instrumentsRepository.getInstrument(id);

            return Ok(oneInstrument);
        }

        // GET: api/Instruments/5
        [HttpGet("{id}")]
        public ActionResult GetInstrumentsByUserId(int id)
        {
            var userInstruments = _instrumentsRepository.getUserInstruments(id);

            return Ok(userInstruments);
        }

        // POST: api/Instruments
        [HttpPost]
        public ActionResult AddInstrument(Instrument createInstrument)
        {
            var newInstrument = _instrumentsRepository.AddInstrument(createInstrument);

            _instrumentsRepository.InsertInstrumentJoinTable();

            return Created($"api/instruments/{newInstrument.Id}", newInstrument);
        }

        // PUT: api/Instruments/5
        [HttpPut("{id}")]
        public ActionResult updateInstrument(int id, Instrument instrumentToUpdate)
        {
            if (id != instrumentToUpdate.Id)
            {
                return BadRequest(new { Error = "There was an error" });
            }
            var instrument = _instrumentsRepository.updateInstrument(instrumentToUpdate);
            return Ok(instrument);
        }

        // DELETE: api/ApiWithActions/5
        [HttpPut("delete/{id}")]
        public ActionResult DeleteInstrument(int id)
        {
            _instrumentsRepository.DeleteInstrument(id);

            return Ok("The instrument was deleted");
        }
    }
}

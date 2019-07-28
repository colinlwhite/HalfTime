using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using HalfTime.Data;

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

        // GET: api/Instruments/5
        [HttpGet("{id}")]
        public ActionResult GetInstrumentsByUserId(int id)
        {
            var userInstruments = _instrumentsRepository.getUserInstruments(id);

            return Ok(userInstruments);
        }

        // POST: api/Instruments
        [HttpPost]
        public void Post([FromBody] string value)
        {
        }

        // PUT: api/Instruments/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE: api/ApiWithActions/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
    }
}

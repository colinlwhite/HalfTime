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
    public class UniformsController : ControllerBase
    {
        readonly uniformsRepository _uniformsRepository;

        public UniformsController()
        {
            _uniformsRepository = new uniformsRepository();
        }

        // GET: api/Uniforms/ID/2
        [HttpGet("ID/{id}")]
        public ActionResult GetUniformById(int id)
        {
            var oneUniform = _uniformsRepository.getUniform(id);

            return Ok(oneUniform);
        }

        // GET: api/Uniforms/5
        [HttpGet("{id}")]
        public ActionResult GetUniformsByUserId(int id)
        {
            var userUniforms = _uniformsRepository.getUserUniforms(id);

            return Ok(userUniforms);
        }

        // POST: api/Uniforms
        [HttpPost]
        public ActionResult AddUniform(Uniform createUniform)
        {
            var newUniform = _uniformsRepository.AddUniform(createUniform);

            return Created($"api/uniforms/{newUniform.Id}", newUniform);
        }

        // PUT: api/Uniforms/5
        [HttpPut("{id}")]
        public ActionResult updateUniform(int id, Uniform uniformToUpdate)
        {
            if (id != uniformToUpdate.Id)
            {
                return BadRequest(new { Error = "There was an error" });
            }
            var uniform = _uniformsRepository.updateUniform(uniformToUpdate);
            return Ok(uniform);
        }

        // DELETE: api/ApiWithActions/5
        [HttpDelete("{id}")]
        public ActionResult DeleteUniform(int id)
        {
            _uniformsRepository.DeleteUniform(id);

            return Ok("The uniform was deleted");
        }
    }
}

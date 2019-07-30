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
    public class UsersController : ControllerBase
    {
        readonly usersRepository _usersRepository;

        public UsersController()
        {
            _usersRepository = new usersRepository();
        }

        // GET: api/Users/5
        [HttpGet("{id}")]
        public ActionResult GetUsersByUserId(int id)
        {
            var userUsers = _usersRepository.getUser(id);

            return Ok(userUsers);
        }

        // POST: api/Users
        [HttpPost]
        public ActionResult AddUser(User createUser)
        {
            var newUser = _usersRepository.AddUser(createUser);

            return Created($"api/users/{newUser.Id}", newUser);
        }

        // PUT: api/Users/5
        [HttpPut("{id}")]
        public ActionResult updateUser(int id, User userToUpdate)
        {
            if (id != userToUpdate.Id)
            {
                return BadRequest(new { Error = "There was an error" });
            }
            var updatedUser = _usersRepository.updateUser(userToUpdate);
            return Ok(updatedUser);
        }

        // DELETE: api/ApiWithActions/5
        [HttpDelete("{id}")]
        public ActionResult DeleteUser(int id)
        {
            _usersRepository.DeleteUser(id);

            return Ok("The user was deleted");
        }
    }
}

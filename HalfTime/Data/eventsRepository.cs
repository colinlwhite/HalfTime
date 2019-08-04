using Dapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HalfTime.Models;
using System.Data.SqlClient;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Microsoft.Extensions.Configuration;

namespace HalfTime.Data
{
    public class eventsRepository
    {

        const string ConnectionString = "Server=localhost;Database=HalfTimeDB;Trusted_Connection=True;";

        private readonly IConfiguration _config;

        public eventsRepository(IConfiguration config)
        {
            _config = config;
        }

        public Event getEvent(int id)
        {
            var sql = "select E.Id, E.Name, E.Description, E.Type, E.Date, E.Street, E.City, E.State, E.ZipCode from Event E where E.Id = @id";
            using (var db = new SqlConnection(ConnectionString))
            {
                var singleEvent = db.QueryFirstOrDefault<Event>(sql, new { id });
                return singleEvent;

            }
        }

        public IEnumerable<Event> getUserEvents(int id)
        {
            var sql = "select Event.Id, Event.Name, Event.Description, Event.Type, Event.Date, Event.Street, Event.City, Event.State, Event.ZipCode from Event join UserEventJoin on Event.Id = UserEventJoin.EventId join [User] u on UserEventJoin.UserId = u.Id where u.Id = @id and Event.IsDeleted = 0 OR Event.IsDeleted IS NULL";
            using (var db = new SqlConnection(ConnectionString))
            {
                var events = db.Query<Event>(sql, new { id }).ToList();
                return events;
            }

        }

        public Event AddEvent(Event newEventObj)
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var newEvent = db.QueryFirstOrDefault<Event>(@"
                    Insert into event(name, description, type, date, street, city, state, zipcode)
                    Output inserted.*
                    Values(@name, @description, @type, @date, @street, @city, @state, @zipcode)",
                    new
                    {
                        newEventObj.Name,
                        newEventObj.Description,
                        newEventObj.Type,
                        newEventObj.Date,
                        newEventObj.Street,
                        newEventObj.City,
                        newEventObj.State,
                        newEventObj.ZipCode
                    });

                if (newEvent != null)
                {
                    return newEvent;
                }
            }

            throw new Exception("Unfortunatley, a new event was not created");
        }

        public void InsertEventJoinTable()
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var eventInsert = "INSERT INTO UserEventJoin values ((SELECT U.Id FROM [User] U WHERE U.Id = 1),(Select TOP(1) Event.Id FROM Event ORDER BY Event.Id DESC))";

                var rowAffected = db.Execute(eventInsert);
            }
        }
       

        public Event updateEvent(Event eventToUpdate)
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var updateQuery = @"Update Event
                                    Set Name = @name,
                                    Description = @description,
                                    Type = @type,
                                    Date = @date,
                                    Street = @street,
                                    City = @city,
                                    State = @state
                                    Where Id = @id";

                var rowsAffected = db.Execute(updateQuery, eventToUpdate);

                if (rowsAffected == 1)
                {
                    return eventToUpdate;
                }
                throw new Exception("We could not update the event");
            }
        }

        public void DeleteEvent(int id)
        {
            using (var db = new SqlConnection(ConnectionString))
            {
                var parameter = new { Id = id };

                var deleteQuery = "Update Event SET isDeleted = 1 where Event.Id = @id";

                var rowsAffected = db.Execute(deleteQuery, parameter);

                if (rowsAffected != 1)
                {
                    throw new Exception("We couldn't delete the event at this time");
                }
            }
        }

        public void SendSMS()
        {

            using (var db = new SqlConnection(ConnectionString))
            {
                var accountSid = _config.GetSection("TWILIO_ACCOUNT_SID").Value.Replace("\"","");
                var authToken = _config.GetSection("TWILIO_AUTH_TOKEN").Value.Replace("\"", "");

                TwilioClient.Init(accountSid, authToken);

                var currentEvent = db.QueryFirstOrDefault<Event>("Select TOP(1) E.Name, E.Date, E.City, E.State From Event E join UserEventJoin on E.Id = UserEventJoin.Id where UserEventJoin.UserId = 1 and E.Date > GETDATE() ORDER BY E.Date ASC");

                var currentEventTime = currentEvent.Date.ToString("MM/dd/yyyy HH:mm");

                List<string> numbersToMessage = db.Query<string>("select V.PhoneNumber from Volunteer V").ToList();

                foreach (var number in numbersToMessage)
                {
                    var message = MessageResource.Create(
                        body: $"Hey Band Boosters! To begin, thank you for your service so far this season. I just wanted to send a quick reminder about {currentEvent.Name} on {currentEventTime} in {currentEvent.City}, {currentEvent.State}. Please let me know if you have any questions!",
                        from: new Twilio.Types.PhoneNumber("+16152586798"),
                        to: new Twilio.Types.PhoneNumber(number)
                    );

                    Console.WriteLine($"Message to {number} has been {message.Status}.");
                }
            }
        }
    }
}


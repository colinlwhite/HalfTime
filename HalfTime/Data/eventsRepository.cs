using Dapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HalfTime.Models;
using System.Data.SqlClient;
using Twilio;
using Twilio.Rest.Api.V2010.Account;

namespace HalfTime.Data
{
    public class eventsRepository
    {

        const string ConnectionString = "Server=localhost;Database=HalfTimeDB;Trusted_Connection=True;";

        public IEnumerable<Event> getUserEvents(int id)
        {
            var sql = "select Event.Name, Event.Description, Event.Type, Event.Date, Event.Street, Event.City, Event.State, Event.ZipCode from Event join UserEventJoin on Event.Id = UserEventJoin.EventId join [User] u on UserEventJoin.UserId = u.Id where u.Id = @id";
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

                var deleteQuery = "Delete from Event where Id = @id";

                var rowsAffected = db.Execute(deleteQuery, parameter);

                if (rowsAffected != 1)
                {
                    throw new Exception("We couldn't delete the event at this time");
                }
            }
        }

        public void SendSMS()
        {
            // Find your Account Sid and Token at twilio.com/console
            // DANGER! This is insecure. See http://twil.io/secure
            const string accountSid = "ACf52182c66da8da1a8e1d6dee3ea528c7";
            const string authToken = "997563e65b993d1498bc5537a514a376";

            TwilioClient.Init(accountSid, authToken);

            var message = MessageResource.Create(
                body: "to succeed, you must study the endgame before everything else.",
                from: new Twilio.Types.PhoneNumber("+16152586798"),
                to: new Twilio.Types.PhoneNumber("+12052278229")
            );

            Console.WriteLine(message.Sid);
        }
    }
}

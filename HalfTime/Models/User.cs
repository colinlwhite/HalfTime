using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace HalfTime.Models
{
    public class User
    {
        public int Id { get; set; }
        public string FireBaseUid { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Street { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public int ZipCode { get; set; }
        public string PhoneNumber { get; set; }
    }
}

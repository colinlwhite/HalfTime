using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace HalfTime.Models
{
    public class Instrument
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Condition { get; set; }
        public string Category { get; set; }
        public int StudentId { get; set; }
        public string Description { get; set; }
        public string Brand { get; set; }
        public string ModelNumber { get; set; }

    }
}

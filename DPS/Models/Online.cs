using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DPS.Models
{
    public class Online
    {
        public int Id { get; set; }
        public string latitude { get; set; }
        public string longitude { get; set; }
        public DateTime datahora { get; set; }
        public string nome { get; set; }
        public Int64 cpf { get; set; }
    }
}
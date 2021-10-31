using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DPS.Models
{
    public class Cliente
    {
        public int Id { get; set; }
        public string latitude { get; set; }
        public string longitude { get; set; }
        public string nome { get; set; }
        public string telefone { get; set; }
    }
}
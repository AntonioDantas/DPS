using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data;
using System.Data;
using DPS.Classes;

namespace DPS.DAO
{
    public class Cliente
    {
        public IEnumerable<Models.Cliente> Get()
        {
            string comando = @"SELECT telefone_residencial, latitude, longitude, nome 
                                FROM clientes  ";
            DataTable data = Conexao.leitura(comando);

            try
            {
                IEnumerable<Models.Cliente> items = data.AsEnumerable().Select(row =>
                
                new Models.Cliente
                {
                    nome = row.Field<string>("nome"),
                    telefone = row.Field<string>("telefone_residencial"),
                    latitude = row["latitude"].ToString().Replace(",", "."),
                    longitude = row["longitude"].ToString().Replace(",", ".")
                }).ToList();
                return items;
            }
            catch {
                IEnumerable<Models.Cliente> items = data.AsEnumerable().Select(row =>

                new Models.Cliente
                {
                    nome = "",
                    telefone = "",
                    latitude = "",
                    longitude = ""
                }).ToList();
                return items;

            }

        }
    }
}
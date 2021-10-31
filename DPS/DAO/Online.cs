using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data;
using System.Data;
using DPS.Classes;

namespace DPS.DAO
{
    public class Online
    {
        //Traz somente os resultados da última hora
        public List<Models.Online> Get()
        {
            //string comando = @"SELECT distinct cpf FROM rondas 
            //                   INNER JOIN funcionarios ON rondas.cpf_ronda = funcionarios.cpf
            //                    --where datahora >= DATE_ADD(CURDATE(), INTERVAL '-1 1' DAY_HOUR);
            //                    ";
            string comando = @"SELECT distinct cpf FROM rondas 
                                INNER JOIN funcionarios ON rondas.cpf_ronda = funcionarios.cpf;
                                ";
            DataTable data = Conexao.leitura(comando);

            List<Models.Online> items = new List<Models.Online>();

            for (int i = 0; i < data.Rows.Count; i++)
            {
                comando = @"SELECT id, cpf, datahora, latitude, longitude, nome 
                                FROM rondas 
                                INNER JOIN funcionarios ON rondas.cpf_ronda = funcionarios.cpf
                                where cpf = '" + data.Rows[i]["cpf"].ToString() + @"'
                                order by datahora desc LIMIT 1";

                DataTable dataDados = Conexao.leitura(comando);

                try
                {
                    Models.Online item =
                    new Models.Online
                    {
                        Id = dataDados.Rows[0].Field<int>("id"),
                        nome = dataDados.Rows[0].Field<string>("nome"),
                        cpf = dataDados.Rows[0].Field<Int64>("cpf"),
                        datahora = dataDados.Rows[0].Field<DateTime>("datahora"),
                        latitude = dataDados.Rows[0]["latitude"].ToString().Replace(",","."),
                        longitude = dataDados.Rows[0]["longitude"].ToString().Replace(",", ".")
                    };

                    items.Add(item);
                }
                catch (Exception e) {
                    string erro = e.Message;
                }
            }

            return items;
        }

        public IEnumerable<Models.Online> GetCompleto(string cpf, string dia)
        {
            string comando = @"SELECT id, cpf, datahora, latitude, longitude, nome 
                                FROM rondas 
                                INNER JOIN funcionarios ON rondas.cpf_ronda = funcionarios.cpf
                                where cpf = '"+cpf.Replace(".","").Replace("-","")+ @"' 
                                and date(datahora) > '" + dia + " 00:00:00'";
            DataTable dt = Conexao.leitura(comando);

            IEnumerable<Models.Online> items = dt.AsEnumerable().Select(row =>
            new Models.Online
            {
                latitude = row["latitude"].ToString().Replace(",", "."),
                longitude = row["longitude"].ToString().Replace(",", ".")
            }).ToList();

            return items;
        }

        public IEnumerable<Models.Online> GetRota(string cpf)
        {
            string comando = @"SELECT cpf_func, lat, lng
                                FROM planejamento
                                where cpf_func = '" + cpf.Replace(".", "").Replace("-", "") + @"'";
            DataTable dt = Conexao.leitura(comando);

            IEnumerable<Models.Online> items = dt.AsEnumerable().Select(row =>
            new Models.Online
            {
                latitude = row["lat"].ToString().Replace(",", "."),
                longitude = row["lng"].ToString().Replace(",", ".")
            }).ToList();

            return items;
        }
    }
}
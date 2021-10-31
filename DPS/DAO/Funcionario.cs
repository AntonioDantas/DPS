using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data;
using System.Data;
using DPS.Classes;

namespace DPS.DAO
{
    public class Funcionario
    {
        public IEnumerable<Models.Funcionario> Login(string cpf, string senha)
        {
            string comando = @"SELECT cpf, nome 
                                FROM funcionarios where cpf = '"+cpf.Replace(".","").Replace("-","")+"' and senha='"+senha+"'";
            DataTable data = Conexao.leitura(comando);
            IEnumerable<Models.Funcionario> items = null;

            try
            {
                items = data.AsEnumerable().Select(row =>
                new Models.Funcionario
                {
                    nome = row["nome"].ToString(),
                    cpf = row["cpf"].ToString()
                }).ToList();
                return items;
            }
            catch
            {
                return items;
            }

        }

        public bool GravarLocalizacao(string cpf, string lat, string lng)
        {

            try
            {
                string comando = @"insert into rondas (cpf_ronda,datahora,latitude,longitude) values('"+cpf+"','"+DateTime.Now.ToString("yyyy-MM-dd")+"','"+lat.Replace(",",".")+"','"+lng.Replace(",", ".") + "')";
                Conexao.escrita(comando);
                return true;
            }
            catch
            {
                return false;
            }

        }
    }
}
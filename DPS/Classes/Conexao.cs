using DPS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Net.NetworkInformation;
using System.Security.Cryptography;
using System.Text;
using MySql;

namespace DPS.Classes
{
    public class Conexao
    {
        //private static string local = "server=localhost;database=dps;user id=root;persistsecurityinfo=False;Integrated Security=False; Pwd=root;";
        private static string local = "server=dps_ufscar.mysql.dbaas.com.br;database=dps_ufscar;user id=dps_ufscar;persistsecurityinfo=False;Integrated Security=False; Pwd=dps_ufscar;";

        /// <summary>
        /// Realiza uma leitura no BD e armazena em um DataTeable.
        /// </summary>
        /// <param name="sql">
        /// Instrução SQL(MySQL)
        /// </param>
        /// <returns>
        /// Se vazio um DataTable sem linhas
        /// </returns>
        public static DataTable leitura(string sql)
        {
            MySql.Data.MySqlClient.MySqlConnection conexao = new MySql.Data.MySqlClient.MySqlConnection(local);
            MySql.Data.MySqlClient.MySqlCommand com = new MySql.Data.MySqlClient.MySqlCommand(sql, conexao);
            MySql.Data.MySqlClient.MySqlDataReader data = null;
            DataTable tabela = new DataTable();
            
            try
            {
                conexao.Open();
                data = com.ExecuteReader();
                tabela.Load(data);
            }
            finally
            {
                conexao.Close();
            }
            return tabela;
        }

        /// <summary>
        /// Realiza um comando no BD.
        /// </summary>
        /// <param name="sql">
        /// Instrução SQL(MySQL)
        /// </param>
        /// <returns>
        /// Sem retorno
        /// </returns>
        public static void escrita(string sql)
        {
            MySql.Data.MySqlClient.MySqlConnection conexao = new MySql.Data.MySqlClient.MySqlConnection(local);
            MySql.Data.MySqlClient.MySqlCommand com = new MySql.Data.MySqlClient.MySqlCommand(sql, conexao);
            
            try
            {
                conexao.Open();
                com.ExecuteNonQuery();
            }
            finally
            {
                conexao.Close();
            }
        }
    }
}
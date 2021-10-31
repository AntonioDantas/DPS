using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DPS.Classes
{
    public class Auditoria
    {
        /// <summary>
        /// Gravar Auditoria no BD.
        /// </summary>
        /// <param name="acao">
        /// case 1: "Entrou na Página ";
        /// case 2: "Cadastrou na Página ";
        /// case 3: "Editou na Página ";
        /// case 4: "Deletou na Página ";
        /// case 5: "Consultou na Página ";
        /// </param>
        /// <returns>
        /// Sem retorno.
        /// </returns>
        public static void gravar(string cpf, string descricao, int acao)
        {
            string descricaoAcao = "";
            switch(acao)
            {
                case 1:
                    descricaoAcao = "Entrou na Página ";
                    break;
                case 2:
                    descricaoAcao = "Cadastrou na Página ";
                    break;
                case 3:
                    descricaoAcao = "Editou na Página ";
                    break;
                case 4:
                    descricaoAcao = "Deletou na Página ";
                    break;
                case 5:
                    descricaoAcao = "Consultou na Página ";
                    break;
                default:
                    descricaoAcao = "";
                    break;
            }

            string sql_auditoria = string.Format(@"INSERT INTO auditoria (cpf_auditoria, descricao, data, hora)
            VALUES ('{0}','{1}','{2}','{3}')", cpf, descricaoAcao + descricao, DateTime.Now.ToString("yyyy-MM-dd"), DateTime.Now.ToLongTimeString());
            Conexao.escrita(sql_auditoria);
        }
    }
}
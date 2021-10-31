using System.Data;

namespace DPS.Classes
{
    public class Endereco
    {
        public string Cep { get; set; }
        public string logradouro { get; set; }
        public string tipo_logradouro { get; set; }
        public string bairro { get; set; }
        public string cidade { get; set; }
        public string uf { get; set; }
        
        /// <summary>
        /// Recupera do site dos correios os dados de endereço a partir de um CEP
        /// </summary>
        /// <param name="cep">
        /// CEP no formato 99.999-999
        /// </param>
        /// <returns>
        /// Objeto do tipo Endereco ou nulo se não encontrado
        /// </returns>
        public Endereco GetByCEP(string cep)
        {
            var end = new Endereco();
            // Objeto DataSet que receberá a tabela em XML que contém os dados da pesquisa
            DataSet ds = new DataSet();
            // Armazena o arquivo XML retirado da página onde o CEP foi pesquisado
            ds.ReadXml("http://cep.republicavirtual.com.br/web_cep.php?cep=" + cep);

            // Caso tenha encontrado o CEP o valor da primeira célula da primeira linha da tabela será 1 
            if (ds.Tables[0].Rows[0][0].ToString() == "1")
            {
                // Repassa os valores contidos nas células da primeira linha para suas
                // respectivas TextBox'es, para serem exibidos para o usuário
                end.uf = ds.Tables[0].Rows[0]["uf"].ToString().Trim();
                end.cidade = ds.Tables[0].Rows[0]["cidade"].ToString().Trim();
                end.bairro = ds.Tables[0].Rows[0]["bairro"].ToString().Trim();
                end.tipo_logradouro =
                    ds.Tables[0].Rows[0]["tipo_logradouro"].ToString().Trim();
                end.logradouro = ds.Tables[0].Rows[0]["logradouro"].ToString().Trim();
                end.Cep = cep;
                return end;
            }
            else
            {
                return null;
            }
        }
    }
}
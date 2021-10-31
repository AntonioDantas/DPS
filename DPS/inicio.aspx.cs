using DPS.Classes;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DPS
{
    public partial class inicio : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!((bool)Session["Autenticado"]))
                {
                    Response.Redirect("Login.aspx");
                }
            }
            catch
            {
                Response.Redirect("Login.aspx");
            }


            Classes.Auditoria.gravar(Session["cpf"].ToString(), " Principal ", 1);
        }

        protected void timer_Tick(object sender, EventArgs e)
        {
            return;

            string comando = @"SELECT o.id,f.nome as nome_funcionario,c.endereco, c.nome as nome_cliente,o.datahora,o.historico 
                                FROM ocorrencias o
                                left join funcionarios f on o.cpf_funcionario = f.cpf 
                                inner join clientes c on o.cpf_cliente = c.cpf 
                                WHERE datahora > '" + DateTime.Now.AddMinutes(-30).ToString("yyyy-MM-dd HH:mm:ss") + "' and f.nome is null  order by datahora desc ";

            DataTable emergencia = Conexao.leitura(comando);
            if (emergencia.Rows.Count > 1)
            {
                divalerta.Visible = true;
                lblnome.Text = emergencia.Rows[0]["nome_cliente"].ToString();
                lblendereco.Text = emergencia.Rows[0]["endereco"].ToString();
                Session["idOcorrencia"] = emergencia.Rows[0]["id"].ToString();
                
                Response.Write(@"
                        <script>
                                event.preventDefault();
                                var endereco = document.getElementById('lblendereco').value;

                                geocoder = new google.maps.Geocoder();
                                    geocoder.geocode({ 'address': endereco }, function(results, status) {
                                        if (status = google.maps.GeocoderStatus.OK)
                                        {
                                            myLatlng = results[0].geometry.location;
                                            try
                                            {
                                                map.setCenter(myLatlng);
                                            }
                                            catch (err)
                                            {

                                            }
                                        }
                                    });
                    </script>
                ");
            }


        }

        protected void btnExibir_Click(object sender, EventArgs e)
        {
            Response.Redirect("ocorrencias.aspx?tipo=EDITAR&id=" + Session["idOcorrencia"].ToString());
        }
    }
}
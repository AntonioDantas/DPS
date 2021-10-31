using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DPS.Controllers;

namespace DPS
{
    public partial class Online : System.Web.UI.Page
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


            Classes.Auditoria.gravar(Session["cpf"].ToString(), " do Online ", 1);
        }
    }
}
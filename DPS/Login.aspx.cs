using DPS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Net.NetworkInformation;
using System.Text;
using DPS.Classes;
using System.Windows.Forms;

namespace DPS
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["Autenticado"] = false;
                Limpar();
                GerPainels(1);
            }
        }

        
        private void Limpar()
        {
            txtCpf.Text =
            txtEsqueceuEmail.Text =
            txtSenha.Text = string.Empty;
            txtCpf.Focus();
        }

        protected void lnkEsqueceuSenha_Click(object sender, EventArgs e)
        {
            GerPainels(2);
            txtEsqueceuEmail.Text = string.Empty;
        }

        private void GerPainels(int Painel)
        {
            sgclogin.Visible = Painel.Equals(1);
            sgcEsqueceu.Visible = Painel.Equals(2);
        }

        protected void lnkConfirmarEsqueceu_Click(object sender, EventArgs e)
        {
            string comando = @"SELECT * FROM `funcionarios` WHERE email = '" + txtEsqueceuEmail.Text + @"' and ativo=1";
            DataTable data = Conexao.leitura(comando);

            if (data.Rows.Count > 0)
            {
                string novasenha = Senha.gerarSenha();
                comando = @"UPDATE `Funcionarios` set senha = '" + Senha.CalculateMD5Hash(novasenha) + @"' where cpf = '"+data.Rows[0]["cpf"].ToString() +"'";
                Conexao.escrita(comando);

                string mensagem = @" Uma nova senha foi gerada para seu acesso:<br />
                                        senha: " + novasenha + @" guarde em segurança.<br />
                                            Caso você não tenha solicitado favor entra em contato!";

                Email.enviaEmail(txtEsqueceuEmail.Text, "Nova Senha Gerada", mensagem);

                MessageBox.Show("Email enviado com nova senha!");
            }
            else
            {
                MessageBox.Show("Email não encontrado!");
            }
        }

        protected void lnkAcessar_Click(object sender, EventArgs e)
        {
            lblMensagem.Visible = false;
            
            //VERIFICANDO O CPF
            if (!Validacao.validaCPF(txtCpf.Text))
            {
                lblMensagem.CssClass = "mensagem label label-danger";
                lblMensagem.Text = "Este CPF é inválido";
                lblMensagem.Visible = true;
                Limpar();
                return;
            }
            else
            {
                string sHashConf = Senha.CalculateMD5Hash(txtSenha.Text);
                string cpf = txtCpf.Text.Trim().Replace(".", "").Replace("-", "");
                string comando = @"SELECT * FROM `funcionarios` WHERE cpf = '" + cpf + "' AND senha = '" + sHashConf + @"' and ativo=1";
                DataTable data = Conexao.leitura(comando);               

                if (data.Rows.Count > 0)
                {
                    Response.Cookies["Verifica"]["logado"] = "sim";
                    Response.Cookies["Verifica"].Expires = DateTime.Now.AddHours(1);
                    Session["Autenticado"] = true;
                    Session["cpf"] = txtCpf.Text;
                    Response.Redirect("inicio.aspx");
                }
                else
                {
                    lblMensagem.CssClass = "mensagem label label-alert";
                    lblMensagem.Text = "Usuário ou Senha incorretas";
                    Limpar();
                    return;
                }
                
            }
        }
    }
}
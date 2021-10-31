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
using DPS.Classes;
using System.Windows.Forms;
using System.IO;
using System.Configuration;
using iTextSharp.text;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text.pdf;
using System.Web.UI.WebControls;
using System.Drawing;

namespace DPS
{
    public partial class cadastro_rondas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //Session["cpf"] = 36471042809;
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


            Classes.Auditoria.gravar(Session["cpf"].ToString(), " planejamentos ", 1);

            if (!IsPostBack)
            {

                
                limparTela();

                string tipo = Request.QueryString["tipo"];
                tipo = tipo == null ? "CONSULTA" : tipo;
                Session["tipoAcao"] = tipo;
                if (tipo.Equals("EDITAR"))
                {
                    divconsulta.Visible = false;
                    divalteracao.Visible = true;

                    Session["cpffunc"] = Request.QueryString["cpf"];

                    string comando = @"SELECT * FROM planejamento WHERE cpf_func = '" + Session["cpffunc"].ToString() + "'";
                    DataTable data = Conexao.leitura(comando);
                    //Pessoal
                    txtCPF.Text = data.Rows[0]["cpf_func"].ToString();
                    txtNomeBuscar.Text = "";
                    txtCPF.Enabled = false;
                    lnkBuscar.Visible = false;
                    txtLat.Text = "";
                    txtLng.Text = "";
                    ddlPosicoes.Items.Clear();
                    for (int i = 0; i < data.Rows.Count; i++)
                    {
                        string valor = data.Rows[i]["lat"].ToString() + " " + data.Rows[i]["lng"].ToString();
                        ddlPosicoes.Items.Add(new System.Web.UI.WebControls.ListItem(valor, valor));
                    }
                    
                }
                else
                {
                    if (tipo.Equals("INCLUIR"))
                    {
                        divconsulta.Visible = false;
                        divalteracao.Visible = true;
                    }
                    else
                    {
                        divconsulta.Visible = true;
                        divalteracao.Visible = false;
                    }
                }
            }
        }

        protected void limparTela()
        {

            txtCPF.Text = "";
            lnkBuscar.Visible = true;
            txtNomeBuscar.Text = "";
            gridBuscaFunc.DataSource = null;
            gridBuscaFunc.DataBind();
            txtLng.Text = "";
            txtLat.Text = "";
            ddlPosicoes.Items.Clear();
        }

        protected void lnkBtnPesquisar_Click(object sender, EventArgs e)
        {
            string filtro = "";

            if (!txtFiltroNome.Text.Equals(""))
            {
                filtro += " and nome like '%" + txtFiltroNome.Text + "%'";
                Classes.Auditoria.gravar(Session["cpf"].ToString(), " Funcionário com filtro nome: " + txtFiltroNome.Text, 5);
            }

            string comando = @"SELECT count(*) as pontos,nome,cpf FROM planejamento p inner join funcionarios f on p.cpf_func = f.cpf WHERE ativo = 1 " + filtro + " group by cpf, nome";
            DataTable planejamentos = Conexao.leitura(comando);

            Session["Listaplanejamentos"] = planejamentos;
            lblTotalResultados.Visible = true;

            if (planejamentos.Rows.Count > 0)
            {
                lblTotalResultados.Text = planejamentos.Rows.Count + " Resultados";
                lnkBtnRelatorio.Enabled = true;
            }
            else
            {
                lblTotalResultados.Text = "Sem Resultados";
                lnkBtnRelatorio.Enabled = false;
            }

            Classes.Auditoria.gravar(Session["cpf"].ToString(), " Funcionário com resultado: " + lblTotalResultados.Text, 5);
            grid.DataSource = planejamentos;
            grid.DataBind();

        }

        protected void lnkBtnCadastrar_Click(object sender, EventArgs e)
        {
            Response.Redirect("cadastro-rondas.aspx?tipo=INCLUIR");
        }



        protected void linkExcluirFuncionárioVoltar_Click(object sender, EventArgs e)
        {
            divExcluir.Visible = false;
            genCortina.Visible = false;
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Response.Redirect("cadastro-rondas.aspx?tipo=CONSULTAR");
        }

        protected void btnSalvar_Click1(object sender, EventArgs e)
        {
            string cpf = txtCPF.Text.Replace(".", "").Replace("/", "").Replace("-", "");

            if (!Validacao.validaCPF(cpf))
            {
                MessageBox.Show("O CPF é Inválido!");
                return;
            }

            if (ddlPosicoes.Items.Count < 3)
            {
                MessageBox.Show("Devem ser cadastrados ao menos 3 posições!");
                return;
            }

            string comando = "delete from planejamento where cpf_func = '" + txtCPF.Text + "'";
                Conexao.escrita(comando);

                Classes.Auditoria.gravar(Session["cpf"].ToString(), " Planejamento de Funcionário de CPF: " + txtCPF.Text, 3);
            
            try
            {
                for (int i = 0; i < ddlPosicoes.Items.Count; i++)
                {
                    comando = @"insert into planejamento (cpf_func, lat, lng) values ('{0}','{1}','{2}')";
                    comando = string.Format(comando,
                                                cpf,
                                                ddlPosicoes.Items[i].Value.Split(' ')[0],
                                                ddlPosicoes.Items[i].Value.Split(' ')[1]);

                    Conexao.escrita(comando);
                }


            }
            catch
            {
                MessageBox.Show("Planejamento Não Cadastrado Favor Verificar os dados!");
                return;
            }


            Classes.Auditoria.gravar(Session["cpf"].ToString(), " Planejamento Funcionário de CPF: " + txtCPF.Text, 2);

            MessageBox.Show("Realizado Com Sucesso!");
            Response.Redirect("cadastro-rondas.aspx?tipo=CONSULTAR");

        }

        public override void VerifyRenderingInServerForm(System.Web.UI.Control control)
        {
            /* Confirms that an HtmlForm control is rendered for the
            /* specified ASP.NET server control at run time. */
        }
        
        protected void grid_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument);
            DataTable planejamentos = (DataTable)Session["Listaplanejamentos"];

            if (e.CommandName == "Excluir")
            {
                divExcluir.Visible = true;
                genCortina.Visible = true;
                lblExcluir.Text = planejamentos.Rows[index]["nome"].ToString();
                lblCpf.Text = planejamentos.Rows[index]["cpf"].ToString();
            }
            else
            {
                Session["cpffunc"] = planejamentos.Rows[index]["cpf"].ToString();
                Response.Redirect("cadastro-rondas.aspx?tipo=EDITAR&cpf=" + Session["cpffunc"].ToString());
            }
        }

        protected void linkExcluirConfirme_Click(object sender, EventArgs e)
        {
            string comando = "delete from planejamento where cpf_func = '" + lblCpf.Text + "'";
            Conexao.escrita(comando);

            divExcluir.Visible = false;
            genCortina.Visible = false;
            MessageBox.Show("Excluído com Sucesso!");
            lnkBtnPesquisar_Click(null, null);


            Classes.Auditoria.gravar(Session["cpf"].ToString(), " Funcionário de CPF: " + lblCpf.Text, 4);


        }
        
        protected void gridBuscaFunc_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "selecionar")
            {
                txtCPF.Text = gridBuscaFunc.Rows[index].Cells[0].Text;
                gridBuscaFunc.DataSource = null;
                gridBuscaFunc.DataBind();
            }
        }

        protected void lnkInsere_Click(object sender, EventArgs e)
        {
            try
            {
                Convert.ToDouble(txtLat.Text);
                Convert.ToDouble(txtLng.Text);

                ddlPosicoes.Items.Add(txtLat.Text + " " + txtLng.Text);
                txtLat.Text = "";
                txtLng.Text = "";
            }
            catch
            {

            }
        }

        protected void lnkRemove_Click(object sender, EventArgs e)
        {
            if(ddlPosicoes.Items.Count > 0)
                ddlPosicoes.Items.RemoveAt(ddlPosicoes.SelectedIndex);
        }

        protected void lnkBuscar_Click(object sender, EventArgs e)
        {
            string filtro = "";

            if (!txtNomeBuscar.Text.Equals(""))
            {
                filtro += " and nome like '%" + txtNomeBuscar.Text + "%'";
                Classes.Auditoria.gravar(Session["cpf"].ToString(), " Funcionario com filtro nome: " + txtNomeBuscar.Text, 5);
            }

            string comando = @"SELECT nome,cpf FROM funcionarios WHERE ativo = 1 " + filtro;
            DataTable funcionarios = Conexao.leitura(comando);

            if (funcionarios.Rows.Count > 0)
            {
                lnkBtnRelatorio.Enabled = true;
                lblTotalResultados.Text = funcionarios.Rows.Count + " Resultados";
            }
            else
            {
                lnkBtnRelatorio.Enabled = false;
                lblTotalResultados.Text = "Sem Resultados";
            }

            gridBuscaFunc.DataSource = funcionarios;
            gridBuscaFunc.DataBind();
        }

        protected void lnkBtnRelatorio_Click(object sender, EventArgs e)
        {

            try
            {
                int noOfColumns = 0, noOfRows = 0;
                DataTable tbl = null;

                if (grid.AutoGenerateColumns)
                {
                    tbl = grid.DataSource as DataTable; // Gets the DataSource of the GridView Control.
                    noOfColumns = tbl.Columns.Count;
                    noOfRows = tbl.Rows.Count;
                }
                else
                {
                    noOfColumns = grid.Columns.Count - 2;
                    noOfRows = grid.Rows.Count;
                }



                float HeaderTextSize = 8;
                float ReportNameSize = 10;
                float ReportTextSize = 8;
                float ApplicationNameSize = 7;

                // Creates a PDF document

                Document document = null;

                document = new Document(PageSize.A4, 0, 0, 15, 5);


                // Creates a PdfPTable with column count of the table equal to no of columns of the gridview or gridview datasource.
                iTextSharp.text.pdf.PdfPTable mainTable = new iTextSharp.text.pdf.PdfPTable(noOfColumns);

                // Sets the first 4 rows of the table as the header rows which will be repeated in all the pages.
                mainTable.HeaderRows = 4;

                // Creates a PdfPTable with 2 columns to hold the header in the exported PDF.
                iTextSharp.text.pdf.PdfPTable headerTable = new iTextSharp.text.pdf.PdfPTable(2);

                // Creates a phrase to hold the application name at the left hand side of the header.
                Phrase phApplicationName = new Phrase("Cadastro de Rondas", FontFactory.GetFont("Arial", ApplicationNameSize, iTextSharp.text.Font.NORMAL));

                // Creates a PdfPCell which accepts a phrase as a parameter.
                PdfPCell clApplicationName = new PdfPCell(phApplicationName);
                // Sets the border of the cell to zero.
                clApplicationName.Border = PdfPCell.NO_BORDER;
                // Sets the Horizontal Alignment of the PdfPCell to left.
                clApplicationName.HorizontalAlignment = Element.ALIGN_LEFT;

                // Creates a phrase to show the current date at the right hand side of the header.
                Phrase phDate = new Phrase(DateTime.Now.Date.ToString("ddMMyyyy"), FontFactory.GetFont("Arial", ApplicationNameSize, iTextSharp.text.Font.NORMAL));

                // Creates a PdfPCell which accepts the date phrase as a parameter.
                PdfPCell clDate = new PdfPCell(phDate);
                // Sets the Horizontal Alignment of the PdfPCell to right.
                clDate.HorizontalAlignment = Element.ALIGN_RIGHT;
                // Sets the border of the cell to zero.
                clDate.Border = PdfPCell.NO_BORDER;

                // Adds the cell which holds the application name to the headerTable.
                headerTable.AddCell(clApplicationName);
                // Adds the cell which holds the date to the headerTable.
                headerTable.AddCell(clDate);
                // Sets the border of the headerTable to zero.
                headerTable.DefaultCell.Border = PdfPCell.NO_BORDER;

                // Creates a PdfPCell that accepts the headerTable as a parameter and then adds that cell to the main PdfPTable.
                PdfPCell cellHeader = new PdfPCell(headerTable);
                cellHeader.Border = PdfPCell.NO_BORDER;
                // Sets the column span of the header cell to noOfColumns.
                cellHeader.Colspan = noOfColumns;
                // Adds the above header cell to the table.
                mainTable.AddCell(cellHeader);

                // Creates a phrase which holds the file name.
                Phrase phHeader = new Phrase("Rondas Cadastrados", FontFactory.GetFont("Arial", ReportNameSize, iTextSharp.text.Font.BOLD));
                PdfPCell clHeader = new PdfPCell(phHeader);
                clHeader.Colspan = noOfColumns;
                clHeader.Border = PdfPCell.NO_BORDER;
                clHeader.HorizontalAlignment = Element.ALIGN_CENTER;
                mainTable.AddCell(clHeader);

                // Creates a phrase for a new line.
                Phrase phSpace = new Phrase("\n");
                PdfPCell clSpace = new PdfPCell(phSpace);
                clSpace.Border = PdfPCell.NO_BORDER;
                clSpace.Colspan = noOfColumns;
                mainTable.AddCell(clSpace);

                // Sets the gridview column names as table headers.
                for (int i = 0; i < noOfColumns; i++)
                {
                    Phrase ph = null;

                    if (grid.AutoGenerateColumns)
                    {
                        ph = new Phrase(tbl.Columns[i].ColumnName, FontFactory.GetFont("Arial", HeaderTextSize, iTextSharp.text.Font.BOLD));
                    }
                    else
                    {
                        ph = new Phrase(grid.Columns[i].HeaderText, FontFactory.GetFont("Arial", HeaderTextSize, iTextSharp.text.Font.BOLD));
                    }

                    mainTable.AddCell(ph);
                }

                // Reads the gridview rows and adds them to the mainTable
                for (int rowNo = 0; rowNo < noOfRows; rowNo++)
                {
                    for (int columnNo = 0; columnNo < noOfColumns; columnNo++)
                    {
                        if (grid.AutoGenerateColumns)
                        {
                            string s = grid.Rows[rowNo].Cells[columnNo].Text.Trim();
                            if (s.Equals("&nbsp;"))
                                s = "";
                            Phrase ph = new Phrase(s, FontFactory.GetFont("Arial", ReportTextSize, iTextSharp.text.Font.NORMAL));
                            mainTable.AddCell(ph);
                        }
                        else
                        {
                            if (grid.Columns[columnNo] is TemplateField)
                            {
                                DataBoundLiteralControl lc = grid.Rows[rowNo].Cells[columnNo].Controls[0] as DataBoundLiteralControl;
                                string s = lc.Text.Trim();
                                if (s.Equals("&nbsp;"))
                                    s = "";
                                Phrase ph = new Phrase(s, FontFactory.GetFont("Arial", ReportTextSize, iTextSharp.text.Font.NORMAL));
                                mainTable.AddCell(ph);
                            }
                            else
                            {
                                string s = grid.Rows[rowNo].Cells[columnNo].Text.Trim();
                                if (s.Equals("&nbsp;"))
                                    s = "";
                                Phrase ph = new Phrase(s, FontFactory.GetFont("Arial", ReportTextSize, iTextSharp.text.Font.NORMAL));
                                mainTable.AddCell(ph);
                            }
                        }
                    }

                    // Tells the mainTable to complete the row even if any cell is left incomplete.
                    mainTable.CompleteRow();
                }

                // Gets the instance of the document created and writes it to the output stream of the Response object.
                PdfWriter.GetInstance(document, Response.OutputStream);

                //// Creates a footer for the PDF document.
                //HeaderFooter pdfFooter = new HeaderFooter(new Phrase(), true);
                //pdfFooter.Alignment = Element.ALIGN_CENTER;
                //pdfFooter.Border = iTextSharp.text.Rectangle.NO_BORDER;

                //// Sets the document footer to pdfFooter.
                //document.Footer = pdfFooter;
                // Opens the document.
                document.Open();
                // Adds the mainTable to the document.
                document.Add(mainTable);
                // Closes the document.
                document.Close();

                Response.ContentType = "application/pdf";
                Response.AddHeader("content-disposition", "attachment; filename=Relatorio de Rondas de " + DateTime.Now.ToString("yyyyMMdd") + ".pdf");
                Response.End();
            }
            catch { }
        }
    }
}
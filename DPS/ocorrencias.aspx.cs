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
    public partial class ocorrencias : System.Web.UI.Page
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
                    timer1.Enabled = false;

                    Session["idOcorrencia"] = Request.QueryString["id"];

                    string comando = @"SELECT * FROM ocorrencias WHERE id = '" + Session["idOcorrencia"].ToString() + "'";
                    DataTable data = Conexao.leitura(comando);
                    //Pessoal
                    txtCPFFunc.Text = data.Rows[0]["cpf_funcionario"].ToString();
                    txtCPFCliente.Text = data.Rows[0]["cpf_cliente"].ToString();
                    txtHistórico.Text = data.Rows[0]["historico"].ToString();
                    txtLat.Text = data.Rows[0]["latitude"].ToString();
                    txtLng.Text = data.Rows[0]["longitude"].ToString();

                    
                }
                else
                {
                    if (tipo.Equals("INCLUIR"))
                    {
                        timer1.Enabled = false;
                        divconsulta.Visible = false;
                        divalteracao.Visible = true;
                    }
                    else
                    {
                        timer1.Enabled = true;
                        divconsulta.Visible = true;
                        divalteracao.Visible = false;
                        lnkBtnPesquisar_Click(null, null);
                    }
                }
            }
        }

        protected void limparTela()
        {
            timer1.Enabled = true;
            txtCPFFunc.Text = "";
            txtCPFCliente.Text = "";
            lnkBuscarFunc.Visible = true;
            lnkBuscaCliente.Visible = true;
            txtNomeBuscarFunc.Text = "";
            txtNomeCliente.Text = "";
            gridBuscaFunc.DataSource = null;
            gridBuscaFunc.DataBind();
            grdBuscaCliente.DataSource = null;
            grdBuscaCliente.DataBind();
            txtLng.Text = "";
            txtLat.Text = "";
            txtHistórico.Text = "";
        }

        protected void lnkBtnPesquisar_Click(object sender, EventArgs e)
        {
            string filtro = "";
            
            if (!txtFiltroNomeCliente.Text.Equals(""))
            {
                filtro += " and c.nome like '%" + txtFiltroNomeCliente.Text + "%'";
                Classes.Auditoria.gravar(Session["cpf"].ToString(), " Ocorrencia com filtro cliente nome: " + txtFiltroNomeCliente.Text, 5);
            }
            
            if (!txtFiltroNomeFuncionario.Text.Equals(""))
            {
                filtro += " and f.nome like '%" + txtFiltroNomeFuncionario.Text + "%'";
                Classes.Auditoria.gravar(Session["cpf"].ToString(), " Ocorrencia com filtro funcionario nome: " + txtFiltroNomeFuncionario.Text, 5);
            }

            if (!txtFiltroData.Text.Equals(""))
            {
                try
                {
                    DateTime dt = Convert.ToDateTime(txtFiltroData.Text);
                    filtro += " and o.datahora >= '" + dt.ToString("yyyy-MM-dd 00:00:00")+ "'";
                }
                catch
                {
                    MessageBox.Show("Data Inválida!");
                    return;
                }
            }
            else
            {
                filtro += " and o.datahora > '" + DateTime.Now.AddDays(-3).ToString("yyyy-MM-dd") + "'";
            }

                string comando = @"SELECT o.id,f.nome as nome_funcionario,c.nome as nome_cliente,o.datahora,o.historico 
                                FROM ocorrencias o
                                left join funcionarios f on o.cpf_funcionario = f.cpf 
                                inner join clientes c on o.cpf_cliente = c.cpf 
                                WHERE (1=1) " + filtro + " order by datahora desc ";

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

            Session["qtdSemAtendimento"] = 0;
            Classes.Auditoria.gravar(Session["cpf"].ToString(), " Ocorrências com resultado: " + lblTotalResultados.Text, 5);
            grid.DataSource = planejamentos;
            grid.DataBind();

            int qtd = (int)Session["qtdSemAtendimento"];
            if (qtd > 0)
                MessageBox.Show("Existem " + qtd + " emergências não atendidas!");

        }

        protected void lnkBtnCadastrar_Click(object sender, EventArgs e)
        {
            Response.Redirect("ocorrencias.aspx?tipo=INCLUIR");
        }



        protected void linkExcluirFuncionárioVoltar_Click(object sender, EventArgs e)
        {
            divExcluir.Visible = false;
            genCortina.Visible = false;
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Response.Redirect("ocorrencias.aspx?tipo=CONSULTAR");
        }

        protected void btnSalvar_Click1(object sender, EventArgs e)
        {
            string cpf_cliente = txtCPFCliente.Text.Replace(".", "").Replace("/", "").Replace("-", "");
            string cpf_func = txtCPFFunc.Text.Replace(".", "").Replace("/", "").Replace("-", "");

            if (!Validacao.validaCPF(cpf_cliente))
            {
                MessageBox.Show("O CPF do Cliente é Inválido!");
                return;
            }

            if (!Validacao.validaCPF(cpf_func))
            {
                cpf_func = "null";
            }
            else
            {
                cpf_func = "'" + cpf_func + "'";
            }

            try {             
            if (Session["tipoAcao"].ToString().Equals("EDITAR"))
            {
                    string comando = @"update ocorrencias set cpf_funcionario={0},datahora='{1}', latitude='{2}', 
                                                                longitude='{3}', historico='{4}' where id = '{5}'";
                    comando = string.Format(comando,
                                                cpf_func,
                                                DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                                                txtLat.Text,
                                                txtLng.Text,
                                                txtHistórico.Text,
                                                Session["idOcorrencia"].ToString()
                                                );
                    Conexao.escrita(comando);

                    Classes.Auditoria.gravar(Session["cpf"].ToString(), " Planejamento de Cliente de CPF: " + cpf_cliente, 3);

            }
            else
            {

            
                  string  comando = @"insert into ocorrencias (cpf_funcionario, cpf_cliente, datahora, latitude, longitude, historico) 
                                                            values ({0},'{1}','{2}','{3}','{4}','{5}')";
                    comando = string.Format(comando,
                                                cpf_func,
                                                cpf_cliente,
                                                DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                                                txtLat.Text,
                                                txtLng.Text,
                                                txtHistórico.Text
                                                );
                    Conexao.escrita(comando);

                    Classes.Auditoria.gravar(Session["cpf"].ToString(), " Ocorrência Cliente de CPF: " + txtCPFCliente.Text, 2);
                }


            }
            catch(Exception err)
            {
                MessageBox.Show("Ocorrência Não Cadastrado Favor Verificar os dados!");
                return;
            }



            MessageBox.Show("Realizado Com Sucesso!");
            Response.Redirect("ocorrencias.aspx?tipo=CONSULTAR");

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
                lblExcluir.Text = planejamentos.Rows[index]["nome_cliente"].ToString();
                lblCpf.Text = planejamentos.Rows[index]["id"].ToString();
            }
            else
            {
                Session["idOcorrencia"] = planejamentos.Rows[index]["id"].ToString();
                Response.Redirect("ocorrencias.aspx?tipo=EDITAR&id=" + Session["idOcorrencia"].ToString());
            }
        }

        protected void linkExcluirConfirme_Click(object sender, EventArgs e)
        {
            string comando = "delete from ocorrencias where id = '" + lblCpf.Text + "'";
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
                txtCPFFunc.Text = gridBuscaFunc.Rows[index].Cells[0].Text;
                gridBuscaFunc.DataSource = null;
                gridBuscaFunc.DataBind();
            }
        }
        

        protected void lnkBuscarFunc_Click(object sender, EventArgs e)
        {
            string filtro = "";
            
            if (!txtNomeBuscarFunc.Text.Equals(""))
            {
                filtro += " and nome like '%" + txtNomeBuscarFunc.Text + "%'";
                Classes.Auditoria.gravar(Session["cpf"].ToString(), " Funcionario com filtro nome: " + txtNomeBuscarFunc.Text, 5);
            }

            string comando = @"SELECT nome,cpf FROM funcionarios WHERE ativo = 1 " + filtro;
            DataTable funcionarios = Conexao.leitura(comando);

            gridBuscaFunc.DataSource = funcionarios;
            gridBuscaFunc.DataBind();
        }

        protected void lnkBuscaCliente_Click(object sender, EventArgs e)
        {
            string filtro = "";
            
            if (!txtNomeCliente.Text.Equals(""))
            {
                filtro += " and nome like '%" + txtNomeCliente.Text + "%'";
                Classes.Auditoria.gravar(Session["cpf"].ToString(), " Cliente com filtro nome: " + txtNomeCliente.Text, 5);
            }

            string comando = @"SELECT nome,cpf,endereco + ', ' + bairro + ', '+ cidade as endereco FROM clientes WHERE ativo = 1 " + filtro;
            DataTable clientes = Conexao.leitura(comando);

            grdBuscaCliente.DataSource = clientes;
            grdBuscaCliente.DataBind();
        }

        protected void grdBuscaCliente_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "selecionar")
            {
                txtCPFCliente.Text = grdBuscaCliente.Rows[index].Cells[0].Text;
                grdBuscaCliente.DataSource = null;
                grdBuscaCliente.DataBind();
            }
        }

        protected void grid_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[0].ForeColor = Color.Black;
                e.Row.Cells[0].Font.Bold = true;

                if (e.Row.Cells[2].Text.Equals("&nbsp;")) //Funcionário
                {
                    e.Row.Cells[0].Text = "SEM ATENDIMENTO";
                    e.Row.Cells[0].BackColor = Color.Red;
                    Session["qtdSemAtendimento"] = (int)Session["qtdSemAtendimento"] + 1;
                }
                else
                {
                    if (e.Row.Cells[4].Text.Equals("&nbsp;")) //Histórico
                    {
                        e.Row.Cells[0].Text = "SEM INFORMAÇÕES";
                        e.Row.Cells[0].BackColor = Color.Yellow;
                    }
                    else
                    {
                        e.Row.Cells[0].Text = "ATENDIDO";
                        e.Row.Cells[0].BackColor = Color.Green;
                    }
                }
            }
        }

        protected void timer1_Tick(object sender, EventArgs e)
        {
            lnkBtnPesquisar_Click(null, null);
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
                    noOfColumns = grid.Columns.Count - 1;
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
                Phrase phApplicationName = new Phrase("Cadastro de Ocorrências", FontFactory.GetFont("Arial", ApplicationNameSize, iTextSharp.text.Font.NORMAL));

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
                Phrase phHeader = new Phrase("Ocorrências Cadastrados", FontFactory.GetFont("Arial", ReportNameSize, iTextSharp.text.Font.BOLD));
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
                Response.AddHeader("content-disposition", "attachment; filename=Relatorio de Ocorrências de " + DateTime.Now.ToString("yyyyMMdd") + ".pdf");
                Response.End();
            }
            catch { }

        }
    }
}
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
    public partial class consulta_auditoria : System.Web.UI.Page
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
            Classes.Auditoria.gravar(Session["cpf"].ToString(), " na Auditoria ", 1);

        }

        protected void lnkBtnPesquisar_Click(object sender, EventArgs e)
        {
            string filtro = "";
            
            Classes.Auditoria.gravar(Session["cpf"].ToString(), "na Auditoria", 5);

            if (!txtFiltroDescricao.Text.Equals(""))
            {
                filtro += " and descricao like '%" + txtFiltroDescricao.Text + "%'";
                Classes.Auditoria.gravar(Session["cpf"].ToString(), "Com a descrição: " + txtFiltroDescricao.Text, 5);
            }

            if (!txtFiltroCPF.Text.Equals(""))
            {
                filtro += " and cpf_auditoria = '" + txtFiltroCPF.Text.Replace(".", "").Replace("-", "") + "'";
                Classes.Auditoria.gravar(Session["cpf"].ToString(), "Com o CPF: " + txtFiltroCPF.Text, 5);
            }

            try
            {
                DateTime data = Convert.ToDateTime(txtFiltroData.Text);
                filtro += " and date_format(data,'%d/%m/%Y') =  '" + data.ToShortDateString() + "' ";
                Classes.Auditoria.gravar(Session["cpf"].ToString(), "Com a data: " + txtFiltroData.Text, 5);
            }
            catch
            {

            }

            string comando = @"SELECT cpf_auditoria, descricao, data, hora FROM auditoria a WHERE (1=1) " + filtro + " order by data,hora desc";

            DataTable auditoria = Conexao.leitura(comando);

            Session["Listaauditoria"] = auditoria;
            lblTotalResultados.Visible = true;

            if (auditoria.Rows.Count > 0)
            {
                lnkBtnRelatorio.Enabled = true;
                lblTotalResultados.Text = auditoria.Rows.Count + " Resultados";
            }
            else
            {
                lnkBtnRelatorio.Enabled = false;
                lblTotalResultados.Text = "Sem Resultados";

            }
            
            Classes.Auditoria.gravar(Session["cpf"].ToString(), " na Auditoria e Retornou: " + lblTotalResultados.Text, 5);

            grid.DataSource = auditoria;
            grid.DataBind();

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
                    noOfColumns = grid.Columns.Count;
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
                Phrase phApplicationName = new Phrase("Cadastro da Auditoria", FontFactory.GetFont("Arial", ApplicationNameSize, iTextSharp.text.Font.NORMAL));

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
                Phrase phHeader = new Phrase("Auditorias Cadastradas", FontFactory.GetFont("Arial", ReportNameSize, iTextSharp.text.Font.BOLD));
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
                Response.AddHeader("content-disposition", "attachment; filename=Relatorio de Auditoria de " + DateTime.Now.ToString("yyyyMMdd") + ".pdf");
                Response.End();
            }
            catch { }
        }
    }
}
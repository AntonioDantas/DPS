<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="consulta-auditoria.aspx.cs" Inherits="DPS.consulta_auditoria" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Auditoria</title>
    <link href="bootstrap/css/bootstrap.min.css" type="text/css" rel="Stylesheet" />
    <script src="js/mascara.js" type="text/javascript"></script>
    <script src="JS/jquery-1.9.1.js" type="text/javascript"></script>
    <script src="js/jquery/jquery.maskedinput.js" type="text/javascript"></script>
    <script src="js/jquery/jquery.maskMoney.js" type="text/javascript"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>
    <script src="js/Default.js" type="text/javascript"></script>
    <script src="js/mascara.js" type="text/javascript"></script>

    <script type="text/javascript">

        $(function () {
            setMasks();
        });

        function setMasks() {
            $.mask.definitions['A'] = '[0-9a-zA-Z]';
            $.mask.definitions['~'] = '[+-]';

            $('.padraoData').mask('99/99/9999');
            $('.padraoCpf').mask('999.999.999-99');
            $('.padraoCep').mask('99.999-999');
            $('.padraoTelefone').mask('(99) 9999-9999');
            $('.padraoCelular').mask('(99) 9 9999-9999');

        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="row">
                <div class="page-header">
                    <h1>Consulta <small>de Auditoria</small></h1>
                </div>
                <!--INICIO DA CONSULTA-->
                <div id="divconsulta" runat="server" visible="true">
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <!-- FILTROS -->
                            <div class="form-group col-sm-12">
                                <span class="col-sm-2 control-label">CPF</span>
                                <div class="col-sm-2">
                                    <asp:TextBox ID="txtFiltroCPF" CssClass="form-control padraoCpf" runat="server"></asp:TextBox>
                                </div>

                                <span class="col-sm-2 control-label">Data</span>
                                <div class="col-sm-2">
                                    <asp:TextBox ID="txtFiltroData" CssClass="form-control padraoData" runat="server"></asp:TextBox>
                                </div>

                                <span class="col-sm-2 control-label">Descricao</span>
                                <div class="col-sm-2">
                                    <asp:TextBox ID="txtFiltroDescricao" CssClass="form-control" runat="server"></asp:TextBox>
                                </div>

                            </div>
                            <div class="form-group col-md-12" style="text-align: center; margin-top: 20px;">
                                <asp:LinkButton runat="server" ID="lnkBtnPesquisar" CssClass="btn btn-primary" OnClick="lnkBtnPesquisar_Click">
                                    <span class="glyphicon glyphicon-search"></span>
                                    Pesquisar
                                </asp:LinkButton>
                                <asp:LinkButton runat="server" ID="lnkBtnRelatorio" CssClass="btn btn-info" OnClick="lnkBtnRelatorio_Click" Enabled="false">
                                    <span class="glyphicon glyphicon-print"></span>
                                    Relatório
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>
                    <hr />
                    <div style="text-align: center">
                        <asp:Label ID="lblTotalResultados" Visible="False" runat="server" Text="total" Font-Size="Large" Font-Bold="True"></asp:Label>
                    </div>
                    <br />
                    <asp:GridView ID="grid" Font-Size="8" CssClass="table table-hover" runat="server" AutoGenerateColumns="false">
                        <Columns>
                            <asp:BoundField DataField="cpf_auditoria" HeaderText="CPF" />
                            <asp:BoundField DataField="data" HeaderText="DATA"  DataFormatString="{0:dd/MM/yy}" />
                            <asp:BoundField DataField="hora" HeaderText="HORA" />
                            <asp:BoundField DataField="descricao" HeaderText="DESCRICAO" />
                        </Columns>
                        <EditRowStyle HorizontalAlign="Center" />
                    </asp:GridView>
                </div>

                <!--FIM DA CONSULTA-->
            </div>
        </div>
        
    </form>
</body>
</html>

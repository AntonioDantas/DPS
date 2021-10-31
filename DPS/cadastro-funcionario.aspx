<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="cadastro-funcionario.aspx.cs" Inherits="DPS.cadastro_funcionario" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Funcionários</title>
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
    <form id="form1" runat="server" class="form-horizontal">
        <div class="container">
            <div class="row">
                <div class="page-header">
                    <h1><%=Session["tipoAcao"].ToString() %> <small>de Funcionário</small></h1>
                </div>
                <!--INICIO DA CONSULTA-->
                <div id="divconsulta" runat="server" visible="true">
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <div class="form-group col-sm-4">
                                <span class="col-sm-6 control-label">Nome</span>
                                <div class="col-sm-6">
                                    <asp:TextBox ID="txtFiltroNome" CssClass="form-control" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-group col-md-12" style="text-align: center; margin-top: 20px;">
                                <asp:LinkButton runat="server" ID="lnkBtnPesquisar" CssClass="btn btn-primary" OnClick="lnkBtnPesquisar_Click">
                                    <span class="glyphicon glyphicon-search"></span>
                                    Pesquisar
                                </asp:LinkButton>
                                <asp:LinkButton runat="server" ID="lnkBtnCadastrar" CssClass="btn btn-warning" OnClick="lnkBtnCadastrar_Click">
                                    <span class="glyphicon glyphicon-new-window"></span>
                                    Cadastrar
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
                    <asp:GridView ID="grid" Font-Size="8" CssClass="table table-hover" runat="server" AutoGenerateColumns="false" OnRowCommand="grid_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="cpf" HeaderText="CPF" />
                            <asp:BoundField DataField="nome" HeaderText="NOME" />
                            <asp:BoundField DataField="telefone_comercial" HeaderText="COMERCIAL" />
                            <asp:BoundField DataField="telefone_celular" HeaderText="CELULAR" />
                            <asp:BoundField DataField="bairro" HeaderText="BAIRRO" />
                            <asp:BoundField DataField="cidade" HeaderText="CIDADE" />
                            <asp:BoundField DataField="email" HeaderText="EMAIL" />
                            <asp:BoundField DataField="acesso" HeaderText="ÚLTIMO ACESSO" />
                            <asp:ButtonField ButtonType="Link" CommandName="Excluir" ControlStyle-CssClass="btn btn-danger btn-xs" Text="Excluir" />
                            <asp:ButtonField ButtonType="Link" CommandName="Editar" ControlStyle-CssClass="btn btn-success btn-xs" Text="Editar" />
                        </Columns>
                        <EditRowStyle HorizontalAlign="Center" />
                    </asp:GridView>
                </div>

                <!--FIM DA CONSULTA-->
                <div style="position: absolute; opacity: .8; width: 100%; height: 300%; top: 0px; left: 0px; z-index: 10; background-color: #333;" runat="server" id="genCortina" visible="false"></div>


                <!--INICIO DA ALTERACAO-->
                <div id="divalteracao" runat="server">
                    <div class="page-header">
                        <h1><small>Dados do  funcionário</small></h1>
                    </div>
                    <div class="panel panel-primary class">
                        <div class="panel-heading">Dados Pessoais</div>
                        <br />
                        <div class="form-group">
                            <span class="col-sm-2 text-center">CPF:</span>
                            <div class="col-sm-3">
                                <asp:TextBox ID="txtCPF" CssClass="form-control padraoCpf" runat="server"></asp:TextBox>
                            </div>
                            <span class="col-sm-2 text-center">Data Nascimento:</span>
                            <div class="col-sm-3">
                                <asp:TextBox ID="txtNascimento" CssClass="form-control padraoData" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <br />
                        <div class="form-group">
                            <span class="col-sm-2 text-center">Nome:</span>
                            <div class="col-sm-8">
                                <asp:TextBox ID="txtNome" CssClass="form-control text-uppercase" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <br />
                    </div>
                    <div class="panel panel-primary class">
                        <div class="panel-heading">Dados Endereço</div>
                        <br />
                        <div class="form-group">
                            <span class="col-sm-2 text-center">CEP:</span>
                            <div class="col-sm-3">
                                <asp:TextBox ID="txtCep" CssClass="form-control padraoCep" runat="server"></asp:TextBox>
                            </div>
                            <div class="col-sm-2 text-center">
                                <asp:LinkButton ID="btnBuscaCEP" CssClass="btn btn-default" runat="server" Text="Cancelar" OnClick="btnBuscaCEP_Click">
                                    <span class="glyphicon glyphicon-icon-home"></span>
                                    Localizar Endereço
                                </asp:LinkButton>
                            </div>
                            <span class="col-sm-1">Estado:</span>
                            <div class="col-sm-2 text-center">
                                <asp:TextBox ID="txtEstado" MaxLength="2" CssClass="form-control text-uppercase" runat="server"></asp:TextBox>
                            </div>

                        </div>
                        <br />
                        <div class="form-group">
                            <span class="col-sm-2 text-center">Endereço:</span>
                            <div class="col-sm-8">
                                <asp:TextBox ID="txtEndereco" CssClass="form-control text-uppercase" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <br />
                        <div class="form-group">
                            <span class="col-sm-2 text-center">Bairro:</span>
                            <div class="col-sm-3">
                                <asp:TextBox ID="txtBairro" CssClass="form-control text-uppercase" runat="server"></asp:TextBox>
                            </div>
                            <span class="col-sm-2 text-center">Cidade:</span>
                            <div class="col-sm-3">
                                <asp:TextBox ID="txtCidade" CssClass="form-control text-uppercase" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <br />
                        <br />
                    </div>

                    <div class="panel panel-primary class">
                        <div class="panel-heading">Dados Contato</div>
                        <br />
                        <div class="form-group">
                            <span class="col-sm-2 text-center">Tel. Residencial:</span>
                            <div class="col-sm-3 ">
                                <asp:TextBox ID="txtResidencial" CssClass="form-control padraoTelefone" runat="server"></asp:TextBox>
                            </div>

                            <span class="col-sm-2 text-center">Tel. Comercial:</span>
                            <div class="col-sm-3">
                                <asp:TextBox ID="txtComercial" CssClass="form-control padraoTelefone" runat="server"></asp:TextBox>
                            </div>

                        </div>
                        <br />
                        <div class="form-group">

                            <span class="col-sm-2 text-center">Celular:</span>
                            <div class="col-sm-3 ">
                                <asp:TextBox ID="txtCelular" CssClass="form-control padraoCelular" runat="server"></asp:TextBox>
                            </div>

                            <span class="col-sm-2 text-center">Email:</span>
                            <div class="col-sm-3">
                                <asp:TextBox ID="txtEmail" CssClass="form-control text-uppercase" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <br />
                    </div>

                    <br />

                    <div class="form-group">
                        <div class="col-sm-6 text-center">
                            <asp:Button ID="btnSalvar" CssClass="btn btn-primary" runat="server" Text="Salvar" OnClick="btnSalvar_Click1" />
                        </div>
                        <div class="col-sm-6 text-left">
                            <asp:Button ID="btnCancelar" CssClass="btn btn-default" runat="server" Text="Cancelar" OnClick="btnCancelar_Click" />
                        </div>
                    </div>
                </div>
                <!-- FIM DA ALTERAÇÃO-->

                <!-- INICIO EXCLUSAO -->
                <div class="well col-md-6 col-md-offset-2" style="position: absolute; z-index: 100; top: 100px;" runat="server" id="divExcluir" visible="false">
                    <h4>Exclusão de  de Contas</h4>
                    <small>Tem certeza que deseja Excluir o </small>
                    <b>
                        <asp:Label Text="" ID="lblExcluir" runat="server" /></b>
                    <small>CPF:</small>
                    <b>
                        <asp:Label runat="server" ID="lblCpf" /></b>
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />

                    <asp:LinkButton runat="server" ID="linkExcluirConfirme" CssClass="btn btn-danger col-md-6" OnClick="linkExcluirConfirme_Click">
	<span class="glyphicon glyphicon-remove-sign"></span> EXCLUIR
                    </asp:LinkButton>

                    <asp:LinkButton runat="server" ID="linkExcluirVoltar" CssClass="btn btn-default col-md-6" OnClick="linkExcluirfuncionarioVoltar_Click">
	<span class="glyphicon glyphicon-circle-arrow-left"></span> VOLTAR
                    </asp:LinkButton>
                </div>
                <!-- FIM EXCLUSÃO-->



            </div>
        </div>
    </form>
</body>
</html>

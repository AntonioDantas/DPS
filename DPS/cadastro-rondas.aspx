<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="cadastro-rondas.aspx.cs" Inherits="DPS.cadastro_rondas" %>

<%@ Register Assembly="GMaps" Namespace="Subgurim.Controles" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Planejamento</title>
    <link href="bootstrap/css/bootstrap.min.css" type="text/css" rel="Stylesheet" />
    <script src="js/mascara.js" type="text/javascript"></script>
    <script src="JS/jquery-1.9.1.js" type="text/javascript"></script>
    <script src="js/jquery/jquery.maskedinput.js" type="text/javascript"></script>
    <script src="js/jquery/jquery.maskMoney.js" type="text/javascript"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>
    <script src="js/Default.js" type="text/javascript"></script>
    <script src="js/mascara.js" type="text/javascript"></script>

    <script type="text/javascript">

        (function ($) {
            $.fn.styleddropdown = function () {
                return this.each(function () {
                    obj = $(this)
                    obj.find('.field').click(function () { //onclick event, 'list' fadein
                        obj.find('.list').fadeIn(400);

                        $(document).keyup(function (event) { //keypress event, fadeout on 'escape'
                            if (event.keyCode == 27) {
                                obj.find('.list').fadeOut(400);
                            }
                        });

                        obj.find('.list').hover(function () { },
                            function () {
                                $(this).fadeOut(400);
                            });
                    });

                    obj.find('.list li').click(function () { //onclick event, change field value with selected 'list' item and fadeout 'list'
                        obj.find('.field')
                            .val($(this).html())
                            .css({
                                'background': '#fff',
                                'color': '#333'
                            });
                        obj.find('.list').fadeOut(400);
                    });
                });
            };
        })(jQuery);

        $(function () {
            $('.size').styleddropdown();
            initMap();
            $("#GMap1").fadeOut(2000);
            $("#container_mapa2").slideDown(2000);
        });



        function clearOverlays() {
            for (var i = 0; i < markersArray.length; i++) {
                markersArray[i].setMap(null);
            }
            markersArray.length = 0;
        }

        var markersArray = [];
        var logradouro = "";
        var estado = "";
        var cidade = "";
        var cep = "";
        var bairro = "";


        function initMap() {
            // Pegando coordenadas da cidade selecionada para iniciar o processo
            try {
                var myLatlng = new google.maps.LatLng(-23.212164, -45.903536)
            } catch (err) { }

            var mapa_utilizado = 'divMapa2';
            var endereco = "";
            endereco = "São José dos Campos - SP";

            geocoder = new google.maps.Geocoder();
            geocoder.geocode({ 'address': endereco }, function (results, status) {
                if (status = google.maps.GeocoderStatus.OK) {
                    myLatlng = results[0].geometry.location;
                    try {
                        map.setCenter(myLatlng);
                    } catch (err) {

                    }
                }
            });

            var map = new google.maps.Map(document.getElementById(mapa_utilizado), {
                zoom: 14,
                center: myLatlng
            });

            map.addListener('rightclick', function (e) {
                // Limpa todos os marcadores
                clearOverlays();

                // Cria um marcador para o ponto clicado
                var marker = new google.maps.Marker({
                    position: e.latLng,
                    map: map,
                    title: 'Ponto do Escolhido'
                });
                markersArray.push(marker);

                // Joga as coordenadas nas caixas
                $("#txtLat").val(String(e.latLng).split(",")[0].replace("(", "").replace(" ", ""));
                $("#txtLng").val(String(e.latLng).split(",")[1].replace(")", "").replace(" ", ""));

                javascript: __doPostBack('lnkInsere', '');
            });
        }

    </script>

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
            $('.padraoSenha').mask('9999');

        }

    </script>
</head>
<body>
    <form id="form1" runat="server" class="form-horizontal">
        <div class="container">
            <div class="row">
                <div class="page-header">
                    <h1><%=Session["tipoAcao"].ToString() %> <small>de Rondas</small></h1>
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
                    <asp:GridView ID="grid" Font-Size="8" CssClass="table table-hover" AutoGenerateColumns="false" runat="server" OnRowCommand="grid_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="pontos" HeaderText="Qtd de Pontos" />
                            <asp:BoundField DataField="cpf" HeaderText="CPF" />
                            <asp:BoundField DataField="nome" HeaderText="NOME" />
                            <asp:ButtonField ButtonType="Link" CommandName="Excluir" ControlStyle-CssClass="btn btn-danger btn-xs" Text="Excluir" />
                            <asp:ButtonField ButtonType="Link" CommandName="Editar" ControlStyle-CssClass="btn btn-success btn-xs" Text="Editar" />
                        </Columns>
                    </asp:GridView>
                </div>

                <!--FIM DA CONSULTA-->
                <div style="position: absolute; opacity: .8; width: 100%; height: 300%; top: 0px; left: 0px; z-index: 10; background-color: #333;" runat="server" id="genCortina" visible="false"></div>


                <!--INICIO DA ALTERACAO-->
                <div id="divalteracao" runat="server">
                    <div class="panel panel-primary class">
                        <div class="panel-heading">Dados da Ronda</div>
                        <br />
                        <div class="form-group">
                            <span class="col-sm-2 text-center">Posições:</span>
                            <div class="col-sm-5">
                                <asp:DropDownList ID="ddlPosicoes" CssClass="form-control text-uppercase" runat="server"></asp:DropDownList>
                            </div>
                            <div class="col-sm-2">
                                <asp:LinkButton runat="server" ID="lnkInsere" CssClass="btn btn-success" OnClick="lnkInsere_Click">
                                    <span class="glyphicon glyphicon-plus"></span>
                                    Inserir
                                </asp:LinkButton>
                            </div>
                            <div class="col-sm-2">
                                <asp:LinkButton runat="server" ID="lnkRemove" CssClass="btn btn-danger" OnClick="lnkRemove_Click">
                                    <span class="glyphicon glyphicon-minus"></span>
                                    Remover
                                </asp:LinkButton>
                            </div>
                            <br />
                            </div>
                            <div class="form-group">
                                <span class="col-sm-2 text-center">Latitude:</span>
                                <div class="col-sm-3">
                                    <asp:TextBox runat="server" ID="txtLat" CssClass="form-control text-uppercase"></asp:TextBox>
                                </div>
                                <span class="col-sm-2 text-center">Longitude:</span>
                                <div class="col-sm-3">
                                    <asp:TextBox runat="server" ID="txtLng" CssClass="form-control text-uppercase"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-group">

                                <div id="container_mapa2" style="width: 80%; margin-left:5%; display: none; margin-bottom: 15px; text-align: center; align-content: center; align-items: center;">
                                    Use o botão direito do mouse parar criar um marcador.
                                        <div style="width: 25%; display: inline-block; vertical-align: bottom;">
                                            <cc1:GMap ID="GMap1" runat="server" DataLatField="-23.622528" DataLngField="-45.411901"
                                                enableRotation="True" enableServerEvents="True" enableStore="True"
                                                Key="AIzaSyCUPXEhW978AqCXzDIHg9JN8yaugKhkcFA" serverEventsType="GMapsAjax" Width="285px" Height="300px" />
                                        </div>

                                    <div id="divMapa2" style="width: 100%; height: 400px; margin: 5px;">
                                    </div>
                                </div>
                            </div>

                        <div class="panel panel-primary class">
                            <div class="panel-heading">Pesquisar Funcionário:</div>
                            <br />
                            <div class="form-group">
                                <span class="col-sm-2 text-center">CPF:</span>
                                <div class="col-sm-2">
                                    <asp:TextBox ID="txtCPF" CssClass="form-control padraoCpf" Enabled="false" runat="server"></asp:TextBox>
                                </div>
                                <span class="col-sm-2 text-center">Nome:</span>
                                <div class="col-sm-3">
                                    <asp:TextBox ID="txtNomeBuscar" CssClass="form-control" runat="server"></asp:TextBox>
                                </div>
                                <div class="col-sm-2">
                                    <asp:LinkButton runat="server" ID="lnkBuscar" CssClass="btn btn-primary" OnClick="lnkBuscar_Click">
                                    <span class="glyphicon glyphicon-search"></span>
                                    Busca
                                    </asp:LinkButton>
                                </div>
                            </div>
                            <br />
                            <div class="form-group">
                                <div class="col-sm-8 text-center" style="text-align: center; margin-left:10%">
                                    <asp:GridView ID="gridBuscaFunc" Font-Size="8" CssClass="table table-hover" AutoGenerateColumns="false" runat="server" OnRowCommand="gridBuscaFunc_RowCommand">
                                        <Columns>
                                            <asp:BoundField DataField="cpf" HeaderText="CPF" />
                                            <asp:BoundField DataField="nome" HeaderText="NOME" />
                                            <asp:ButtonField ButtonType="Link" CommandName="selecionar" ControlStyle-CssClass="btn btn-info btn-xs" Text="Selecionar" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                            <br />
                        </div>
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
                    <h4>Exclusão</h4>
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

                    <asp:LinkButton runat="server" ID="linkExcluirVoltar" CssClass="btn btn-default col-md-6">
	<span class="glyphicon glyphicon-circle-arrow-left"></span> VOLTAR
                    </asp:LinkButton>
                </div>
                <!-- FIM EXCLUSÃO-->



            </div>
        </div>
    </form>
</body>
</html>

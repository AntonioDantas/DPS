<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation = "false" CodeBehind="cadastro-cliente.aspx.cs" Inherits="DPS.cadastro_cliente" %>

<%@ Register Assembly="GMaps" Namespace="Subgurim.Controles" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Clientes</title>
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
        });


        /* Mapa */
        var lati_backup, longi_backup;
        function btnMarcar_click(abre) {
            if (abre == true) {
                if ($("#container_mapa2").is(':visible')) {
                    $("#GMap1").fadeIn(2000);
                    $("#container_mapa2").slideUp(2000);
                    $("#txtLat").val(lati_backup);
                    $("#txtLng").val(longi_backup);
                }
                else {
                    lati_backup = $("#txtLat").val();
                    longi_backup = $("#txtLng").val();
                    $("#GMap1").fadeOut(2000);
                    $("#container_mapa2").slideDown(2000);
                    initMap();
                }
            }
            else {
                $("#GMap1").fadeIn(2000);
                $("#container_mapa2").slideUp(2000);
            }
        }

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
            if (document.getElementById("txtCidade").value != "") {
                endereco = document.getElementById("txtCidade").value;
            } else {
                endereco = "São José dos Campos - SP";
            }

            if (endereco == "") {
                endereco = "São José dos Campos - SP";
            }

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

                //Atualiza endereço

                geocoder.geocode({ 'latLng': marker.getPosition() }, function (results, status) {
                    if (status == google.maps.GeocoderStatus.OK) {
                        if (results[0]) {
                            //results[0].formatted_address: "R. Ibate, 370 - Jardim das Industrias, São José dos Campos - SP, 12241-050, Brasil",
                            var res_localizacao = results[0].formatted_address;
                            cep = String(res_localizacao).split(",")[3].trim();
                            logradouro = String(res_localizacao).split(",")[0].trim();
                            bairro = String(res_localizacao).split(",")[1].trim();
                            bairro = String(bairro).split("-")[1].trim();
                            cidade = String(res_localizacao).split(",")[2].trim();
                            cidade = String(cidade).split("-")[0].trim();
                            estado = String(res_localizacao).split(",")[2].trim();
                            estado = String(estado).split("-")[1].trim();

                            if (document.getElementById("txtCep").value == "") $("#txtCep").val(cep);
                            if (document.getElementById("txtEstado").value == "") $("#txtEstado").val(estado);
                            if (document.getElementById("txtEndereco").value == "") $("#txtEndereco").val(logradouro);
                            if (document.getElementById("txtBairro").value == "") $("#txtBairro").val(bairro);
                            if (document.getElementById("txtCidade").value == "") $("#txtCidade").val(cidade);
                        }
                    }
                });


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
                    <h1><%=Session["tipoAcao"].ToString() %> <small>de cliente</small></h1>
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
                    <asp:GridView ID="grid" Font-Size="8" CssClass="table table-hover" AutoGenerateColumns="false" runat="server" OnRowDataBound="grid_RowDataBound" OnRowCommand="grid_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="cpf" HeaderText="CPF" />
                            <asp:BoundField DataField="nome" HeaderText="NOME" />
                            <asp:BoundField DataField="telefone_comercial" HeaderText="COMERCIAL" />
                            <asp:BoundField DataField="telefone_celular" HeaderText="CELULAR" />
                            <asp:BoundField DataField="bairro" HeaderText="BAIRRO" />
                            <asp:BoundField DataField="cidade" HeaderText="CIDADE" />
                            <asp:BoundField DataField="senha_liberacao" HeaderText="LIBERAÇÃO" />
                            <asp:BoundField DataField="senha_panico" HeaderText="PÂNICO" />
                            <asp:BoundField DataField="senha" HeaderText="ACESSO" />
                            <asp:BoundField DataField="acesso" HeaderText="ÚLTIMO ACESSO" />
                            <asp:ButtonField ButtonType="Link" CommandName="Excluir" ControlStyle-CssClass="btn btn-danger btn-xs" Text="Excluir" />
                            <asp:ButtonField ButtonType="Link" CommandName="Editar" ControlStyle-CssClass="btn btn-success btn-xs" Text="Editar" />
                        </Columns>
                    </asp:GridView>
                </div>

                <!--FIM DA CONSULTA-->
                <div style="position: absolute; opacity: .8; width: 100%; height: 300%; top: 0px; left: 0px; z-index: 10; background-color: #333;" runat="server" id="genCortina" visible="false"></div>


                <!--INICIO DA ALTERACAO-->
                <div id="divalteracao" runat="server">
                    <div class="page-header">
                        <h1><small>Dados do  cliente</small></h1>
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
                        <div class="boxcenter container" id="divMarcador" runat="server">
                            <div class="panel panel-default">
                                <div class="panel-heading">DADOS DO LOCALIZAÇÃO ESPECÍFICA</div>
                                <div class="panel-body">

                                    <div class="row">
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
                                    </div>
                                    <br />
                                    <br />
                                    <input type="button" style="align-items:center; align-content:center; text-align:center;" value="Atenção! Clique aqui para cria Marcador no Mapa Abaixo com o Botão Direito do Mouse em um Local Específico e Preencher os campos do Endereço e a Latitude e Longitude" id="btnMarcar" onclick="btnMarcar_click(true)" class="btn btn-primary btn-sm" />
                                    <div id="container_mapa2" style="width: 90%; display: none; margin-bottom: 15px; text-align:center; align-content:center; align-items:center;">
                                        Use o botão direito do mouse parar criar um marcador.<br />
                                        <div style="width: 25%; display: inline-block; vertical-align: bottom;">
                                            <cc1:GMap ID="GMap1" runat="server" DataLatField="-23.622528" DataLngField="-45.411901"
                                                enableRotation="True" enableServerEvents="True" enableStore="True"
                                                Key="AIzaSyCUPXEhW978AqCXzDIHg9JN8yaugKhkcFA" serverEventsType="GMapsAjax" Width="285px" Height="300px" />
                                        </div>

                                        <div id="divMapa2" style="width: 100%; height: 400px; margin: 5px;">
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>

                    </div>

                    <br />

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

                    <div class="panel panel-primary class">
                        <div class="panel-heading">Dados de Segurança</div>
                        <br />
                        <div class="form-group">
                            <span class="col-sm-2 text-center">Senha de Pânico:</span>
                            <div class="col-sm-3 ">
                                <asp:TextBox ID="txtSenhaPanico" CssClass="form-control padraoSenha" runat="server"></asp:TextBox>
                            </div>

                            <span class="col-sm-2 text-center">Senha de Liberação:</span>
                            <div class="col-sm-3">
                                <asp:TextBox ID="txtSenhaLiberacao" CssClass="form-control padraoSenha" runat="server"></asp:TextBox>
                            </div>

                        </div>
                        <br />
                        <div class="form-group">

                            <span class="col-sm-2 text-center">Senha de Acesso:</span>
                            <div class="col-sm-3 ">
                                <asp:TextBox ID="txtSenhaAcesso" CssClass="form-control padraoSenha" runat="server"></asp:TextBox>
                            </div>

                            <span class="col-sm-2 text-center">Último Acesso:</span>
                            <div class="col-sm-3">
                                <asp:Label ID="lblUltimoAcesso" Text="" CssClass="form-control padraoSenha" runat="server"></asp:Label>    
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

                    <asp:LinkButton runat="server" ID="linkExcluirVoltar" CssClass="btn btn-default col-md-6" OnClick="linkExcluirclienteVoltar_Click">
	<span class="glyphicon glyphicon-circle-arrow-left"></span> VOLTAR
                    </asp:LinkButton>
                </div>
                <!-- FIM EXCLUSÃO-->



            </div>
        </div>
    </form>
</body>
</html>

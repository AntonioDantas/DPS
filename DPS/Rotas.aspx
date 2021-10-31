<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Rotas.aspx.cs" Inherits="DPS.Rotas" %>


<html xmlns="http://www.w3.org/1999/xhtml" lang="pt-br">
<head>
    <meta charset="iso-8859-1">
    <title>Funcionários Online</title>

    <style type="text/css">
        html, body, #map-canvas {
            height: 100%;
            margin: 0;
            padding: 0;
            height: 100%;
            font: 10pt "Helvetica Neue", Arial, Helvetica, sans-serif;
        }

        .customLabel label, span {
            vertical-align: middle;
            margin-top: 10px;
            color: #000000;
            text-transform: uppercase;
            font: 10px Arial,Helvetica;
        }

        #divFiltros {
            position: fixed;
            top: 0px;
            left: -1px;
            height: auto;
            width: 100%;
            z-index: 1000;
        }

        #filtrosContent {
            max-height: 90%;
        }

        .filtros {
            top: 0px;
            left: 0px;
            color: #FFFFFF;
            background: rgba(10,10,10,0.5);
            width: 100%;
            padding-bottom: 10px;
            overflow-y: auto;
            max-height: 660px;
        }

        .checkbox {
            margin-top: 0px;
            margin-bottom: 0px;
            padding: 0px;
        }

        .maxHeightRow {
            height: 230px;
            max-height: 235px;
            overflow-y: auto;
        }

        .lorem {
            font-style: italic;
            color: #AAA;
        }
    </style>

    <script src="http://code.jquery.com/jquery-1.8.2.js"></script>
    <script type="text/javascript" src="scripts/gMapsUtil.js"></script>
    <script type="text/javascript" src="scripts/util.js"></script>
    <script src="scripts/bootstrap.min.js"></script>
    <script src="scripts/jquery.blockUI.js"></script>
    <script type="text/javascript"
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCf4_63xYEyXs0IZnjc3gFv8CLY3R8SFwU&libraries=drawing">
    </script>
    <script src="https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js"></script>
    <link href="content/bootstrap.min.css" rel="stylesheet" />
    <script src="Scripts/maps_rota.js" charset="iso-8859-1"></script>

    <link href="content/bootstrap.min.css" rel="stylesheet" />
    <script src="js/jquery/jquery.maskedinput.js" type="text/javascript"></script>
    <script src="js/jquery/jquery.maskMoney.js" type="text/javascript"></script>
    <script src="js/mascara.js" type="text/javascript"></script>



    <script src="http://cdn.rawgit.com/MrRio/jsPDF/master/dist/jspdf.min.js" type="text/javascript"></script>
    <script src="http://html2canvas.hertzen.com/build/html2canvas.js" type="text/javascript"></script>


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

    <script>
        var directionsDisplay;
        var directionsService = new google.maps.DirectionsService();

        function exibir() {
            event.preventDefault();

            var request = null;
            var cpf = document.getElementById("txtCpf").value;
            var dia = document.getElementById("txtData").value;

            $.ajax({
                method: "GET",
                url: urlMapa + '/Online/RotaOnline?cpf=' + cpf + '&dia=' + dia,
                data: "",
                success: function (retorno) {
                    if (retorno.length === 0) {
                        //alert("Não existem usuários logados no momento.");
                    } else {
                        var contador = 0;
                        var pontos = [retorno.length];

                        $.each(retorno, function (index, element) {
                            pontos[contador] = new google.maps.LatLng(element.latitude, element.longitude);
                            contador++;
                        });

                        var flightPath = new google.maps.Polyline({
                            path: pontos,
                            geodesic: true,
                            strokeColor: '#FF0000',
                            strokeOpacity: 1.0,
                            strokeWeight: 2
                        });

                        flightPath.setMap(map);

                    }
                }
            });

            $.ajax({
                method: "GET",
                url: urlMapa + '/Online/RondaVinculada?cpf=' + cpf,
                data: "",
                success: function (retorno) {
                    if (retorno.length === 0) {
                        //alert("Não existem usuários logados no momento.");
                    } else {
                        var contador = 0;
                        var pontos = [retorno.length];

                        $.each(retorno, function (index, element) {
                            pontos[contador] = new google.maps.LatLng(element.latitude, element.longitude);
                            contador++;
                        });

                        var flightPath = new google.maps.Polygon({
                            path: pontos,
                            geodesic: true,
                            strokeColor: '#00FF00',
                            strokeOpacity: 0.5,
                            strokeWeight: 1,
                            fillColor: '#00FF00'
                        });

                        flightPath.setMap(map);

                    }
                }
            });
        }


    </script>

    <script language="javascript"> 
        var cache_width = $('#map-canvas').width(); //Criado um cache do CSS
        var a4 = [700.00, 841.89]; // Widht e Height de uma folha a4

        function getPDF() {
            // Setar o width da div no formato a4
            $("#map-canvas").width(a4[0]).css('max-width', 'none');

            // Aqui ele cria a imagem e cria o pdf
            html2canvas($('#map-canvas'), {
                logging: false,
                useCORS: true,
                onrendered: function (canvas) {
                    var img = canvas.toDataURL("image/png", 1.0);
                    var doc = new jsPDF({ unit: 'px', format: 'a4' });
                    doc.addImage(img, 'JPEG', 20, 20);
                    doc.save('Mapa de Rotas.pdf');
                    //Retorna ao CSS normal
                    $('#map-canvas').width(cache_width);
                }
            });
        }
    </script>

    <html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title></title>
    </head>
    <body>
        <form id="form1" runat="server">
            <div class="container">
                <div class="row">
                    <div class="page-header">
                        <h1>Visualizar <small>rota do  funcionário</small></h1>
                    </div>
                    <div class="panel panel-primary class">
                        <div class="panel-heading">Identificação</div>
                        <br />
                        <div class="form-group">
                            <span class="col-sm-1 text-center">CPF:</span>
                            <div class="col-sm-3">
                                <asp:TextBox ID="txtCpf" CssClass="form-control padraoCpf" runat="server"></asp:TextBox>
                            </div>
                            <span class="col-sm-1 text-center">Data:</span>
                            <div class="col-sm-3">
                                <asp:TextBox ID="txtData" CssClass="form-control padraoData" runat="server"></asp:TextBox>
                            </div>
                            <div class="col-sm-1 text-center">
                                <asp:LinkButton runat="server" ID="btnExibir" OnClientClick="exibir();" CssClass="btn btn-primary">Ver</asp:LinkButton>
                            </div>
                            <div class="col-sm-1 text-center">
                                <asp:LinkButton runat="server" ID="lnkExportar" OnClientClick="getPDF();" CssClass="btn btn-success">Exportar</asp:LinkButton>
                            </div>
                        </div>
                        <br />
                        <br />

                    </div>
                </div>
            </div>
            <img id="displayBox" src="content/loading.gif" width="128" height="15" style="display: none" />

            <!-- Cortina -->
            <div id="cortina" class="cortina">
                <div class="cssload-squeeze">
                    <span></span><span></span><span></span><span></span><span></span>
                </div>
            </div>
                <div id="map-canvas" class="sidebar-map" style="width: 40%; height: 40%; margin-bottom: 15px; margin-left: 25%; text-align: center; align-content: center; align-items: center; margin-top: 1%"></div>
         
        </form>
    </body>
    </html>

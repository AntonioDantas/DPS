<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Online.aspx.cs" Inherits="DPS.Online" %>

<!DOCTYPE html>


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

    <script type="text/javascript" src="Scripts/jquery-2.1.4.min.js"></script>
    <script type="text/javascript" src="scripts/gMapsUtil.js"></script>
    <script type="text/javascript" src="scripts/util.js"></script>
    <script src="scripts/bootstrap.min.js"></script>
    <script src="scripts/jquery.blockUI.js"></script>
    <script type="text/javascript"
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCf4_63xYEyXs0IZnjc3gFv8CLY3R8SFwU&libraries=drawing">
    </script>
    <script src="https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js"></script>
    <link href="content/bootstrap.min.css" rel="stylesheet" />
    <link href="css/gmaps-sidebar.css" rel="stylesheet" />
    <link href="css/sb-admin-2.css" rel="stylesheet" />
    <script src="Scripts/maps.js" charset="iso-8859-1"></script>


    <script src="http://cdn.rawgit.com/MrRio/jsPDF/master/dist/jspdf.min.js" type="text/javascript"></script>
    <script src="http://html2canvas.hertzen.com/build/html2canvas.js" type="text/javascript"></script>


    <script language="javascript"> 
        var cache_width = $('#map-canvas').width(); //Criado um cache do CSS
        var a4 = [700.00, 841.89]; // Widht e Height de uma folha a4

        function atualizarDataHora() {
            var dataAtual = new Date();
            var dia = dataAtual.getDate();
            var mes = dataAtual.getMonth();
            var ano = dataAtual.getYear();
            var hora = dataAtual.getHours();
            var minuto = dataAtual.getMinutes();
            var segundo = dataAtual.getSeconds();

            var horaImprimivel = dia + "-" + mes + "-" + ano + "_" + hora + "-" + minuto + "-" + segundo;
            return horaImprimivel;
        }


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
                    doc.save('Online_' + atualizarDataHora() + '.pdf');
                    //Retorna ao CSS normal
                    $('#map-canvas').width(cache_width);
                }
            });
        }
    </script>


</head>
<body style="align-items: center; align-content: center; align-self: center;">
    <img id="displayBox" src="content/loading.gif" width="128" height="15" style="display: none" />

    <!-- Cortina -->
    <div id="cortina" class="cortina">
        <div class="cssload-squeeze">
            <span></span><span></span><span></span><span></span><span></span>
        </div>
    </div>



    <div class="container">
        <div class="row">
            <div class="page-header">
                <h1>Visualizar <small>Online</small></h1>
            </div>

            <div class="form-group">
                <div class="col-sm-12 text-center">
                    <button id="lnkExportar" onclick="getPDF();" class="btn btn-success">Exportar</button>
                </div>
            </div>
            <br />
            <br />

        </div>
    </div>

    <div id="map-canvas" class="sidebar-map" style="margin-top: 0%; width: 40%; height: 30%; left: 500px; align-self: center;"></div>


</body>
</html>

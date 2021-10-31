<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="help.aspx.cs" Inherits="DPS.help" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
    <script src="scripts/bootstrap.min.js"></script>
    <script src="scripts/jquery.blockUI.js"></script>
    <script type="text/javascript"
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCf4_63xYEyXs0IZnjc3gFv8CLY3R8SFwU&libraries=drawing">
    </script>
    <script src="https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js"></script>
    <link href="content/bootstrap.min.css" rel="stylesheet" />

    <script type="text/javascript">

        function baixar() {
                document.getElementById('my_iframe').src = '/tutorial.pdf';
  
        }

    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="row">
                <div class="page-header">
                    <h1>Precisa <small>de ajuda?</small></h1>
                </div>

                <div class="panel panel-primary class">
                    <div class="panel-heading">Sobre:</div>
                    <br />
                    <div class="panel-body">
                        <div class="form-group col-sm-12 ">
                            <div class="col-sm-5 text-left">
                                O Sistema de Informação em desenvolvimento tem como objetivo realizar o atendimento de necessidades de Empresa de Segurança Patrimonial, apresentando como principais recursos: controle de clientes e funcionários, controle de rondas, emergências e localização dos envolvidos em tempo real.

                            </div>
                            <div class="col-sm-3 text-left">
                                Alunos:<br />
                                580961- Antonio J. Dantas Filho<br />
                                581020 - Márcio Rogério Porto<br />
                                435937 - Giovani Lopes Altelino<br />
                                434183 - Beatriz Lopes Luz<br />

                            </div>
                            <div class="col-sm-4 text-center">
                            </div>
                            UNIVERSIDADE FEDERAL DE SÃO CARLOS<br />
                            BACHARELADO EM SISTEMAS DE INFORMAÇÃO<br />
                            Disciplina: Desenvolvimento de Projetos de Sistemas 2<br />
                            Professores:    	Dr. Daniel Lucrédio<br />
                            Tutor:               	Dr. Elias Adriano Nogueira da Silva<br />

                        </div>
                        <br />
                        <br />
                        <br />
                        <div class="form-group col-sm-12">
                            <div class="col-sm-12 text-center">
                                <a id="lnkExportar" onclick="baixar();" href="/tutorial.pdf" target="_blank" class="btn btn-success">Baixar Tutorial</a>
                            </div>
                        </div>
                        <br />
                        <br />
                        <iframe id="my_iframe" width="100%" height="500px" style="border:0px;"></iframe>
                    </div>
        </div>

            </div>
        </div>

    </form>
</body>
</html>

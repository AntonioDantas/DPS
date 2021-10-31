<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="inicio.aspx.cs" Inherits="DPS.inicio" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <title>DPS - Grupo 2</title>
    <meta charset="UTF-8" />
    <meta name="description" content="Wikipedia Viewer FCC" />
    <meta name="keywords" content="Free Code Camp, Wikipedia" />
    <meta name="author" content="Giovani Altelino" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="boot4Beta/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="style.css" />
     
    <script src="jquery-3.2.1.min.js"></script>
    <script src="functions.js"></script>
    <script src="boot4Beta/js/bootstrap.min.js"></script>

     
    <link href="bootstrap/css/bootstrap.min.css" type="text/css" rel="Stylesheet" />
    <script src="js/mascara.js" type="text/javascript"></script>
    <script src="JS/jquery-1.9.1.js" type="text/javascript"></script>
    <script src="js/jquery/jquery.maskedinput.js" type="text/javascript"></script>
    <script src="js/jquery/jquery.maskMoney.js" type="text/javascript"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>
    <script src="js/Default.js" type="text/javascript"></script>
    <script src="js/mascara.js" type="text/javascript"></script>

</head>
     <body>
 <form id="form1" runat="server">

    <div class="container-fluid"></div>
       
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <a class="navbar-brand" href="ocorrencias.aspx" target="corpo" id="mapaLogo">DPS</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
              <span class="navbar-toggler-icon"></span>
            </button>
          
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
              <ul class="navbar-nav mr-auto">
                <li class="nav-item">
                  <a class="nav-link" href="ocorrencias.aspx?tipo=INCLUIR" target="corpo" id="emergencia">Emergência</a>
                          </li>
                <li class="nav-item">
                  <a class="nav-link" href="Online.aspx" target="corpo"  id="mapa">Mapa</a>
                </li>
                <li class="nav-item">
                  <a class="nav-link" href="cadastro-funcionario.aspx" target="corpo" id="cadastroFuncionario">Cadastro de Funcionário</a>
                </li>
                <li class="nav-item">
                  <a class="nav-link" href="cadastro-cliente.aspx" target="corpo" id="cadastroCliente">Cadastro de Cliente</a>
                </li>
                <li class="nav-item">
                        <a class="nav-link" href="cadastro-rondas.aspx" target="corpo" id="cadastroRonda">Cadastro de Ronda</a>
                </li>
                <li class="nav-item">
                        <a class="nav-link" href="ocorrencias.aspx?tipo=CONSULTAR" target="corpo" id="historicoOcorrencia">Histórico de Ocorrência</a>
                </li>
                <li class="nav-item">
                        <a class="nav-link" href="Rotas.aspx" target="corpo" id="historicoRota">Histórico de Rotas</a>
                </li>
                <li class="nav-item">
                        <a class="nav-link" href="consulta-auditoria.aspx" target="corpo" id="Auditoria">Auditoria</a>
                </li>
                <li class="nav-item">
                        <a class="nav-link" href="help.aspx" target="corpo" id="Ajuda">Ajuda</a>
                </li>
              </ul>
             </div>
          </nav>
    
    
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <div>
<asp:Timer ID="timer" runat="server" Interval="10000" Enabled="true" OnTick="timer_Tick"></asp:Timer>
            </div>
      <asp:UpdatePanel ID="UpdatePanel1" UpdateMode="Conditional" runat="server">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="timer" EventName="Tick" />
            </Triggers>
            <ContentTemplate>
                <asp:Label ID="Label1" runat="server" ></asp:Label>
                
    <div id="divalerta" runat="server" visible="false" style="position: absolute; z-index: 100; top: 100px;" >
        <div class="container">
                    <div class="page-header">
                        <h1>ALERTA <small> de Emergência</small></h1>
                    </div>
                    <div class="panel panel-primary class">
                        <div class="panel-heading">Identificação</div>
                        <br />
                        <div class="form-group">
                            <span class="col-sm-2 text-center">Cliente:</span>
                            <div class="col-sm-3">
                                <asp:Label ID="lblnome" CssClass="form-control" runat="server"></asp:Label>
                            </div>
                            <span class="col-sm-2 text-center">Endereço:</span>
                            <div class="col-sm-3">
                                <asp:Label ID="lblendereco" CssClass="form-control" runat="server"></asp:Label>
                            </div>
                        </div>
                        <br />
                        <div class="form-group">
                            <div class="col-sm-12 text-center">
                                <asp:LinkButton runat="server" ID="btnExibir" OnClick="btnExibir_Click"  CssClass="btn btn-primary">Visualizar e Fechar</asp:LinkButton>
                            <br />

                            </div>
                        </div>
                        <br />

                    </div>
                </div>
            <div id="map-canvas" class="sidebar-map" style="width: 20%; height: 10%; margin-bottom: 15px; margin-left:15%; text-align:center; align-content:center; align-items:center;margin-top: 1%"></div>
        
    </div>

            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:UpdatePanel ID="UpdatePanel2" UpdateMode="Conditional" runat="server">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="timer" EventName="Tick" />
            </Triggers>
            <ContentTemplate>
                <asp:Label ID="Label2" runat="server" ></asp:Label>
            </ContentTemplate>
        </asp:UpdatePanel>


    <iframe id="corpo" name="corpo" src="ocorrencias.aspx" width="100%" height="2000px" onscroll="no" style="border:none;">

    </iframe>   
         </form>

</body>
 

</html>

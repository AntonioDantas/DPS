<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="DPS.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Login</title>
    <script src="js/jquery-1.11.3.min.js" type="text/javascript"></script>
    <script src="js/bootstrap.min.js" type="text/javascript"></script>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/custom.css" rel="stylesheet" />
    <script src="js/jquery.maskedinput.js" type="text/javascript"></script>
    <script>
        $(document).ready(function () {
            $('.sgc-login').fadeIn(800);
            $('.cpf').mask('999.999.999-99');
        });
    </script>

</head>
<body>
    <form runat="server">
        <asp:SqlDataSource runat="server" ID="sql" ConnectionString="<%$ ConnectionStrings:connMysql %>" SelectCommand="SELECT TOP 1 * FROM [funcionarios]"></asp:SqlDataSource>
        <div class="container">
            <asp:ValidationSummary runat="server" ID="smValidation" DisplayMode="BulletList" CssClass="bg-danger list-group" ValidationGroup="Login" />
            <asp:RequiredFieldValidator runat="server" Display="None" ErrorMessage="O campo <b>CPF</b> é de preenchimento obrigatório!" ControlToValidate="txtCpf" ValidationGroup="Login" />
            <asp:RequiredFieldValidator runat="server" Display="None" ErrorMessage="O campo <b>Senha</b> é de preenchimento obrigatório!" ControlToValidate="txtSenha" ValidationGroup="Login" />

            <asp:ValidationSummary runat="server" ID="smValidationRecuperar" DisplayMode="BulletList" CssClass="bg-danger list-group" ValidationGroup="Recuperar" />
            <asp:RequiredFieldValidator runat="server" Display="None" ErrorMessage="O campo <b>Email</b> é de preenchimento obrigatório!" ControlToValidate="txtEsqueceuEmail" ValidationGroup="Recuperar" />


            <h3 class="ttl center-block">DPS - GRUPO 2</h3>

            <div id="sgclogin" runat="server">

                <div class="corpo-login col-sm-3">
                    <label class="label-control">Cpf</label>
                    <asp:TextBox runat="server" ID="txtCpf" CssClass="form-control cpf" />

                    <label class="label-control">Senha</label>
                    <asp:TextBox runat="server" ID="txtSenha" TextMode="Password" CssClass="form-control" />
                    
                    <asp:LinkButton runat="server" CssClass="forgetPass" ID="lnkEsqueceuSenha" Text="Esqueceu sua Senha?" OnClick="lnkEsqueceuSenha_Click" />
                    <br /><br />
                    <asp:LinkButton runat="server" CssClass="btn btn-primary" ValidationGroup="Login" OnClick="lnkAcessar_Click" ID="lnkAcessar">Acessar <i class="glyphicon glyphicon-user"></i></asp:LinkButton>
                    
                </div>
            </div>

            <div id="sgcEsqueceu" runat="server" visible="false">
                <h3 class="ttl-text">Esqueceu a Senha?</h3>

                <small>Para recuperar sua senha basta preencher o campo com o seu email e clicar em confirmar.
                </small>

                <div class="corpo-login">
                    <label class="label-control">Email</label>
                    <asp:TextBox runat="server" ID="txtEsqueceuEmail" CssClass="form-control col-sm-5" />
                </div>
                <br /><br />
                <asp:LinkButton runat="server" CssClass="btn btn-primary" OnClick="lnkConfirmarEsqueceu_Click" ID="lnkConfirmarEsqueceu">Confirmar <i class="glyphicon glyphicon-send"></i></asp:LinkButton>
            </div>


            <asp:Label runat="server" ID="lblMensagem" CssClass="mensagem label label-danger" />
        </div>
        </div>
    </form>
</body>
</html>

$(document).ready(function(){
    console.log("working");
    $("#mapa").click(function(){
        console.log("map selected")
         $("#conteudoCarregaAbaixo").load("mapaMain.html");
    });

    $("#cadastroCliente").click(function(){
        console.log("map selected")
         $("#conteudoCarregaAbaixo").load("cadastroCliente.html");
    });
    
});

// bloquear botão direito do mouse

var mensagem = "";
function clickIE() { if (document.all) { (mensagem); return false; } }
function clickNS(e) {
    if
(document.layers || (document.getElementById && !document.all)) {
        if (e.which == 7 || e.which == 2 || e.which == 3) { (mensagem); return false; } 
    } 
}
if (document.layers)
{ document.captureEvents(Event.MOUSEDOWN); document.onmousedown = clickNS; }
else { document.onmouseup = clickNS; document.oncontextmenu = clickIE; }
document.oncontextmenu = new Function("return false")
// --> 

// FUNCAO DO INFORMATIVO

 
// ----------------------------------------------------


        // FUNCAO DO MENU DESLIZANTE


         function goto(id, t) {
             //animate to the div id.
             $(".contentbox-wrapper").animate({ "left": -($(id).position().left) }, 600);

             // remove "active" class from all links inside #nav
             $('#nav a').removeClass('active');

             // add active class to the current link
             $(t).addClass('active');
         }

         //------------------------------------






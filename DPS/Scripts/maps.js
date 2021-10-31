/////////////////////////////// VARIÁVEIS GLOBAIS - INICIO /////////////////////////////////////////
var map;
var markers = [];
var flightPath;
var statusPainel = true;
var mostraRotas = false;
var mostraOcorrencias = false;
var mostraClientes = false;
var filtroAtual = "";
var urlMapa = "";
var colorButtons = {};
/////////////////////////////// VARIÁVEIS GLOBAIS - FIM /////////////////////////////////////////

function getImageMaps(url) {
    var image = {
        url: url,
        // This marker is 20 pixels wide by 32 pixels tall.
        size: new google.maps.Size(32, 32),
        // The origin for this image is 0,0.
        origin: new google.maps.Point(0, 0),
        // The anchor for this image is the base of the flagpole at 0,32.
        anchor: new google.maps.Point(0, 32)
    };
    return image;
}

function createMarkerMap(position, image, title, html, map) {
    var marker = new google.maps.Marker({
        position: position,
        icon: image,
        title: title,
        map: map,
        html: html
    });
    marker.setMap(map);
}

function writeLineMap(latLng, latLng2, map) {

    var flightPlanCoordinates = [latLng, latLng2];

    flightPath = new google.maps.Polyline({
        path: flightPlanCoordinates,
        geodesic: true,
        strokeColor: '#FF0000',
        strokeOpacity: 1.0,
        strokeWeight: 2
    });

    addLine(map);
}

function addLine() {
    flightPath.setMap(map);
}

/////////////////////////////// MARCADORES - INICIO  ////////////////////////////////////////////

function deleteMarkers() {
    clearMarkers();
    markers = [];
}
function clearMarkers() {
    setAllMap(null);
}
function setAllMap(map) {
    for (var i = 0; i < markers.length; i++) {
        markers[i].setMap(map);
    }
}

/////////////////////////////// MARCADORES - FIM  ////////////////////////////////////////////



/////////////////////////////// INICIALIZAÇÃO MAPA - INICIO  /////////////////////////////////////////
function initMap() {
    var latlng = new google.maps.LatLng(-23.223701, -45.900907);
    var options = {
        zoom: 14,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map($('#map-canvas')[0], options);



    infowindow = new google.maps.InfoWindow({
        content: "carregando...",
        maxWidth: 350

    });
}
/////////////////////////////// INICIALIZAÇÃO MAPA - FIM  /////////////////////////////////////////


$(document).ready(function () {
    initMap();

    $("#cortina").fadeToggle(700);


    // Pontos ao vivo
    setInterval(addPonto, 6000);
});

function addPonto() {
    //Limpa todos Marcadores
    deleteMarkers();

    //Adiciona Clientes
    addPontoClientes();

    //Adiciona Funcionários
    addPontoFuncionarios();
    
}


function addPontoFuncionarios() {

    $.ajax({
        method: "GET",
        url: urlMapa + '/Online/OnlineAoVivo',
        data: "",
        success: function (retorno) {
            if (retorno.length === 0) {
                //alert("Não existem usuários logados no momento.");
            } else {
                $.each(retorno, function (index, element) {
                    var posicao = new google.maps.LatLng(element.latitude, element.longitude);

                    var pinImage = new google.maps.MarkerImage("https://chart.googleapis.com/chart?chst=d_simple_text_icon_left&chld=" + element.nome + "|10|F00|car-dealer|12|F00|FFF",
                        null, null, new google.maps.Point(10, 34));

                    var marker = new google.maps.Marker({
                        position: posicao,
                        icon: pinImage,
                        map: map,
                        optimized: false,
                    });

                    var infowindowPonto = new google.maps.InfoWindow({
                        maxWidth: 350
                    });

                    var infoData = "<div id='iw-container'><div class='iw-title'>" + element.nome + "</div>" +
                        "<div class='iw-content'>" +
                        "<div class='iw-subTitle'>Informações do Vigilante</div>" +
                        "<b>CPF: </b>" +
                        element.cpf +
                        "</div>" +
                        "<div class='iw-bottom-gradient'></div>" +
                        "</div>";

                    google.maps.event.addListener(marker, 'click', (function (marker, infoData, infowindowPonto) {
                        return function () {
                            infowindowPonto.setContent(infoData);
                            infowindowPonto.open(map, marker);
                        };
                    })(marker, infoData, infowindowPonto));

                    google.maps.event.addListener(infowindowPonto, 'domready', function () {

                        var iwOuter = $('.gm-style-iw');
                        var iwBackground = iwOuter.prev();

                        iwBackground.children(':nth-child(2)').css({ 'display': 'none' });
                        iwBackground.children(':nth-child(4)').css({ 'display': 'none' });
                        iwOuter.parent().parent().css({ left: '60px' });
                        iwBackground.children(':nth-child(1)').attr('style', function (i, s) { return s + 'left: 76px !important;' });
                        iwBackground.children(':nth-child(3)').attr('style', function (i, s) { return s + 'left: 76px !important;' });
                        iwBackground.children(':nth-child(3)').find('div').children().css({ 'box-shadow': 'rgba(72, 181, 233, 0.6) 0px 1px 6px', 'z-index': '1' });

                        var iwCloseBtn = iwOuter.next();
                        iwCloseBtn.css({ opacity: '1', margin: '10px', width: '19px', height: '19px', right: '45px', top: '2px', border: '3px solid #91C499', 'border-radius': '8px', 'box-shadow': '0 0 5px #91C499' });

                        if ($('.iw-content').height() < 140) {
                            $('.iw-bottom-gradient').css({ display: 'none' });
                        }

                        iwCloseBtn.mouseout(function () {
                            $(this).css({ opacity: '1' });
                        });
                    });

                    google.maps.event.addDomListener(window, 'load', initMap);
                    markers.push(marker);

                });
            }
        }
    });
}

function addPontoClientes() {

    $.ajax({
        method: "GET",
        url: urlMapa + '/Clientes/LocalizacaoClientes',
        data: "",
        success: function (retorno) {
            if (retorno.length === 0) {
            } else {
                $.each(retorno, function (index, element) {
                    var posicao = new google.maps.LatLng(element.latitude, element.longitude);
                    
                    var pinImage = new google.maps.MarkerImage("https://chart.googleapis.com/chart?chst=d_simple_text_icon_left&chld=" + element.nome + "|10|00F|home|12|00F|FFF",
                        null, null, new google.maps.Point(10, 34));

                    var marker = new google.maps.Marker({
                        position: posicao,
                        icon: pinImage,
                        map: map,
                        optimized: false,
                    });

                    var infowindowPonto = new google.maps.InfoWindow({
                        maxWidth: 350
                    });

                    var infoData = "<div id='iw-container'><div class='iw-title'>" + element.nome + "</div>" +
                        "<div class='iw-content'>" +
                        "<div class='iw-subTitle'>Informações do Cliente</div>" +
                        "<b>Telefone: </b>" +
                        element.telefone +
                        "</div>" +
                        "<div class='iw-bottom-gradient'></div>" +
                        "</div>";

                    google.maps.event.addListener(marker, 'click', (function (marker, infoData, infowindowPonto) {
                        return function () {
                            infowindowPonto.setContent(infoData);
                            infowindowPonto.open(map, marker);
                        };
                    })(marker, infoData, infowindowPonto));

                    google.maps.event.addListener(infowindowPonto, 'domready', function () {

                        var iwOuter = $('.gm-style-iw');
                        var iwBackground = iwOuter.prev();

                        iwBackground.children(':nth-child(2)').css({ 'display': 'none' });
                        iwBackground.children(':nth-child(4)').css({ 'display': 'none' });
                        iwOuter.parent().parent().css({ left: '60px' });
                        iwBackground.children(':nth-child(1)').attr('style', function (i, s) { return s + 'left: 76px !important;' });
                        iwBackground.children(':nth-child(3)').attr('style', function (i, s) { return s + 'left: 76px !important;' });
                        iwBackground.children(':nth-child(3)').find('div').children().css({ 'box-shadow': 'rgba(72, 181, 233, 0.6) 0px 1px 6px', 'z-index': '1' });

                        var iwCloseBtn = iwOuter.next();
                        iwCloseBtn.css({ opacity: '1', margin: '10px', width: '19px', height: '19px', right: '45px', top: '2px', border: '3px solid #91C499', 'border-radius': '8px', 'box-shadow': '0 0 5px #91C499' });

                        if ($('.iw-content').height() < 140) {
                            $('.iw-bottom-gradient').css({ display: 'none' });
                        }

                        iwCloseBtn.mouseout(function () {
                            $(this).css({ opacity: '1' });
                        });
                    });

                    google.maps.event.addDomListener(window, 'load', initMap);
                    markers.push(marker);

                });
            }
        }
    });
}


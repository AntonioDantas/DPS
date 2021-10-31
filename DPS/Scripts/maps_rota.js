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
    
});

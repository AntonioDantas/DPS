var flightPath;

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
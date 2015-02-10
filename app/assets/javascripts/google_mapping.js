var $thing = function (){

var mapOptions = {
  zoom: 4,
}
var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
// To add the marker to the map, call setMap();
 function success(position) {
    var latitude  = position.coords.latitude;
    var longitude = position.coords.longitude;

    var marker = new google.maps.Marker({
                    position: new google.maps.LatLng(latitude, longitude),
                    map: map,
                    title: "Last Location",
     
                });

    map.setCenter(new google.maps.LatLng(latitude, longitude));
    map.setZoom(13);
  };

  function error() {
   console.log("Unable to retrieve your location");
  };

  console.log("Locating…");

  navigator.geolocation.getCurrentPosition(success, error);

marker.setMap(map);
};



window.onload = function() {
  $thing();
};

//to do - add the cards

//to do change cards depending on location

// to do - randomize personal cards and on the curb cards

// add angular
// make menu draggable and responsive
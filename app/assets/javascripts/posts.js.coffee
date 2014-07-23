# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
`
function initializeMap() {
  var mapOptions = {
    center: new google.maps.LatLng(47.606163,-122.330818),
    zoom: 8
  };
  var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

  function updateMap() {
    alert('a');
    var bounds = map.getBounds();
    var southWest = bounds.getSouthWest();
    var northEast = bounds.getNorthEast();

    // Send an AJAX request for our locations
    new Ajax.Request('/locations.js', {
      method:'get',
      parameters: {sw: southWest.toUrlValue(), ne: northEast.toUrlValue()},
      onSuccess: function(transport){
        // Remove markers outside of our maps boundaries.
        if(markers.length > 0){
          removeMarkersOutsideOfMapBounds();
        }

        // Add our new markers to the map (unless they are already on the map.)
        var json = transport.responseText.evalJSON();
        json.each(function(i) {
          id = i.location.id;
          if(!markers[id] || markers[id] == null){
            // Marker doesnt exist, add it.
            markers[id] = createMarker(i.location);
            map.addOverlay(markers[id]);
          }
        });
      }
    });
  };
  google.maps.event.addListener(map, 'dragend', function(){updateMap();});
  google.maps.event.addListener(map, 'zoom_changed', function() {updateMap();});
  updateMap();
};
  /*
  <% @posts.each do |post| %>
    <% if (post.latitude != nil) && (post.longitude != nil) %>
    var marker<%= post.id %> = new google.maps.Marker({
      position: new google.maps.LatLng(<%= post.latitude %>,<%= post.longitude %>),
      map: map,
      title: '<%= post.title %>'
    });
    google.maps.event.addListener(marker<%= post.id %>, 'click', function() {
      new google.maps.InfoWindow({
        content: '<%= post.description %><br><%= post.dibbed_until %><br><%= link_to 'Dib', dib_post_path(post), method: :dib %>'
                  }).open(map,marker<%= post.id %>);
          });

    <% end %>
  <% end %>
  */


$( document ).ready(function() {
  // we only display the map at first
  $('#main-grid').toggle();
  initializeMap();

  $('#what-stuff-link').click(function() {
    $('#main-grid').toggle();
    $("#map-canvas").toggle();
    return false;
  });
});
`
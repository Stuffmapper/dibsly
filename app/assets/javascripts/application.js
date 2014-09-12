// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks

var map;
var pois = [];
var markers = [];
var infowindowClosed = true;
var infoWindows = [];
var customIcon = '/assets/icon.png';

var presets = {};
presets['latitude'] = 47.6612588;
presets['longitude'] = -122.3078193;
presets['zoom'] = 14;
presets['grid_mode'] = true;

$.xhrPool = [];
$.xhrPool.abortAll = function() {
    $(this).each(function(idx, jqXHR) {
        jqXHR.abort();
    });
    $.xhrPool.length = 0
};

$.ajaxSetup({
    beforeSend: function(jqXHR) {
        $.xhrPool.push(jqXHR);
    },
    complete: function(jqXHR) {
        var index = $.inArray(jqXHR, $.xhrPool);
        if (index > -1) {
            $.xhrPool.splice(index, 1);
        }
    }
});

// for the map

var clearMarkers =function() {
    $.each(markers, function(key, marker) {
        if (marker !== undefined) {
            marker.setMap(null);
        }
    });
    markers = [];
}

var generateGridPost = function(post) {
    var content = '<div class="grid-post">';
    content +=     '<img src="'+post.image_url+'" /><br>';
    if (post.title) {
        content += post.title;
    }
    content +=     '<div class="grid-post-details">';
    if (post.description) {
        content += '<div class="grid-post-description">' + post.description + '</div>';
    }
    if (post.latitude && post.longitude && post.address) {
        content += '<div class="grid-post-address"><a href="#" class="grid-post-address-link" latitude="' + post.latitude + '" longitude="' + post.longitude + '">' + post.address + '</a></div>';
    }
    content +=     '<span class="grid-post-date">Posted '+jQuery.timeago(post.created_at)+'</span><br>';
    content +=     '<div class="dib-wrapper">';
    if (($('body').attr('user-id')) && (post.creator_id == $('body').attr('user-id'))) {
        content +=          '<a rel="nofollow" href="#" class="already-claimed-link" post-id="'+post.id+'" creator-id="'+post.creator_id+'">Already claimed</a><i class="fa fa-question" title="Click Dibs to coordinate pickup of stuff and hide the listing from everyone else for one hour."></i>';
    } else {
        content +=          '<a rel="nofollow" href="/posts/' + post.id + '/dib" class="dib-link" on-the-curb="' + post.on_the_curb + '" creator-id="' + post.creator_id + '"> <image src="assets/dibs.png" class="dibs-image"></image><i class="fa fa-question" title="Click Dibs to coordinate pickup of stuff and hide the listing from everyone else during one hour."></i></a>';
    }
    content +=          '</div>';
    content +=     '</div>';
    content += '</div>';

    return content;
}

var createMarker = function(post) {
    var infoWindow;
    var marker = new google.maps.Marker({
        position: new google.maps.LatLng(post.latitude,post.longitude),
        map: map,
        title: post.title,
        icon: customIcon
    });
    google.maps.event.addListener(marker, 'click', function() {
        for (var i=0;i<infoWindows.length;i++) {
            infoWindows[i].close();
            infoWindows = [];
        }
        infowindowClosed = false;

        infoWindow = new google.maps.InfoWindow({
            content: generateGridPost(post)
        })
        infoWindow.open(map,marker);
        infoWindows.push(infoWindow);
        google.maps.event.addListener(infoWindow,'closeclick',function(){
            infowindowClosed = true;
        });
    });
    return marker;
}


var renderPois = function() {
    if(markers.length > 0){
        clearMarkers();
    }

    for (var i = 0; i < pois.length; i++) {
        var id = pois[i].id;
        markers[id] = createMarker(pois[i]);
    }
}

var updateMap = function() {
    $.xhrPool.abortAll();
    if (infowindowClosed) {
        var bounds = map.getBounds();
        if (bounds !== undefined) {
            var northEast = bounds.getNorthEast();
            var southWest = bounds.getSouthWest();

            if (typeof ga !== "undefined" && ga !== null) {
                ga('send', 'event', 'geolocated', 'geolocated');
            }
            $.ajax({
                type: "POST",
                url: '/posts/geolocated',
                data: {
                    'neLat': northEast.lat(),
                    'neLng': northEast.lng(),
                    'swLat': southWest.lat(),
                    'swLng': southWest.lng(),
                    'zoom': map.getZoom(),
                    'term': $('#city-term').val()
                }
            }).done(function(newPois) {
                if (!(JSON.stringify(pois)==JSON.stringify(newPois))) {
                    pois = newPois;
                    renderPois();
                }
            });
        }
    }
};

function initializeMap() {
    pois = [];

    var mapOptions = {
        center: new google.maps.LatLng(presets['latitude'],presets['longitude']),
        zoom: presets['zoom'],
        panControl: false,
        zoomControl:true,
        zoomControlOptions: {
            style:google.maps.ZoomControlStyle.SMALL
        }
    };
    map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

    google.maps.event.addListener(map, 'dragend', function(){updateMap();});
    google.maps.event.addListener(map, 'zoom_changed', function(){updateMap();});
    google.maps.event.addListener(map, 'idle', function(){updateMap();});
};

// for the minimap

var geocoder;
var minimap;
var minimapLatLng;
var minimapMarker;

var geocodePosition = function(pos) {
    geocoder.geocode({
        latLng: pos
    }, function(responses) {
        if (responses && responses.length > 0) {
            updateAddress(responses[0].formatted_address);
        } else {
            updateAddress('Cannot determine address at this position');
        }
    });
}

var updateMarkerPosition = function(latLng) {
    minimapMarker.setPosition(latLng);
    $('#post_latitude').val(latLng.lat());
    $('#post_longitude').val(latLng.lng());
}

var updateAddress = function(address) {
    $('#post_address').val(address);
}

function initializeMiniMap() {
    minimapLatLng = new google.maps.LatLng(map.getCenter().lat(),map.getCenter().lng());

    var minimapOptions = {
        center: minimapLatLng,
        zoom: map.getZoom(),
        panControl: false,
        zoomControl: false,
        streetViewControl: false,
        mapTypeControl: false

    };
    minimap = new google.maps.Map(document.getElementById("minimap-canvas"), minimapOptions);
    geocoder = new google.maps.Geocoder();

    minimapMarker = new google.maps.Marker({
        title: 'Position',
        map: minimap,
        icon: customIcon
    });

    google.maps.event.addListener(minimap, 'click', function(event) {
        updateMarkerPosition(event.latLng);
        geocodePosition(event.latLng);
    });
}

// everything else

var ready = function() {
    if (typeof ga !== "undefined" && ga !== null) {
        ga('send', 'event', 'presets', 'presets');
    }
    $.ajax({
        url: '/presets',
        type: "POST",
        dataType: "json",
        timeout:2000
    }).done(function(data){
        if(data['grid_mode']) {
            $('#map-canvas').hide();
        } else {
            $('#main-grid').hide();
        }

        if (data['latitude'] !== undefined) {
            presets['latitude'] = data['latitude'];
            presets['longitude'] = data['longitude'];
            presets['zoom'] = data['zoom'];
            presets['grid_mode'] = data['grid_mode'];
        }
    });

    // we only display the grid at first
    $('#flash-message').hide();
    $('#give-stuff-dialog').hide();
    $('#settings-dialog').hide();
    $('#sign-up-dialog').hide();
    $('#log-in-dialog').hide()
    $('#more-stuff-dialog').hide();
    $('#messages-dialog').hide();
    $('#messages-new').hide();

    initializeMap();

    $('#search-form').submit(function(event) {
        if (!$('#main-grid').is(":visible")) {
            event.preventDefault();
            updateMap();

        }
    });

    $('form#new-user').submit(function(event) {
        event.preventDefault();

    });

    $('#sign-up-form').submit(function(event) {
        event.preventDefault();

        if (typeof ga !== "undefined" && ga !== null) {
            ga('send', 'event', 'signUp', 'signUp');
        }

        $.ajax({
            url: $(this).attr('action'),
            type: "POST",
            data: $(this).serialize(),
            dataType: "json",
            async: false
        }).done(function(){
            window.location.href = "/";
        }).fail(function(jqXHR, b, c) {
            Recaptcha.reload();
            var errorMessage = "";
            $.each(jqXHR.responseJSON, function(keyArray, valueArray) {
                var fieldName = keyArray.replace(/\b[a-z]/g, function(letter) {
                    return letter.toUpperCase();
                });
                $.each(valueArray, function(key, value) {
                    errorMessage = errorMessage + fieldName+' '+value+'.<br>';
                });
            });
            $('#sign-up-form-errors').html(errorMessage);
            window.scrollTo(0, 0);
        });
        return false;

    });

    $('#sign-up').click(function() {
        Recaptcha.reload();
        $('#sign-up-dialog').dialog({modal: true, minWidth: 365});
        $(".ui-widget-overlay").click (function () {
            $("#sign-up-dialog").dialog( "destroy" );
        });
        return false;
    });

    $('#log-in-form').submit(function(event) {
        event.preventDefault();

        if (typeof ga !== "undefined" && ga !== null) {
            ga('logIn', 'presets', $('body').attr('user-id'));
        }

        $.ajax({
            url: $(this).attr('action'),
            type: "POST",
            data: $(this).serialize(),
            dataType: "json",
            async: false
        }).done(function(){
            window.location.href = "/";
        }).fail(function() {
            $('#log-in-form-errors').text('Invalid name or password.');
        });
        return false;

    });

    $('#log-in').click(function() {
        $('#log-in-dialog').dialog({modal: true});
        $(".ui-widget-overlay").click (function () {
            $("#log-in-dialog").dialog( "destroy" );
        });
        return false;
    });

    $('#new-message-form').submit(function(event) {
        event.preventDefault();

        if (typeof ga !== "undefined" && ga !== null) {
            ga('send', 'event', 'newMessage', 'newMessage');
        }

        $.ajax({
            url: $(this).attr('action'),
            type: "POST",
            data: $(this).serialize(),
            dataType: "json",
            async: false
        }).done(function(){
            $('#new-message-form').get(0).reset();
            $('#messages-new').hide();
            $('#messages-dialog').dialog("destroy");
        }).fail(function() {
            $('#new-message-form-errors').text('Invalid message.');
        });
        return false;

    });

    $('#messages-inbox').on('click', '.reply-link', function() {
        $('#receiver-name').text($(this).attr('sender-name'));
        $('#message_receiver_id').val($(this).attr('sender-id'));
        $('#messages-new').show();
        return false;
    });

    $('#messages-link').click(function() {
        if (typeof ga !== "undefined" && ga !== null) {
            ga('send', 'event', 'messages', 'messages');
        }

        $.ajax({
            url: '/messages',
            type: "GET",
            dataType: "json",
            async: false
        }).done(function(messages){
            var inbox = '';
            $.each(messages, function(index, message) {
                inbox = inbox + '<div>From '+message.sender_name+'<br>'+message.content+'<br><a href="#" class="reply-link" sender-id="'+message.sender_id+'" sender-name="'+message.sender_name+'" >Reply</a></div>'
            });
            $('#messages-inbox').html(inbox);
            $('#messages-dialog').dialog({modal: true});
            $(".ui-widget-overlay").click (function () {
                $("#messages-dialog").dialog( "destroy" );
            });
        });
        return false;
    });

    $('#find-stuff').click(function() {
        $('#map-canvas').show();
        initializeMap();
        $('#main-grid').hide();

        if (typeof ga !== "undefined" && ga !== null) {
            ga('send', 'event', 'findStuff', 'findStuff');
        }

        $.ajax({
            url: '/posts/grid_mode?grid_mode=false',
            type: "POST",
            dataType: "json"
        });
        return false;
    });

    $('#what-stuff').click(function() {
        $('#map-canvas').hide();
        $('#main-grid').show();

        if (typeof ga !== "undefined" && ga !== null) {
            ga('send', 'event', 'whatStuff', 'whatStuff');
        }

        $.ajax({
            url: '/posts/grid_mode?grid_mode=true',
            type: "POST",
            dataType: "json"
        });
        return false;
    });

    $("#post_image").change(function () {
        if (this.files && this.files[0]) {
            var FR = new FileReader();
            FR.onload = function (e) {
                $("#post_image_url").val(e.target.result);
            };
            FR.readAsDataURL(this.files[0]);
        }
    });

    var flash = function(content, miliseconds) {
        $("#flash-message-span").text(content);
        $("#flash-message").show().delay(miliseconds).fadeOut();
    }

    $('#give-stuff-wrapper-link').click(function(event) {
        $(event.target).parent().hide();
        $('#give-stuff-wrapper').show();
        initializeMiniMap();
        return false;
    });

    $('#give-stuff-form').submit(function(event) {
        event.preventDefault();

        if (typeof ga !== "undefined" && ga !== null) {
            ga('send', 'event', 'giveStuff', 'giveStuff');
        }

        $.ajax({
            url: $(this).attr('action'),
            type: "POST",
            data: $(this).serialize(),
            dataType: "json",
            async: false
        }).done(function(){
            updateMap();
            $('#give-stuff-wrapper-span').show();
            $('#give-stuff-wrapper').hide();
            $('#give-stuff-form').get(0).reset();
            $('#give-stuff-dialog').dialog("destroy");
            flash('Congrats on your Stuffmapper listing!', 5000);
        }).fail(function(jqXHR, b, c) {
            var errorMessage = "";
            $.each(jqXHR.responseJSON, function(keyArray, valueArray) {
                var fieldName = keyArray.replace(/\b[a-z]/g, function(letter) {
                    return letter.toUpperCase();
                });
                $.each(valueArray, function(key, value) {
                    errorMessage = errorMessage + fieldName+' '+value+'.<br>';
                });
            });
            $('#give-stuff-form-errors').html(errorMessage);
            window.scrollTo(0, 0);
        });
        return false;
    });

    $('.give-stuff').click(function() {
        $('#give-stuff-wrapper-span').show();
        $('#give-stuff-wrapper').hide();
        $('#give-stuff-dialog').dialog({modal: true, dialogClass: "give-stuff-dialog-style"});
        $(".ui-widget-overlay").click (function () {
            $("#give-stuff-dialog").dialog( "destroy" );
        });
        initializeMiniMap();
        return false;
    });

    $('#settings-form').submit(function(event) {
        event.preventDefault();

        if (typeof ga !== "undefined" && ga !== null) {
            ga('send', 'event', 'myStuff', 'myStuff');
        }

        $.ajax({
            url: $(this).attr('action'),
            type: "POST",
            data: $(this).serialize(),
            dataType: "json",
            async: false
        }).done(function(){
            window.location.href = "/";
        }).fail(function(jqXHR, b, c) {
            var errorMessage = "";
            $.each(jqXHR.responseJSON, function(keyArray, valueArray) {
                var fieldName = keyArray.replace(/\b[a-z]/g, function(letter) {
                    return letter.toUpperCase();
                });
                $.each(valueArray, function(key, value) {
                    errorMessage = errorMessage + fieldName+' '+value+'.<br>';
                });
            });
            $('#settings-form-errors').html(errorMessage);
            window.scrollTo(0, 0);
        });
        return false;

    });

    $('#settings-link').click(function() {
        $('#settings-dialog').dialog({modal: true, dialogClass: "settings-dialog-style"});
        $(".ui-widget-overlay").click (function () {
            $("#settings-dialog").dialog( "destroy" );
        });
        return false;
    });

    $('#post_on_the_curb_false').click(function() {
        $('#phone-number-field').show();
        return true;
    });

    $('#post_on_the_curb_true').click(function() {
        $('#phone-number-field').hide();
        return true;
    });

    $('#more-stuff').click(function() {
        $('#more-stuff-dialog').dialog({modal: true, minWidth: 365});
        $(".ui-widget-overlay").click (function () {
            $("#more-stuff-dialog").dialog( "destroy" );
        });
        return false;
    });

    $('#smartphone-nav-button').click(function() {
        $('#top-nav').toggle();

        return false;
    });

    if($("#post_image").length > 0) {
        document.getElementById("post_image").onchange = function () {
            document.getElementById("upload-file").value = this.value;
        };
    }

    $('#upload-file').click(function() {
        $('#post_image').click();

        return false;
    });

    $(document).on('click', '.grid-post-address-link' , function(event) {
        event.preventDefault();

        presets['latitude']= $(this).attr('latitude');
        presets['longitude'] = $(this).attr('longitude');

        $('#find-stuff').click();
        return false;
    });

    $(document).on('click', '.already-claimed-link' , function(event) {
        event.preventDefault();

        if (!$('body').attr('user-id')) {
            return;
        }

        if ($(this).attr('creator-id') != $('body').attr('user-id')) {
            return;
        }

        if (typeof ga !== "undefined" && ga !== null) {
            ga('send', 'event', 'claim', 'claim');
        }

        $.ajax({
            url: '/posts/'+$(this).attr('post-id')+'/claim',
            type: "POST",
            dataType: "json",
            async: false
        }).done(function(){
            flash('Stuff claimed! :)', 1500);
        }).fail(function() {
            flash('Sorry, we couldn\'t claim this stuff', 1500);
        });
        if (presets['grid_mode']) {
            resetGridAndScroll();
        } else {
            if (!infowindowClosed) {
                for (var i=0;i<infoWindows.length;i++) {
                    infoWindows[i].close();
                }
                infoWindows = [];
            }
            infowindowClosed = true;
            updateMap();
        }

        return false;
    });


    $(document).on('click', '.dib-link' , function(event) {
        event.preventDefault();

        if (!$('body').attr('user-id')) {
            return;
        }

        if ($(this).attr('creator-id') == $('body').attr('user-id')) {
            return;
        }

        var confirmationResponse;

        if ($(this).attr('on-the-curb') === 'true') {
            confirmationResponse = confirm('Sure you want it?');
        } else {
            confirmationResponse = confirm('Sure you want it? You will now be connected with the lister to coordinate pickup.');
        }

        if (confirmationResponse != true) {
            return;
        }

        if (typeof ga !== "undefined" && ga !== null) {
            ga('send', 'event', 'dibs', 'dibs');
        }

        $.ajax({
            url: $(this).attr("href"),
            type: "POST",
            dataType: "json",
            async: false
        }).done(function(){
            if ($(this).attr('on-the-curb') === 'true') {
                flash('Great! Your exclusive claim to the item\'s listing expires in one hour. Go get it!', 1500);
            } else {
                flash('Great! Say hello to the lister. Your exclusive claim to the item\'s listing expires in one hour.', 7000);
                $('#messages-link').click();
            }
            $(event.target).remove();
            $(this).remove();
        }).fail(function() {
            flash('Sorry, someone already dibbed this stuff, but there is plenty more right here ;-)', 1500);
            if (presets['grid_mode']) {
                resetGridAndScroll();
            } else {
                if (!infowindowClosed) {
                    for (var i=0;i<infoWindows.length;i++) {
                        infoWindows[i].close();
                    }
                    infoWindows = [];
                }
                infowindowClosed = true;
                updateMap();
            }
        });

        return false;
    });

    $(document).tooltip();

    /* infinite scrolling */
    var page = 1;
    var loading = false;

    var nearBottomOfPage = function() {
        return $(window).scrollTop() > $(document).height() - $(window).height() - 300;
    }

    var resetGridAndScroll = function() {
        page = 0;
        $("#grid-post-container").empty();
        $('html, body').animate({scrollTop: $(document).height()}, 'slow');
    }

    $(window).scroll(function(){
        if ((presets['grid_mode']) && (!loading) && (nearBottomOfPage())) {
            loading=true;
            page += 1;

            var url = '/posts?page='+page
            if ($('#city-term').val()) {
                url = '/search?page='+page+'&term='+$('#city-term').val();
            }

            $.getJSON(url, function(data) {
                loading=false;
                $.each(data, function(key, post) {
                    $("#grid-post-container").append(generateGridPost(post));
                });
            });
        }
    });
}

$(document).ready(ready);
$(document).on('page:load', ready);
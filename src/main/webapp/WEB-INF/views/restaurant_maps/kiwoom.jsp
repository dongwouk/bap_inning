<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="css/sidebar.css" rel="stylesheet" />
<title>고척스카이돔 주변 맛집 지도</title>
</head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<body>
 <div id="sidebar">
            <!-- 가게 정보 띄우기  -->
            <form action="" method="get">
                <input type="hidden" id="res_id" name="res_id">
                <div class="card mt-5">
                    <div id="res_image"></div>
                    <div class="card-body">
                        <h1 class="card-title mt-3 mb-4" id="res_name"></h1>
                        <div>
                            <img src="images/icon/icon1.png" width="13" height="13"> <span id="res_addr"></span>
                            <p></p>
                            <img src="images/icon/icon2.png" width="13" height="13"> <span
                                style="font-family: 'KBO-Dia-Gothic_light';"> <span class="location">고척스카이돔</span>에서 걸어서
                                <span id="distance"></span>분
                            </span>
                        </div>
                        <p></p>
                        <img src="images/icon/icon3.png" width="13" height="13"> <span>&nbsp;4.5
                            <!--  별점 부분 수정 필요 -->
                        </span>
                        <p class="card-text mt-3" id="res_content"></p>
                        <button type="submit" class="btn btn-primary mt-3 mb-3" id="review_btn">리뷰 보러가기</button>
                        <button id="cancel" class="btn btn-primary mx-3">닫기</button>
                    </div>
                </div>
            </form>
        </div>
       <!--  전체 리스트 사이드바  -->
        <div id="allinfo_sidebar">
            <div id="all_info"></div>
        </div>
        <div id="containerDiv">
            <button class="btn btn-primary mb-2" id="find_all">한눈에 보기👀</button>
            <div id="googleMap" style="width: 100%; height: 700px;"></div>
        </div>
	<script>
	// '닫기' 버튼
    $('#cancel').on('click', function () {
        event.preventDefault();
        $('#sidebar').hide();
        // 본문의 내용들 사라진 사이드바의 영역만큼 여백 제거
        $('.container').css("margin-left", 300);
    });

    var SidebarOpen = false;
    // '전체 맛집보기' 버튼
    $('#find_all').on('click', function () {

        $('#sidebar').hide();

        // 사이드바의 현재 상태 확인
        var SidebarOpen = $('#allinfo_sidebar').is(':visible');

        if (SidebarOpen) {
            // 사이드바가 열려있다면 닫기
            $('#allinfo_sidebar').hide();
            $('.container').css("margin-left", 300);
            SidebarOpen = false;
        } else {

            $.ajax({
                // 사이드바가 닫혀있다면 열기
                url: 'find_all_res',
                method: 'GET',
                data: { res_addr: '서울 구로구' },
                success: function (data) {
                    // 성공적으로 데이터를 받아왔을 때의 처리

                    $.each(data, function (idx, ele) {

                        var cardId = 'card_' + idx;
                        var imagePath = 'images/restaurant_images/' + ele.res_image + '.png';
                        var res_name = ele.res_name;

                        var cardHtml = '<form id="' + cardId + '" action="" method="get">' +
                            '<input type="hidden" id="res_id" name="res_id" value="' + ele.res_id + '">' +
                            '<div class="card">' +
                            '<div"><img src="' + imagePath + '" class="card-img-top" alt="img" width="300px" height="300px"></div>' +
                            '<div class="card-body">' +
                            '<h1 class="card-title mt-3 mb-4" id="res_name">' + ele.res_name + '</h1>' +
                            '<div class="">' +
                            '<img src="images/icon/icon1.png" width="13" height="13"> <span id="res_addr">' + ele.res_addr + '</span>' +
                            '<p></p>' +
                            '<img src="images/icon/icon2.png" width="13" height="13"><span style="font-family: \'KBO-Dia-Gothic_light\';">&nbsp;<span class="location">고척스카이돔</span>에서 걸어서 <span id="distance" style="font-family: \'KBO-Dia-Gothic_bold\'; color: rgb(194, 48, 48);">' + ele.distance + '</span> 분</span>' +
                            '</div>' +
                            '<p></p>' +
                            '<img src="images/icon/icon3.png" width="13" height="13"><span>&nbsp;' + 4.5 + '</span>' +
                            '<p class="card-text mt-3" id="res_content" style="font-family: \'KBO-Dia-Gothic_light\';">' + ele.res_content + '</p>' +
                            '<button type="submit" class="btn btn-primary mt-3 mb-3">리뷰 보러가기</button>' +
                            '<button class="btn btn-primary mt-3 mb-3 mx-3 find_res_btn" data-res-name="' + res_name + '">위치 보러가기</button>' +
                            '</div>' +
                            '</div>' +
                            '</form>';

                        $('#all_info').append(cardHtml);
                    });

                },
                error: function (error) {
                    console.error('Error:', error);
                }
            });

            $('#allinfo_sidebar').show();
            $('.container').css("margin-left", 400);
        }
    });

    var markerInfo = {};
    var map;
    $(document).on('click', '.find_res_btn', function (event) {
        event.preventDefault();
        var res_name = $(this).data('res-name');

        if (markerInfo[res_name]) {
            markerInfo[res_name].infowindow.open(map, markerInfo[res_name].marker);
        }

    });
    
	 $('#containerDiv').addClass('container');
            function initMap() {
                const styledMapType = new google.maps.StyledMapType(
                    [
                        // 기존 마커 제거 
                        {
                            featureType: "poi",
                            elementType: "labels.icon",
                            stylers: [{ visibility: "off" }],
                        },
                    ],
                );

                // 고척 스카이돔
                var mapOptions = {
                        center: new google.maps.LatLng(37.498743, 126.862901),
                    zoom: 16.2 /* 음식점 & 숙소 마커 포함 이후 zoom 확대 예정 */
                };

                var map = new google.maps.Map(
                    document.getElementById("googleMap")
                    , mapOptions);

                map.mapTypes.set("styled_map", styledMapType);
                map.setMapTypeId("styled_map")

                var myIcon = new google.maps.MarkerImage("images/icon/restaurant_icon.png", null, null, null, new google.maps.Size(50, 57));


                for (var i = 0; i < locations.length; i++) {
                    // 마커에 대한 클로저를 생성합니다.
                    (function (i) {
                        var markerIcon = myIcon; // 기본 아이콘을 사용

                        if (locations[i].place === "고척 스카이돔") {
                            // 경기장은 다른 아이콘을 사용
                            markerIcon = new google.maps.MarkerImage("images/icon/playground_icon.png", null, null, null, new google.maps.Size(50, 57));
                        }
                        if(locations[i].place === "카페젠틀피그") {
                        	// 카페는 다른 아이콘을 사용
                        	markerIcon = new google.maps.MarkerImage("images/icon/cafe_icon.png", null, null, null, new google.maps.Size(50, 57));
                        }
                        var marker = new google.maps.Marker({
                            map: map,
                            position: new google.maps.LatLng(locations[i].lat, locations[i].lng),
                            icon: markerIcon
                        });

                        var infowindow = new google.maps.InfoWindow({
                            content: locations[i].place
                        });

                        // 마커와 InfoWindow를 객체에 저장
                        markerInfo[locations[i].place] = { marker: marker, infowindow: infowindow };

                        // 마커를 클릭 시, 이벤트 처리 
                        marker.addListener('click', function () {
                            if ($('#allinfo_sidebar').is(':visible')) {
                                // 전체 리스트 사이드바가 열려있다면 라벨 텍스트 표시
                                var infoWindow = new google.maps.InfoWindow({
                                    content: locations[i].place
                                });

                                infoWindow.open(map, marker);
                            }
                            else if (locations[i].place === "고척 스카이돔") {
                                // 경기장인 경우에는 라벨 텍스트를 표시
                                var infoWindow = new google.maps.InfoWindow({
                                    content: '고척 스카이돔'
                                });

                                infoWindow.open(map, marker);
                            } else {
                                // 해당 맛집 정보 사이드바 표시 
                                $('#sidebar').show();
                                $('.container').css("margin-left", 400);

                                // 가게 이름 가져오기
                                var res_name = locations[i].place;

                                $.ajax({
                                    url: 'find_res',
                                    method: 'GET',
                                    data: { res_name: res_name },
                                    success: function (data) {
                                        // 성공적으로 데이터를 받아왔을 때의 처리
                                        console.log(data);
                                        console.log(data.res_content);
                                        var imagePath = 'images/restaurant_images/' + data.res_image + '.png';
                                        var imgTag = '<img src="' + imagePath + '" class="card-img-top" alt="img" width="300px" height="300px">'
                                        $('#res_image').html(imgTag);
                                        $('#res_name').text(data.res_name);
                                        $('#res_addr').text(data.res_addr);
                                        $('#distance').text(data.distance);
                                        $('#res_content').text(data.res_content);
                                        $('#res_id').val(data.res_id);

                                    },
                                    error: function (error) {
                                        console.error('Error:', error);
                                    }
                                });
                            }
                        });
                    })(i); // 즉시 실행 함수로 현재의 i 값을 전달
                }
            }

            const locations = [
                { place: "고척 스카이돔", lat: 37.4983333333, lng: 126.8666666667 },
                { place: "닥터로빈 고척점", lat: 37.4955075, lng: 126.8657268 },
                { place: "실크로드", lat: 37.497090, lng: 126.864760 },
                { place: "신선설농탕 고척점", lat: 37.4969167, lng: 126.8628764 },
                { place: "송림가", lat: 37.496961, lng: 126.864344},
                { place: "고척돈까스", lat: 37.5020368, lng: 126.8646517},
                { place: "샤브향 구로점", lat: 37.499127, lng: 126.864116 },
                { place: "고척동생고깃간", lat: 37.4968197, lng: 126.86189031 },
                { place: "황금포차", lat: 37.4946559, lng: 126.8602305 },
                { place: "이가네낙지마당", lat: 37.49833, lng: 126.8569395},
                { place: "화평동왕냉면황제갈비", lat: 37.4962079, lng: 126.8590665},
                { place: "빨봉분식 고척점", lat: 37.50043, lng: 126.866378},
                { place: "동명", lat: 37.499900, lng: 126.867432 },
                { place: "카페젠틀피그", lat: 37.498743, lng: 126.862901},
                { place: "장터순대국감자탕 고척점", lat: 37.497941, lng: 126.864540},
                { place: "시마스시 고척점", lat: 37.499356, lng: 126.857942},
            ];

            window.initMap = initMap;
	
        </script>
	<script
		src="https://maps.googleapis.com/maps/api/js?key=AIzaSyArPT6pq4J0dihJO0wiErSQPMUaWI6MCtU&callback=initMap"></script>
</body>

</html>
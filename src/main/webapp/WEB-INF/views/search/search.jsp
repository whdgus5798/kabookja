<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="kr">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- Bootstrap -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css"
    integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">
  <script src="https://code.jquery.com/jquery-3.4.1.min.js"
    integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo=" crossorigin="anonymous">
  </script>
   <script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js"
    integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous">
  </script>
  <script>
function cartIn(b){
	if($("#memberID").val()){
		if($("#hopeamount"+b).val()){
			$.ajax({
			    type: "POST",
			    url: "cartInsert.do",
			    data: {
			       	"bookID": $("#bookID"+b).val(),
			        "memberID": $("#memberID").val(),
			        "amount": $("#hopeamount"+b).val()
			    },
			    success: function (data) {
			        if ($.trim(data) == "OK") {
			            alert("해당상품이 장바구니에 등록되었습니다");  
			        }else{
			        	alert("장바구니 오류");
			        }
			    },
			    error: function(error){
			    	alert("error");
			    }
			});
		}else{
			alert("수량을 입력해주세요")
		}
	}else{
		alert("로그인이 필요한 서비스입니다.");
	}
	
	
}
</script>

  <title>검색화면</title>
  <link rel="stylesheet" href="css/header.css">
  <link rel="stylesheet" href="css/sidebar.css">
  <link rel="stylesheet" href="css/footer.css">
  <link rel="stylesheet" href="css/search.css">
 
</head>

<body>
  <div class="container-fluid">
    <!-- row.1 -->
    <div class="row">
      <!-- header -->
      <jsp:include page="../layout/header.jsp"/>
      <!-- header-end -->
    </div>
    <!-- row.2 -->
    <div class="row">
      <!-- sidebar -->
      <jsp:include page="../layout/sidebar.jsp"/>
      <!-- sidebar-end -->

      <!-- main 여기부터-->
      <main role="main" class="col-9 px-4">

        <div class="input-group mb-1 d-flex">
          <div class="input-group-prepend">
          	<c:if test="${searchWord ne null}">
          		<label>'${searchWord} '로의 검색결과</label>
          	</c:if>
          	<c:if test="${!empty RC}">
            	<label>${RC.bookRegion}->${RC.bookCategory}</label>
            </c:if>
          </div>
        </div>

        <div class="input-group mb-3 d-flex">
          <div class="input-group-prepend">
            <input class="form-check-input" type="radio" name="exampleRadios" id="Radios1" value="highprice">
            <label>최저가순</label>
          </div>


          <div class="input-group-prepend">
            <input class="form-check-input" type="radio" name="exampleRadios" id="Radios2" value="lowprice">
            <label>최고가순</label>
          </div>


          <div class="input-group-prepend">
            <input class="form-check-input" type="radio" name="exampleRadios" id="Radios2" value="highsell">
            <label>판매량순</label>
          </div>
        </div>

        <!-- searchmain -->
        <c:forEach var="books" items="${books}">
        <div class="container mt-3" id="output">
          <div class="row">
            <div class="card shadow-sm col-lg-2 col-md-4 col-sm-4" onclick="location.href='bookInformation.do?bookID=${books.bookID}'">
              <div class="d-flex justify-content-center">
                <img src="img/books/${books.bookimg }" class="card-img-top searchimg" alt="..." height="200em">
              </div>
            </div>

            <div class="card shadow-sm col-lg-7 col-md-6 col-sm-8 d-flex" onclick="location.href='bookInformation.do?bookID=${books.bookID}'">
              <div class="ml-2">
                <label class="w-100 font-weight-bold">${books.bookName}</label>
                <label class="w-100">${books.bookWriter }</label>
                <label class="w-100">${books.bookPrice }</label>
              </div>
            </div>

            <div class="card shadow-sm col-lg-3 col-md-2 col-sm-4">
              <div class="row d-flex justify-content-center mt-2 mb-2">
              	<c:set var="i" value="${i+1}"/>
                <input type="text" class="text-center" id="hopeamount${i}" placeholder="희망수량">
                <input type="hidden" id="bookID${i}" value="${books.bookID}">
                <input type="hidden" id="bookName${i}" value="${books.bookName}">
                <input type="hidden" id="bookimg${i}" value="${books.bookimg}">   
                <input type="hidden" id="bookPrice${i}" value="${books.bookPrice}">         
              </div>

              <div class="row d-flex justify-content-center mt-2 mb-2">
                <button type="button" class="btn btn-secondary" onclick="cartIn(this.value)" value="${i}">장바구니</button>
              </div>

              <div class="row d-flex justify-content-center mt-2 mb-2">
                <button type="button" class="btn btn-secondary" onclick="requestPay(this.value);" value="${i}">바로구매</button>
              </div>
            </div>
          </div>
        </div>
        </c:forEach>
        <input type="hidden" id="memberID" value="${Smember.memberID}">  
        <!-- searchmain-end -->
      </main>
      <!-- main-end 여기까지!!-->
    </div>
    <!-- footer -->
        <jsp:include page="../layout/footer.jsp"/>
    <!-- footer-end -->
  </div>
<script> 
        //결제
        function requestPay(i) {
        	var login='<c:out value="${Smember.memberName}"/>';
        	var amount=$("#hopeamount"+i).val();
        	if(!login){
        		alert("로그인이 필요한 서비스입니다.");
        		location.href="signin.do";
        	}else{
        		if(!amount || amount==""){
        			alert("희망수량을 입력하세요");
        		}else{
        	var IMP = window.IMP; // 생략가능
    		IMP.init("imp81747761"); // 'iamport' 대신 부여받은 "가맹점 식별코드"를 사용
    		
    		IMP.request_pay({
    		    pg : 'html5_inicis', // version 1.1.0부터 지원.
    		    pay_method : 'card',
    		    merchant_uid : 'kabookja' + new Date().getTime(),
    		    name : $("#bookName"+i).val(),
    		    amount : $("#bookPrice"+i).val(),
    		    buyer_email : '',
    		    buyer_name : '<c:out value="${Smember.memberName}"/>',
    		    buyer_tel : '<c:out value="${Smember.memberPhoneNumber}"/>',
    		    buyer_addr : '<c:out value="${Smember.memberAddress}"/>',
    		    buyer_postcode : '',
    		    m_redirect_url : ''	// 결제 완료 후 보낼 컨트롤러의 메소드명
    		}, function(rsp) {
    		    if ( rsp.success ) {
    		    	var msg = '결제가 완료되었습니다.';
    		        msg += '고유ID : ' + rsp.imp_uid;
    		        msg += '상점 거래ID : ' + rsp.merchant_uid;
    		        msg += '결제 금액 : ' + rsp.paid_amount;
    		        msg += '카드 승인번호 : ' + rsp.apply_num;
    		        $.ajax({
    				    type: "POST",
    				    url: "PaymentReport_insert.do",
    				    data: {
    				    	"memberID": '<c:out value="${Smember.memberID}"/>',
    				       	"bookIDList": $("#bookID"+i).val(),
    				        "bookNameList": $("#bookName"+i).val(),
    				        "bookimgList": $("#bookimg"+i).val(),
    				        "bookStockList": $("#hopeamount"+i).val(),
    				        "bookPriceList": $("#bookPrice"+i).val(),
    				        "ShoppingDestination": '<c:out value="${Smember.memberAddress}"/>'
    				    },
    				    success: function (data) {
    				        if ($.trim(data) != "NO") {
    				        	 msg += '등록완료'
    				        	var memberID ='<c:out value="${Smember.memberID}"/>'
    				     		location.href="PaymentReportDetail.do?memberID="+memberID+"&date="+data;
    				        }else{
    				        	msg += '데이터등록실패!!';
    				        }
    				    },
    				    error: function(error){
    				    	alert("error");
    				    }
    				});
    		    } else {
    		        var msg = '결제에 실패하였습니다.';
    		        msg += '에러내용 : ' + rsp.error_msg;
    		    }
    		    
    		    alert(msg);
    		});	
        	}
        	}
        }
        
    </script>

</body>

</html>
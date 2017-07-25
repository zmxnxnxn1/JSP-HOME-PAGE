/**
 * 게시판의 덧글 관리 기능을 정의한 Javascript
 */
$(function() {
	
	// 현재 페이지의 URL얻기 
	var nowUrl = window.location.href;
	
	// 현재 URL에 "/bbs/read.jsp"라는 문자열이 포함되어 있지 않다면 처리를 중단시킨다.
	if (nowUrl.indexOf("/bbs/read.jsp") < 0) {
		return false;
	}
	
	//------------------------------------------------
	// 덧글 목록 조회 --> 페이지가 열리면서 실행된다.
	//------------------------------------------------
	var comment_url = $("#comment_list").data('list');
	
	$.get(comment_url, function(json) {
		var rt = json.rt;
		
		if (rt != "SUCCESS") {
			alert(rt);
			return false;
		}
		
		var comment_item = $("#tmpl_comment_item").tmpl(json.item);
		$('#comment_list').append(comment_item);
	});
	
	//------------------------------------------------
	// 덧글 저장 폼의 submit 이벤트
	//------------------------------------------------
	$("#comment_form").submit(function(event) {
		/** 폼 자체의 subimt 처리를 중단한다. */
		event.preventDefault();
		
		/** Ajax로 요청할 URL과 사용자 입력값 얻기 */
		// <form>의 action 속성값 가져오기
		var action = $(this).attr('action');
		// 모든 input 요소의 입력값들을 일괄적으로 가져오기
		var params = $(this).serialize();
		
		/** post 방식의 JSON 전송 */
		var ajax = $.post(action, params, function(json) {
			var rt = json.rt;
			
			// rt값이 "SUCCESS"가 아니라면 JSP안에서 예외가 발생하여
			// 처리가 중단된 경우이므로, 이 값을 표시하고 Javascript의 실행도 중단한다.
			if (rt != "SUCCESS") {
				alert(rt);
				return false;
			}
			
			// 작성이 완료되면 작성 결과가 JSON에 포함된다.
			// 그 내용을 jQuery의 템플릿 플러그인을 사용해서 출력한다.
			var comment_item = $("#tmpl_comment_item").tmpl(json.item);
			$('#comment_list').prepend(comment_item);
			
			// 폼을 리셋한다.
			$("#comment_form")[0].reset();
			
		});
		
		/** 서버 에러가 발생한 경우 */
		ajax.fail(function(err) {
			// 이 값이 404인 경우는 Page Not Found이므로 <form>의
			// action속성을 확인해야 한다.
			// 이 값이 500 이상인 경우는 Ajax로 호출하는 jsp 페이지에서 
			// 에러가 발생하고 있는 경우이다.
			var error_code = err.status;
			alert("덧글 저장에 실패했습니다. 관리자에게 문의 바랍니다. (" + error_code + ")");
		});
	});
	
	//------------------------------------------------
	// 덧글 삭제 modal창 처리
	//------------------------------------------------
	// 동적 modal의 사용을 위해 id속성값이 comment_delete_modal인 modal이 닫힐 때,
	// modal 안의 내용을 지운다.
	$(document).on('hidden.bs.modal', '#comment_delete_modal', function () {
		$(this).removeData('bs.modal');
	});

	//------------------------------------------------
	// 덧글 수정 modal창 처리
	//------------------------------------------------
	// 동적 modal의 사용을 위해 id속성값이 comment_edit_modal인 modal이 닫힐 때,
	// modal 안의 내용을 지운다.
	$(document).on('hidden.bs.modal', '#comment_edit_modal', function () {
		$(this).removeData('bs.modal');
	});
	
	//------------------------------------------------
	// 덧글 삭제 modal의 form 이벤트 정의
	//------------------------------------------------
	// HTML 초기 상태부터 존재하는 요소가 아니라 Javascript에 의해서 동적으로
	// 화면에 추가되는 요소이기 때문에 on 이벤트로 정의해야 한다.
	$(document).on('submit', '.delete_comment', function(event) {
		/** submit 이벤트의 페이지 이동 특성을 중지시킴 */
		event.preventDefault();
		
		/** Ajax로 요청할 URL과 사용자 입력값 얻기 */
		// <form>의 action 속성값 가져오기
		var action = $(this).attr('action');
		// 모든 input 요소의 입력값들을 일괄적으로 가져오기
		var params = $(this).serialize();
		// 삭제 대상 덧글 일련번호값을 가져온다. (name속성이 comment_id인 요소의 입력값)
		var comment_id = $(this).find('input[name="comment_id"]').val();
		
		/** post 방식의 JSON 전송 */
		var ajax = $.post(action, params, function(json) {
			var rt = json.rt;
			
			// rt값이 "SUCCESS"가 아니라면 JSP안에서 예외가 발생하여
			// 처리가 중단된 경우이므로, 이 값을 표시하고 Javascript의 실행도 중단한다.
			if (rt != "SUCCESS") {
				alert(rt);
				return false;
			}
			
			alert("덧글이 삭제되었습니다.");
			// #comment_list안에서 data-comment-id 속성값이 덧글 일련번호인 요소를 찾는다.
			var li = $('#comment_list').find('li[data-comment-id="' + comment_id + '"]');
			// 찾은 요소를 제거한다.
			li.remove();
			// 모달창을 닫는다.
			$('#comment_delete_modal').modal('hide');
		});
		
		/** 서버 에러가 발생한 경우 */
		ajax.fail(function(err) {
			var error_code = err.status;
			alert("덧글 삭제에 실패했습니다. 관리자에게 문의 바랍니다. (" + error_code + ")");
		});
	});

	
	//------------------------------------------------
	// 덧글 수정 modal의 form 이벤트 정의
	//------------------------------------------------
	// HTML 초기 상태부터 존재하는 요소가 아니라 Javascript에 의해서 동적으로
	// 화면에 추가되는 요소이기 때문에 on 이벤트로 정의해야 한다.
	// --> 삭제와 동일한 원리임
	$(document).on('submit', '.edit_comment', function(event) {
		/** submit 이벤트의 페이지 이동 특성을 중지시킴 */
		event.preventDefault();
		
		/** Ajax로 요청할 URL과 사용자 입력값 얻기 */
		// <form>의 action 속성값 가져오기
		var action = $(this).attr('action');
		// 모든 input 요소의 입력값들을 일괄적으로 가져오기
		var params = $(this).serialize();
		// 삭제 대상 덧글 일련번호값을 가져온다. (name속성이 comment_id인 요소의 입력값)
		var comment_id = $(this).find('input[name="comment_id"]').val();
		
		/** post 방식의 JSON 전송 */
		var ajax = $.post(action, params, function(json) {
			var rt = json.rt;
			
			// rt값이 "SUCCESS"가 아니라면 JSP안에서 예외가 발생하여
			// 처리가 중단된 경우이므로, 이 값을 표시하고 Javascript의 실행도 중단한다.
			if (rt != "SUCCESS") {
				alert(rt);
				return false;
			}
			
			alert("덧글이 수정되었습니다.");
			
			// 작성이 완료되면 작성 결과가 JSON에 포함된다.
			// 그 내용을 jQuery의 템플릿 플러그인을 사용해서 출력한다.
			var comment_item = $("#tmpl_comment_item").tmpl(json.item);
			// #comment_list안에서 data-comment-id 속성값이 덧글 일련번호인 요소를 찾는다.
			var li = $('#comment_list').find('li[data-comment-id="' + comment_id + '"]');
			// 찾은 요소 템플릿이 적용된 항목으로 교체한다.
			li.replaceWith(comment_item);
			// 모달창을 닫는다.
			$('#comment_edit_modal').modal('hide');
		});
		
		/** 서버 에러가 발생한 경우 */
		ajax.fail(function(err) {
			var error_code = err.status;
			alert("덧글 수정에 실패했습니다. 관리자에게 문의 바랍니다. (" + error_code + ")");
		});
	});
	
});
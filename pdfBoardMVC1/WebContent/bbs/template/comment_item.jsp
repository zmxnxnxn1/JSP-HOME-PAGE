<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>

<!-- 덧글 삭제 모달 -->
<div class="modal fade" id="comment_delete_modal" role="dialog" 
    aria-hidden="true">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
            <!-- 모달창 내용이 표시될 부분 -->

		</div>
	</div>
</div>

<!-- 덧글 수정 모달 -->
<div class="modal fade" id="comment_edit_modal" role="dialog" 
    aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
            <!-- 모달창 내용이 표시될 부분 -->

		</div>
	</div>
</div>

<!-- 덧글 항목에 대한 템플릿 참조 -->
<script id="tmpl_comment_item" type="text/x-jquery-tmpl">
    <li class="media" style='border-top: 1px dotted #ccc; padding-top: 15px' data-comment-id="{{html id}}">
        <div class="media-body" style='display: block;'>
            <h4 class="media-heading clearfix">
                <!-- 작성자,작성일시 -->
                <div class='pull-left'>
                    {{html writer_name}}
                    <small>
                        <a href='mailto:{{html email}}'>
                            <i class='glyphicon glyphicon-envelope'></i></a> / {{html reg_date}}
                    </small>
                </div>
                <!-- 수정,삭제 버튼 -->
                <div class='pull-right'>
                    <a href='ajax/comment_edit.jsp?comment_id={{html id}}'
						data-toggle="modal" data-target="#comment_edit_modal" 
						class='btn btn-info btn-xs'>
                        <i class='glyphicon glyphicon-edit'></i>
                    </a>
                    <a href='ajax/comment_delete.jsp?comment_id={{html id}}' 
						data-toggle="modal" data-target="#comment_delete_modal" 
						class='btn btn-danger btn-xs'>
                        <i class='glyphicon glyphicon-remove'></i>
                    </a>
                </div>
            </h4>
            <!-- 내용 -->
            <p>{{html content}}</p>
        </div>
    </li>
</script>
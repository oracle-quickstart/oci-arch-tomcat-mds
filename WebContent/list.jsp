<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/uikit@3.6.15/dist/css/uikit.min.css" />
<script
	src="https://cdn.jsdelivr.net/npm/uikit@3.6.15/dist/js/uikit.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/uikit@3.6.15/dist/js/uikit-icons.min.js"></script>

</head>

</head>
<body>



	<div
		class="uk-container uk-container-center uk-margin-top uk-margin-large-bottom">
		<jsp:include page="/common/header.jsp"></jsp:include>
		<div class="uk-grid" data-uk-grid-margin>
			<div class="uk-width-medium-1-1">

				<div class=" uk-text-left"
					style="background: url('https://developer.oracle.com/a/devo/images/ch12-developer-test.jpg') 50% 0 no-repeat; height: 450px;">
					<div class="uk-light ">
						<h3 class="uk-heading-medium uk-margin uk-width-1-1">Sample
							Todo Application</h3>
						<div class="uk-text-large uk-margin uk-width-1-1">Demo running
							Apache Tomcat & MySQL on ARM compute instances on OCI</div>
						<div class="uk-grid-small uk-child-width-auto" uk-grid>
							<div>
								<a class="uk-button uk-button-primary uk-button-large" href="#">Github</a>
							</div>
							<div>
								<a class="uk-button  uk-button-primary uk-button-large" href="#">Learn
									More</a>
							</div>
						</div>

					</div>
				</div>

			</div>
		</div>
		<div class="uk-container uk-container-center uk-margin-top uk-margin-large-bottom">
			<h3 class="text-center">List of Todos</h3>
			<hr>
			<div class="uk-margin">

				<a class="uk-button uk-button-default" href="<%=request.getContextPath()%>/new" class="btn btn-success">Add
					Todo</a>
			</div>
			<br>
			<div class="uk-flex uk-align-center uk-flex-column uk-width-1-2"
				uk-grid>
				<c:forEach var="todo" items="${listTodo}">
					<form>
						<input type="hidden" name="id"
							value="<c:out value='${todo.id}' />" />
						<div
							class="uk-card uk-card-default uk-width-large uk-margin-auto uk-box-shadow-large"
							uk-scrollspy=" cls: uk-animation-fade; delay: 200;repeat: true">
							<div class="uk-card-body">
								<div uk-grid>
									<div class="uk-width-expand">
										<h3 class="uk-card-title uk-margin-remove-bottom">
											<c:out value="${todo.title}" />
										</h3>
									</div>
									<div class="uk-width-auto">
										<a uk-icon="close"></a>
									</div>
								</div>
								<p>
									<c:out value="${todo.description}" />
								</p>
							</div>
							<div
								class="uk-card-footer uk-background-muted uk-flex uk-flex-middle uk-flex-right@s">
								<div uk-grid class="uk-flex-middle uk-grid-small">
									<div class="uk-flex-last@s">
										<div class="uk-inline">
											<a href="delete?id=<c:out value='${todo.id}' />"
												class="uk-button uk-button-danger  uk-icon-link"
												uk-icon="trash" type="button">Delete</a>
											<div uk-dropdown>Delete this Todo. This action cannot
												be undone.</div>
										</div>
									</div>
									<div class="uk-flex-first@s">
										<div class="uk-inline">
											<a href="edit?id=<c:out value='${todo.id}' />"
												class="uk-button  uk-icon-link" uk-icon="pencil"
												type="button">Edit</a>
											<div
												uk-dropdown="animation: uk-animation-slide-top-small; duration: 1000">Make
												changes to the entry.</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</form>



				</c:forEach>
			</div>
		</div>
	</div>


	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>
</html>
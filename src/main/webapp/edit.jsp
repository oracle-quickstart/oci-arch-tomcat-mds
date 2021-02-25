<!-- Copyright (c) 2021 Oracle and/or its affiliates. All rights reserved. -->
<!-- Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl. -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
  <head>
    <title>Edit Todo Item</title>
    <link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/uikit@3.6.15/dist/css/uikit.min.css" />
    <script
      src="https://cdn.jsdelivr.net/npm/uikit@3.6.15/dist/js/uikit.min.js"></script>
    <script
      src="https://cdn.jsdelivr.net/npm/uikit@3.6.15/dist/js/uikit-icons.min.js"></script>
  </head>
  <body>
    <div
      class="uk-container uk-container-center uk-margin-top uk-margin-large-bottom">
      <jsp:include page="/common/header.jsp"></jsp:include>
      <div
        class="uk-card uk-card-default uk-width-xlarge uk-margin-auto uk-box-shadow-large">
        <div class="uk-card-body">
          <c:if test="${todo != null}">
            <form action="update" method="post">
          </c:if>
          <c:if test="${todo == null}">
          	<form action="insert" method="post">
          </c:if>
          <caption>
	        <h2>
	          <c:if test="${todo != null}">
	          	<legend class="uk-legend">Edit ${todo.title} </legend>
	          </c:if>
	          <c:if test="${todo == null}">
	          		<legend class="uk-legend">Add a Todo note</legend>
	          </c:if>
	        </h2>
          </caption>
          <c:if test="${todo != null}">
            <input type="hidden" name="id" value="<c:out value='${todo.id}' />" />
          </c:if>
          <fieldset class="uk-fieldset">
	          <div class="uk-margin">
	            <input class="uk-input" name="title" type="text" placeholder="Title" value="<c:out value='${todo.title}' />">
	          </div>
	          <div class="uk-margin">
	            <textarea class="uk-textarea" name="description" rows="5" placeholder="Description"><c:out value='${todo.description}' /></textarea>
	          </div>
	          <c:if test="${todo != null}">
	            <div class="uk-margin uk-grid-small uk-child-width-auto uk-grid">
	              <label>
	                <input class="uk-checkbox" name="isDone" type="checkbox" <c:if test="${todo.status}">checked</c:if>/>
	                Mark as complete
	              </label> 
	            </div>
	          </c:if>
          </fieldset>
          	<button class="uk-button uk-button-default" type="submit" >Save</button>
          </form>
        </div>
      </div>
    </div>
    <jsp:include page="/common/footer.jsp"></jsp:include>
  </body>
</html>


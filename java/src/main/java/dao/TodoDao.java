// Copyright (c) 2021 Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
package dao;

import java.sql.SQLException;
import java.util.List;

import model.Todo;

public interface TodoDao {

	void insertTodo(Todo todo) throws SQLException;

	Todo selectTodo(long todoId);

	List<Todo> selectAllTodos();

	boolean deleteTodo(int id) throws SQLException;

	boolean updateTodo(Todo todo) throws SQLException;

}
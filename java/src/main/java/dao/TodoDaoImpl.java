// Copyright (c) 2021 Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
package dao;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import model.Todo;
import utils.JDBCUtils;



public class TodoDaoImpl implements TodoDao {
	
	private final String jdbcUrl;
	private final String dbUser;
	private final String dbPassword;

	private static final String INSERT_TODOS_SQL = "INSERT INTO todos"
			+ "  (title, description,  is_done) VALUES " + " (?, ?, ?);";

	private static final String SELECT_TODO_BY_ID = "select id,title,description,is_done from todos where id =?";
	private static final String SELECT_ALL_TODOS = "select * from todos";
	private static final String DELETE_TODO_BY_ID = "delete from todos where id = ?;";
	private static final String UPDATE_TODO = "update todos set title = ?,  description =?, is_done = ? where id = ?;";

	public TodoDaoImpl() throws IOException {
		Properties props = new Properties();
		props.load(JDBCUtils.class.getResourceAsStream("/todo.properties"));
		jdbcUrl = props.getProperty("jdbcurl");
		dbUser =  props.getProperty("database_user");
		dbPassword = props.getProperty("database_password");
	}

	@Override
	public void insertTodo(Todo todo) throws SQLException {
		System.out.println(INSERT_TODOS_SQL);
		// try-with-resource statement will auto close the connection.
		try (Connection connection = JDBCUtils.getConnection(jdbcUrl, dbUser, dbPassword);
				PreparedStatement preparedStatement = connection.prepareStatement(INSERT_TODOS_SQL)) {
			preparedStatement.setString(1, todo.getTitle());
			preparedStatement.setString(2, todo.getDescription());
			preparedStatement.setBoolean(3, todo.getStatus());
			System.out.println(preparedStatement);
			preparedStatement.executeUpdate();
		} catch (SQLException exception) {
			JDBCUtils.printSQLException(exception);
		}
	}

	@Override
	public Todo selectTodo(long todoId) {
		Todo todo = null;
		// Step 1: Establishing a Connection
		try (Connection connection = JDBCUtils.getConnection(jdbcUrl, dbUser, dbPassword);
				// Step 2:Create a statement using connection object
				PreparedStatement preparedStatement = connection.prepareStatement(SELECT_TODO_BY_ID);) {
			preparedStatement.setLong(1, todoId);
			System.out.println(preparedStatement);
			// Step 3: Execute the query or update query
			ResultSet rs = preparedStatement.executeQuery();

			// Step 4: Process the ResultSet object.
			while (rs.next()) {
				long id = rs.getLong("id");
				String title = rs.getString("title");
				String description = rs.getString("description");
				boolean isDone = rs.getBoolean("is_done");
				todo = new Todo(id, title, description, isDone);
			}
		} catch (SQLException exception) {
			JDBCUtils.printSQLException(exception);
		}
		return todo;
	}

	@Override
	public List<Todo> selectAllTodos() {

		// using try-with-resources to avoid closing resources (boiler plate code)
		List<Todo> todos = new ArrayList<>();

		// Step 1: Establishing a Connection
		try (Connection connection = JDBCUtils.getConnection(jdbcUrl, dbUser, dbPassword);

				// Step 2:Create a statement using connection object
				PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_TODOS);) {
			System.out.println(preparedStatement);
			// Step 3: Execute the query or update query
			ResultSet rs = preparedStatement.executeQuery();

			// Step 4: Process the ResultSet object.
			while (rs.next()) {
				long id = rs.getLong("id");
				String title = rs.getString("title");
				String description = rs.getString("description");
				boolean isDone = rs.getBoolean("is_done");
				Todo todo = new Todo(id, title, description, isDone);
				todos.add(todo);
				System.out.println(todo);

			}
		} catch (SQLException exception) {
			JDBCUtils.printSQLException(exception);
		}
		
		return todos;
	}

	@Override
	public boolean deleteTodo(int id) throws SQLException {
		boolean rowDeleted;
		try (Connection connection = JDBCUtils.getConnection(jdbcUrl, dbUser, dbPassword);
				PreparedStatement statement = connection.prepareStatement(DELETE_TODO_BY_ID);) {
			statement.setInt(1, id);
			rowDeleted = statement.executeUpdate() > 0;
		}
		return rowDeleted;
	}

	@Override
	public boolean updateTodo(Todo todo) throws SQLException {
		boolean rowUpdated;
		System.out.println("Updating :"+todo);
		try (Connection connection = JDBCUtils.getConnection(jdbcUrl, dbUser, dbPassword);
				PreparedStatement statement = connection.prepareStatement(UPDATE_TODO);) {
			statement.setString(1, todo.getTitle());
			statement.setString(2, todo.getDescription());
			statement.setBoolean(3, todo.getStatus());
			statement.setLong(4, todo.getId());
			rowUpdated = statement.executeUpdate() > 0;
		}
		return rowUpdated;
	}
}
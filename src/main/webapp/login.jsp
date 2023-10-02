<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Вход</title>
</head>
<body>
<h2>Вход</h2>
<form action="login" method="post">
  <label for="username">Логин:</label>
  <input type="text" id="username" name="username" required><br><br>
  <label for="password">Пароль:</label>
  <input type="password" id="password" name="password" required><br><br>
  <input type="submit" value="Войти">
</form>
<p>Еще нет аккаунта? <a href="register.jsp">Зарегистрироваться</a></p>
</body>
</html>
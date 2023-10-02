<%@ page language="java" contentType="text/html; charset=UTF-8" import="java.nio.file.Files,java.io.File" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>File Manager</title>
    <style>
        body{
            font-family: "JetBrains Mono",monospace;

        }
        button {
            align-items: center;
            appearance: none;
            background-color: #FCFCFD;
            border-radius: 4px;
            border-width: 0;
            box-shadow: rgba(45, 35, 66, 0.4) 0 2px 4px,rgba(45, 35, 66, 0.3) 0 7px 13px -3px,#D6D6E7 0 -3px 0 inset;
            box-sizing: border-box;
            color: #36395A;
            cursor: pointer;
            display: inline-flex;
            font-family: "JetBrains Mono",monospace;
            height: 48px;
            justify-content: center;
            line-height: 1;
            list-style: none;
            overflow: hidden;
            padding-left: 16px;
            padding-right: 16px;
            position: relative;
            text-align: left;
            text-decoration: none;
            transition: box-shadow .15s,transform .15s;
            user-select: none;
            -webkit-user-select: none;
            touch-action: manipulation;
            white-space: nowrap;
            will-change: box-shadow,transform;
            font-size: 18px;
        }

        button:focus {
            box-shadow: #D6D6E7 0 0 0 1.5px inset, rgba(45, 35, 66, 0.4) 0 2px 4px, rgba(45, 35, 66, 0.3) 0 7px 13px -3px, #D6D6E7 0 -3px 0 inset;
        }

        button:hover {
            box-shadow: rgba(45, 35, 66, 0.4) 0 4px 8px, rgba(45, 35, 66, 0.3) 0 7px 13px -3px, #D6D6E7 0 -3px 0 inset;
            transform: translateY(-2px);
        }

        button:active {
            box-shadow: #D6D6E7 0 3px 7px inset;
            transform: translateY(2px);
        }

        button:hover {
            background-color: #6495ED;
        }

        .cuttedText {
            display: block;
            max-width: 220px;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        .typewriter{
            overflow: hidden;
            white-space: nowrap;
            margin: 0 auto;
            letter-spacing: .15em;
            animation: typing 2.0s steps(30, end), blink-caret .5s step-end infinite;
        }

        @keyframes typing {
            from { width: 0 }
            to { width: 100% }
        }

        @keyframes blink-caret {
            from, to { border-color: transparent }
            50% { border-color: orange }
        }

        table {
            border-collapse: collapse; /* Отображать двойные линии как одинарные */
        }

        th {
            text-align: center;
        }
        td, th {
            border-left: 1px solid #e9e9e9;
            border-right: 1px solid #e9e9e9;
        }

    </style>
</head>
<body>
<p class="typewriter">${createDatingPage}</p>
<h1 class="typewriter">${path}</h1>
<hr />

<form style="display: ${directoryVisibilityOnTop};" action="./main-servlet" method="get">
    <button type="submit" name="path" value="${backToParent}">
        <span class="cuttedText">⬆  Назад</span>
    </button>
</form>

<table>
    <tr>
        <th class="th-first">Файл</th>
        <th style="padding: 0 30px 0 30px;">Размер</th>
        <th style="padding: 0 100px 0 100px;">Дата</th>
    </tr>

    <form action="./main-servlet" method="get">
        <c:forEach var="directory" items="${directories}">
            <tr class="table__row">
                <td >
                    <button type="submit" name="path" value="${directory.getAbsolutePath()}">
                        <span class="cuttedText">📁 ${directory.getName()}/</span>
                    </button>
                </td>
                <td><span class="cuttedText"></span></td>
                <td>
              <span class="cuttedText">${Files.getAttribute(directory.toPath(),"lastModifiedTime").toString()}</span>
                </td>
            </tr>
        </c:forEach>
    </form>

    <form action="./main-servlet/download" method="post">
        <c:forEach var="file" items="${files}">
            <tr class="table__row">
                <td>
                    <button type="submit" name="path" value="${file.getPath()}">
                        <span class="cuttedText">📄 ${file.getName()}</span>
                    </button>
                </td>
                <td>
                    <span class="cuttedText">${Files.size(file.toPath())} B</span>
                </td>
                <td>
              <span class="cuttedText">${Files.getAttribute(file.toPath(), "lastModifiedTime").toString()}</span>
                </td>
            </tr>
        </c:forEach>
    </form>

    <!-- Кнопка "Выход" -->
    <form action="logout" method="post">
        <button type="submit">Выход</button>
    </form>
</table>
</body>
</html>
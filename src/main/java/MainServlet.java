import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/main-servlet"})
public class MainServlet extends HttpServlet {
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        log("All Fine!");
    }

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.service(req, resp);
        resp.getWriter().write("\nMethod Service");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        // Проверка, залогинен ли пользователь
        String username = (String) session.getAttribute("username");
        if (username == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // Время когда появляется страница
        String createDatingPage = DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm:ss").format(LocalDateTime.now());
        req.setAttribute("createDatingPage", createDatingPage);

        // Текущая отображаемая директория
        String path = getCurrentPath(req, resp);
        if (path == null) return;

        // Проверка доступа пользователя к текущей директории
        if (!hasAccessToDirectory(username, path)) {
            // Если пользователь не имеет доступа, перенаправить его на страницу своей "домашней папки"
            String homeDirectory = "c:/Users/Student/filemanager/" + username; // Путь к домашней папке пользователя
            resp.sendRedirect("main-servlet?path=" + URLEncoder.encode(homeDirectory, StandardCharsets.UTF_8.toString()));
            return;
        }

        // Переход к родительской директории
        String backToParent = new File(path).getParent();
        if (backToParent != null) {
            req.setAttribute("directoryVisibilityOnTop", "block");
            req.setAttribute("backToParent", backToParent);
        } else {
            req.setAttribute("directoryVisibilityOnTop", "none");
        }

        // Таблица с содержимым текущей директории
        outputContentsDir(req, path);

        getServletContext().getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    private boolean hasAccessToDirectory(String username, String directoryPath) {
        // Ваша логика проверки доступа, например, сравнение директории с "домашней папкой" пользователя
        String userHomeDirectory = "c:/Users/Student/filemanager/" + username; // Здесь укажите путь к домашней папке пользователя
        return directoryPath.startsWith(userHomeDirectory);
    }

    private static String getCurrentPath(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String path = req.getParameter("path");
        if (path == null) {
            path = System.getProperty("user.dir");
            resp.sendRedirect(String.format("%s%s?path=%s",
                    req.getContextPath(),
                    req.getServletPath(),
                    URLEncoder.encode(path, StandardCharsets.UTF_8.toString())));
            return null;
        }
        req.setAttribute("path", path);
        return path;
    }

    private void outputContentsDir(HttpServletRequest req, String path) {
        File f = new File(path);
        File[] allFiles = f.listFiles();

        if (allFiles != null) {
            List<File> directories = new ArrayList<>();
            List<File> files = new ArrayList<>();

            for (File file : allFiles) {
                if (file.getPath() != null) {
                    if (file.isDirectory())
                        directories.add(file);
                    else
                        files.add(file);
                }
            }

            req.setAttribute("directories", directories);
            req.setAttribute("files", files);
        }
    }


    @Override
    public void destroy() {
        super.destroy();
    }
}

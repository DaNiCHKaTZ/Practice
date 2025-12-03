````Java script
// 1 уровень

const http = require("http");
const fs = require("fs");

const server = http.createServer((req, res) => {
    const url = req.url;
    const method = req.method;
    const route = `${method} ${url}`;

    switch (route) {
        case "GET /": {
            res.setHeader('Content-Type', 'text/plain');
            res.statusCode = 200;
            res.write("Server is running");
            res.end();
            break;
        }

        case "GET /users": {
            try {
                const data = fs.readFileSync("users.json");
                const users = JSON.parse(data);
                res.setHeader('Content-Type', 'application/json');
                res.statusCode = 200;
                res.write(JSON.stringify(users));
                res.end();
            } catch (error) {
                res.setHeader('Content-Type', 'text/plain');
                res.statusCode = 500;
                res.write("Server error. Cannot read users");
                res.end();
            }
            break;
        }

        default: {
            res.setHeader('Content-Type', 'text/plain');
            res.statusCode = 404;
            res.write("Not found");
            res.end();
            break;
        }
    }
});

server.listen(3000, () => {
    console.log("Server is running on port 3000");
});

// 2 уровень 

const http = require("http");
const fs = require("fs");
const path = require("path");
const dirName = path.join(__dirname, "data");
const usersFile = path.join(dirName, "users.json");
if (!fs.existsSync(dirName)) {
    fs.mkdirSync(dirName, { recursive: true });
}
if (!fs.existsSync(usersFile)) {
    fs.writeFileSync(usersFile, JSON.stringify([], null, 2), "utf-8");
}

const server = http.createServer((req, res) => {
    const url = req.url;
    const method = req.method;
    const route = `${method} ${url}`;

    switch (route) {
        case "GET /": {
            res.setHeader('Content-Type', 'text/plain');
            res.statusCode = 200;
            res.write("API is running");
            res.end();
            break;
        }

        case "GET /users": {
            try {
                const data = fs.readFileSync(usersFile, "utf-8");
                const users = JSON.parse(data);
                res.setHeader('Content-Type', 'application/json');
                res.statusCode = 200;
                res.write(JSON.stringify(users));
                res.end();
            } catch (error) {
                res.setHeader('Content-Type', 'application/json');
                res.statusCode = 500;
                res.write(JSON.stringify({ error: "Server error. Cannot read users" }));
                res.end();
            }
            break;
        }

        case "POST /users": {
            
            if (req.headers["content-type"] !== "application/json") {
                res.setHeader('Content-Type', 'application/json');
                res.statusCode = 415;
                res.write(JSON.stringify({ error: "Content-Type must be application/json" }));
                res.end();
                break;
            }

            let body = "";
            req.on("data", (chunk) => {
                body += chunk.toString();
            });
            req.on("end", () => {
                try {
                    const user = JSON.parse(body);
                    if (!user.name) {
                        res.setHeader('Content-Type', 'application/json');
                        res.statusCode = 400;
                        res.write(JSON.stringify({ error: "Name is required" }));
                        res.end();
                        return;
                    }
                    const data = fs.readFileSync(usersFile, "utf-8");
                    const users = JSON.parse(data);
                    const newId = Date.now().toString();
                    const newUser = { id: newId, ...user };
                    users.push(newUser);
                    fs.writeFileSync(usersFile, JSON.stringify(users, null, 2), "utf-8");
                    res.setHeader('Content-Type', 'application/json');
                    res.statusCode = 201;
                    res.write(JSON.stringify(newUser));
                    res.end();
                } catch (error) {
                    if (error instanceof SyntaxError) {
                        res.setHeader('Content-Type', 'application/json');
                        res.statusCode = 400;
                        res.write(JSON.stringify({ error: "Invalid JSON" }));
                        res.end();
                    } else {
                        res.setHeader('Content-Type', 'application/json');
                        res.statusCode = 500;
                        res.write(JSON.stringify({ error: "Server error" }));
                        res.end();
                    }
                }
            });
            break;
        }

        default: {
            res.setHeader('Content-Type', 'application/json');
            res.statusCode = 404;
            res.write(JSON.stringify({ error: "Not found" }));
            res.end();
            break;
        }
    }
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});

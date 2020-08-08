import * as HTTP from "http";
import Console from "console";
import Process from "process";

const port = Process.env.PORT;

const server = HTTP.createServer((_, response) => {
  response.statusCode = 200;
  response.write(JSON.stringify({ message: "Hello World" }));
  response.end();
});

server
  .listen(port)
  .once("listening", () => Console.debug("Server running on port %d", port));

Process.on("SIGTERM", () => {
  Console.debug("Server stopped");
  Process.exit(0);
});

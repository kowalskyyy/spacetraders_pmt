"use strict";

const webApp = require("./server/app.js")();

const httpPort = 8088;

(function createHttpServer() {
	const app = webApp.start;
	app.listen(httpPort);
})();

process.on("exit", function (code) {
	console.info("Server exit.");
});

process.on("SIGINT", function () {
	console.info("Got SIGINT.");
	setTimeout(() => process.exit(0), 100);
});

process.on("uncaughtException", function (error) {
	const msg = error && error.message ? error.message : error || "FATAL!";
	console.error(msg, error);
	setTimeout(() => process.exit(0), 100);
});

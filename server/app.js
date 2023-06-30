"use strict";

const express = require("express"),
	bodyParser = require("body-parser"),
	compress = require("compression"),
	morgan = require("morgan"),
	cookieParser = require("cookie-parser"),
	routes = require("./routes.js");

function noHttpCache(req, res, next) {
	res.header("Surrogate-Control", "no-store");
	res.header(
		"Cache-Control",
		"no-store, no-cache, must-revalidate, proxy-revalidate"
	);
	res.header("Pragma", "no-cache");
	res.header("Expires", "0");
	next();
}

function setupExpress() {
	const app = express();
	app.enable("trust proxy");
	app.use(compress());
	app.use(morgan("short"));
	app.use(bodyParser.urlencoded({ extended: true }));
	app.use(bodyParser.json({ limit: "5mb" }));
	app.use("/login/api", noHttpCache);
	app.use(cookieParser());

	return app;
}

function create(config) {
	const app = setupExpress();
	routes(app);

	return {
		start: app,
	};
}

module.exports = create;

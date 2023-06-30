"use strict";

const path = require("path");

const sendIndexFile = (req, res) => {
	res.sendFile(path.join(__dirname, "../client/dist/index.html"));
};

const addRoutes = (router, config, passport, multiSamlStrategy) => {
	router.use("/", (req, res) => res.send("pong"));
	router.get("/*", sendIndexFile);
};

module.exports = function (app) {
	const express = require("express");
	const router = express.Router();

	addRoutes(router);
	app.use("/", express.static("./client/dist"));
	app.use("/api", router);
};

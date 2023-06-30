"use strict";

const express = require("express"),
	http = require("axios").create({
		timeout: 15 * 1000,
	}),
	config = require("./apiConfig.json"),
	baseUrl = "https://api.spacetraders.io/v2",
	options = {
		headers: {
			"Content-Type": "application/json",
			Authorization: `Bearer ${config.token}`,
		},
	};

function do_(action) {
	return async (req, res) => {
		const response = await action(req, res);
		const { status, statusText, data } = response;
		if (status >= 400) {
			throw new Error(statusText);
		}
		return data;
	};
}

async function getFactions(req, res) {
	const url = `${baseUrl}/my/factions`;

	const result = await http.get(url, options);
	res.json(result);
}

function getWaypoint(systemSymbol, waypointSymbol) {
	const url = `${baseUrl}/systems/${systemSymbol}/waypoints/${waypointSymbol}`;

	return http.get(url, options);
}

const routesMap = {
	"my/factions": { get: getFactions },
	"systems/:systemSymbol/waypoints/:waypointSymbol": { get: getWaypoint },
};

function routeGenerator() {
	const router = express.Router();
	Object.keys(routesMap).forEach((route) => {
		Object.keys(route).forEach((method) => {
			router[method](
				route,
				do_(() => routesMap[route][method])
			);
		});
	});

	return router;
}

module.exports = routeGenerator;

getFactions("X1-DF55-20250Z", "X1-DF55-20250Z")
	.then((result) => {
		console.log(`Result is ${result}`);
	})
	.then(() => {
		console.log(`${new Date().toISOString()} Done!`);
		process.exit(0);
	})
	.catch((err) => {
		console.log(`${new Date().toISOString()} ERROR`, err.stack || err);
		process.exit(1);
	});

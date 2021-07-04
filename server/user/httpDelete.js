'use strict';

module.exports.handler = async (event) => {

  const body = event.body;
  const params = event.pathParameters;

  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: `httpDelete executed successfully!`,
        params,
        body
      },
      null,
      2
    ),
  };
}
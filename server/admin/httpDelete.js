'use strict';

module.exports = async (event) => {

  const body = JSON.parse(event.body);
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
'use strict';

module.exports.handler = async (event) => {

  const body = event.body;
  const params = event.pathParameters;

  return {
    statusCode: 200,
    body: {
      message: `httpPost executed successfully!`,
      params,
      body
    }
    // body: JSON.stringify(
    //   {
    //     message: `httpPost executed successfully!`,
    //     params,
    //     body
    //   },
    //   null,
    //   2
    // ),
  };
}